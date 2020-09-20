# Docker OpenWrt Builder

Build [OpenWrt](https://openwrt.org/) images in a Docker container. 

The docker image is based on Debian 10 (Buster).

Build tested:

- OpenWrt-19.07.4

A smaller container based on Alpine Linux is available in the alpine branch. But it does not build the old LEDE images.

## Prerequisites

* Docker / Podman installed
* build Docker image:

```
docker build -t openwrt_builder .
```

Now the docker image is available. These steps only need to be done once.

## Usage GNU/Linux

Create a build folder and link it into a new docker container:
```
mkdir ~/mybuild
docker run -v ~/mybuild:/home/user -it openwrt_builder /bin/bash
```

In the container console, enter:
```
git clone https://git.openwrt.org/openwrt/openwrt.git
cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
make -j$(nproc) V=s
```

After the build, the images will be inside `~/mybuild/openwrt/bin/target/`.

## Usage MacOSX

OpenWrt requires a case-sensitive filesystem while MacOSX uses a case-insensitive filesystem by default.

Create a disk image:
```
hdiutil create -size 20g -fs "Case-sensitive HFS+" -volname OpenWrt OpenWrt.dmg hdiutil attach OpenWrt.dmg
```

Then run:
```
docker run -v /volumes/openwrt:/home/user -it openwrt_builder /bin/bash
```

([Source](https://openwrt.org/docs/guide-developer/easy.build.macosx))

## Other Projects

Other, but very similar projects:
* [docker-openwrt-buildroot](https://github.com/noonien/docker-openwrt-buildroot)
* [openwrt-docker-toolchain](https://github.com/mchsk/openwrt-docker-toolchain)

