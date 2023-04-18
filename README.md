# Static builds of aria2 
[Aria2](https://github.com/aria2/aria2) is a powerful, lightweight multi-protocol & multi-source, cross platform download utility operated in command-line.

This repository contains the [scripts](scripts) to build aria2 statically (only on Linux).

It also contains a [patch](scripts/unlimited-connections.patch) to remove max connection limits. (See https://github.com/aria2/aria2/issues/580#issuecomment-190690251)

## Build
If you want to build `aria2` statically yourself, [install Docker](https://docs.docker.com/engine/install/) and run `docker buildx bake`. The `aria2c` binary should be under the `build` directory.

## Cross-platform build
Docker supports [multi-platform builds](https://docs.docker.com/build/building/multi-platform/). Here we're going to use QEMU emulation support in the kernel.

1. If you are using [Docker Desktop](https://www.docker.com/products/docker-desktop/), you can skip this step. Else, install `qemu` binaries for other architecture:
```bash
docker run --privileged --rm tonistiigi/binfmt --install all
```
Or, if you want to only install for some architectures:
```bash
docker run --privileged --rm tonistiigi/binfmt --install arm64,amd64,arm
```
Supported architectures (note that`linux/arm/v7` can be specified with `arm`): 
```json
{
  "supported": [
    "linux/amd64",
    "linux/arm64",
    "linux/ppc64le",
    "linux/s390x", 
    "linux/arm/v7",
  ],
  "emulators": [
    "qemu-aarch64",
    "qemu-arm",
    "qemu-ppc64le",
    "qemu-s390x"
  ]
}
```
This is actually the list of supported `ubuntu` docker image architectures (See https://hub.docker.com/_/ubuntu/tags)

2. Create a new builder with `docker-container` driver:
```bash
docker buildx create --name multiplatform --driver docker-container --bootstrap --use
docker buildx ls
```

3. Set the `PLATFORMS` environment variable to comma-seperated Docker platforms identifiers, for example: `PLATFORMS="linux/amd64,linux/arm64"`. You can specify a single platform, e.g: `PLATFORMS="linux/amd64"`.

4. Set the `OS_TYPE` environment variable to the target platform you want to build, for example: `OS_TYPE=debian` or `OS_TYPE=rhel`. It's case insensitive.

5. Run `docker buildx bake`. The resulting binaries should be in the `build` folder.

You can combine step 3 and 4 by specifying `PLATFORMS` and `OS_TYPE` before the `docker` command: `PLATFORMS="linux/amd64,linux/arm64" OS_TYPE="debian" docker buildx bake`.

List of all default values:
- `PLATFORMS`: `linux/amd64`
- `OS_TYPE`: `debian`.
- `OPENSSL_VERSION`: [`3.1.0`](https://github.com/openssl/openssl/releases/tag/openssl-3.1.0).
- `ARIA2_VERSION`: [`1.36.0`](https://github.com/aria2/aria2/releases/tag/release-1.36.0).

## License
`aria2` is [licensed under GPL-2.0](https://github.com/aria2/aria2/blob/f4cbc7bb315b1687679e6ab94648c2685a9e9668/COPYING)