#!/bin/bash

# https://openwrt.org/docs/guide-developer/build-system/use-buildsystem#custom_files

WRT_VERSION='19.07.4'
EMAIL=$(whoami)@docker-builder.host

git config --global user.name "$(whoami)" && git config --global user.email "${EMAIL}"

git clone https://git.openwrt.org/openwrt/openwrt.git openwrt

cd openwrt
git pull origin master
git tag -l
git checkout v${WRT_VERSION}

# edit feeds.conf
cat feeds.conf.default > feeds.conf
#sed -i "s/packages.git\^.*$/packages.git\^c614914da0b589069830a383abfa75518ebf4820/g" feeds.conf
#sed -i "s/luci.git\^.*$/luci.git\^8aceafe45622dd9168a129e86574f7aac0ce5352/g" feeds.conf

# custom fix for ea9200
echo "src-git ea9500_openwrt https://github.com/happykow/ea9500_openwrt.git" >> feeds.conf

./scripts/feeds update -a
./scripts/feeds install -a

# patch for ea9200
# edit target/linux/bcm53xx/image/Makefile
sed -i 's/^# TARGET_DEVICES += linksys-ea9200/TARGET_DEVICES += linksys-ea9200/' target/linux/bcm53xx/image/Makefile

# custom files
ln -s feeds/ea9500_openwrt/files files

# download seed.config
curl -LO https://downloads.openwrt.org/releases/${WRT_VERSION}/targets/bcm53xx/generic/config.buildinfo
cp config.buildinfo .config

# setup defconfig
make defconfig
cat ../ea9200/config.ea9200 >> .config
make defconfig
#make menuconfig

# https://hamy.io/post/0015/how-to-compile-openwrt-and-still-use-the-official-repository/#gsc.tab=0
# vermagic
echo "expected: 9b3f4da08295392b7d7eca715b1ee0b8"
printf "actual:   "
if ! find build_dir/ -name .vermagic -exec cat {} \;
then
  make target/linux/{clean,compile} || true
  find build_dir/ -name .vermagic -exec cat {} \;
fi

# build
make download
make -j$(nproc) V=s 2>&1 | tee build.log | grep -i -E "^make.*(error|[12345]...Entering dir)"

