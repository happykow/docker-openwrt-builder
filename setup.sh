#!/bin/bash

# https://openwrt.org/docs/guide-developer/build-system/use-buildsystem#custom_files

BUILD_DIR=~/wrtbuild
WRT_VERSION='19.07.4'
IMAGE_NAME=openwrt-builder

if which podman; then
  DOCKER_CMD='podman'
  DOCKER_ARG='--userns=keep-id'
else
  DOCKER_CMD='docker'
fi

# pull image
${DOCKER_CMD} pull debian:buster

# builder container 
${DOCKER_CMD} build -t ${IMAGE_NAME} .

# run shell in container
[ ! -d ${BUILD_DIR} ] && mkdir ${BUILD_DIR}
echo "RUN:
${DOCKER_CMD} run ${DOCKER_ARG} --rm -v ${BUILD_DIR}:/home/builder --name wrtbuilder -it ${IMAGE_NAME} /bin/bash
"

${DOCKER_CMD} run ${DOCKER_ARG} --rm -v ${BUILD_DIR}:/home/builder --name wrtbuilder -it ${IMAGE_NAME} /bin/bash

