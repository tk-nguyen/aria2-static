FROM ubuntu:latest AS build

ARG TARGETPLATFORM
ARG OPENSSL_VERSION
ARG ARIA2_VERSION
ARG OPENSSL_DIR

COPY scripts scripts

RUN scripts/install-deps.sh && \
    scripts/build-openssl.sh && \
    scripts/build-aria2.sh

FROM scratch
COPY --from=build /aria2c* .
