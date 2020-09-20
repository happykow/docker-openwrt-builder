#!/bin/bash

# https://openwrt.org/docs/guide-developer/build-system/use-buildsystem#custom_files

BUILD_DIR=~/wrtbuild
WRT_VERSION='19.07.4'
DOCKER_CMD='podman'
IMAGE_NAME=openwrt-builder

# pull image
${DOCKER_CMD} pull debian:buster

# builder container 
${DOCKER_CMD} build -t ${IMAGE_NAME} .

# run shell in container
[ ! -d ${BUILD_DIR} ] && mkdir ${BUILD_DIR}
${DOCKER_CMD} run --userns=keep-id --rm -v ${BUILD_DIR}:/home/builder --name wrtbuilder -it ${IMAGE_NAME} /bin/bash

