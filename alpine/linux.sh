#!/usr/bin/bash

set -e
set -x

if [ ! -d mnt ]; then
  sudo apt update
  sudo apt install -y make clang llvm lld flex bison libelf-dev libncurses-dev libssl-dev
fi

if [ ! -d linux ]; then
  if [ ! -f linux.tar.xz ]; then
    wget -q -O linux.tar.xz https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$(cat linux.version).tar.xz
  fi
  mkdir linux
  cd linux
  tar xf ../linux.tar.xz --strip-components=1
  cd ..
fi

cd linux
cp ../linux.config .config
ARCH=arm64 make CC=clang LLVM=1 LLVM_IAS=1 -j2 $*
cp .config ../linux.config
cp arch/arm64/boot/Image ../vmlinuz
cd ..
