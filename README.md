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

Supported architectures (note that both `linux/arm/v7` and `linux/arm/v6` can be specified with `arm`): 
```json
{
  "supported": [
    "linux/amd64",
    "linux/arm64",
    "linux/riscv64",
    "linux/ppc64le",
    "linux/s390x", 
    "linux/386",
    "linux/arm/v7",
    "linux/arm/v6"
  ],
  "emulators": [
    "qemu-aarch64",
    "qemu-arm",
    "qemu-i386",
    "qemu-ppc64le",
    "qemu-riscv64",
    "qemu-s390x"
  ]
}
```
2. Create a new builder with `docker-container` driver:
```bash
docker buildx create --name multiplatform --driver docker-container --bootstrap --use
docker buildx ls
```
3. Set the `PLATFORMS` environment variable to comma-seperated Docker platforms identifiers, for example: `PLATFORMS="linux/amd64,linux/arm64"`
4. Run `docker buildx bake`. The resulting binaries should be in the `build` folder.

You can combine step 3 and 4 by specifying `PLATFORMS` before the `docker` command: `PLATFORMS="linux/amd64,linux/arm64" docker buildx bake`

## License
`aria2` is [licensed under GPL-2.0](https://github.com/aria2/aria2/blob/f4cbc7bb315b1687679e6ab94648c2685a9e9668/COPYING)