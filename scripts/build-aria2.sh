#!/usr/bin/env bash
set -eux
set -o pipefail
check() {
    if [[ -z "$ARIA2_VERSION" ]]; then
        echo 'No aria2 version specified. Please specify an aria2 version as `ARIA2_VERSION` environment variable e.g. `ARIA2_VERSION=1.36.0`' >&2
        exit 1
    fi
}

build() {
    echo "Building aria2 $ARIA2_VERSION"
    curl -sSL "https://github.com/aria2/aria2/releases/download/release-$ARIA2_VERSION/aria2-$ARIA2_VERSION.tar.gz" | tar xzvf -
    cd "aria2-$ARIA2_VERSION"
    git apply /scripts/unlimited-connections.patch
    autoreconf -i
    PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig" ./configure ARIA2_STATIC=yes
    make && strip src/aria2c
    local platform=${TARGETPLATFORM}
    cp src/aria2c /aria2c-${platform//\//-}
}
check
build
