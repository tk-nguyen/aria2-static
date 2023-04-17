#!/usr/bin/env bash
set -eux
set -o pipefail
export DEBIAN_FRONTEND=noninteractive 
apt update && apt install -y build-essential curl git libssh2-1-dev libc-ares-dev libexpat1-dev zlib1g-dev libsqlite3-dev pkg-config liblzma-dev autotools-dev autoconf autopoint libtool

