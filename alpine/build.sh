#!/usr/bin/bash

set -e
set -x

apt update
apt install -y git sudo wget xz-utils bc

cd ~
mkdir build
git clone https://github.com/pluvial/vm

cd vm/alpine
./linux.sh
cp vmlinuz ~/build

./image.sh
cp vda.img ~/build

mkdir -p /mnt/host/cwd/vm-build
cp -r ~/build/* /mnt/host/cwd/vm-build
