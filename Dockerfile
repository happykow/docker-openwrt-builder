FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      sudo time git-core subversion build-essential g++ \
      bash make libssl-dev patch libncurses5 libncurses5-dev \
      zlib1g-dev gawk flex gettext wget unzip xz-utils python \
      python-distutils-extra python3 python3-distutils-extra rsync \
      curl vim nano && \
    apt-get clean

ARG USERNAME=builder

RUN useradd -m ${USERNAME} && \
    echo "${USERNAME} ALL=NOPASSWD: ALL" > /etc/sudoers.d/user

USER ${USERNAME}
WORKDIR /home/${USERNAME}

