#!/usr/bin/env bash
set -eux
set -o pipefail

check() {
    if [[ -z "$OPENSSL_VERSION" ]]; then
        echo 'No OpenSSL version specified. Please specify an OpenSSL version as `OPENSSL_VERSION` environment variable e.g. `OPENSSL_VERSION=3.1.0` or `OPENSSL_VERSION=1.1.1t`' >&2
        exit 1
    fi
}

build() {
    echo "Building OpenSSL $OPENSSL_VERSION"
    case $OPENSSL_VERSION in
        1.*)
            curl -sSL "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" | tar xzvf -
            cd "openssl-$OPENSSL_VERSION"
            ./Configure no-shared --openssldir=/etc/ssl
            make && make install
            ;;
        3.*)
            curl -sSL "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" | tar xzvf -
            cd "openssl-$OPENSSL_VERSION"
            ./Configure no-module no-shared --openssldir=/etc/ssl
            make && make install
            ;;
    esac
}
check
build
