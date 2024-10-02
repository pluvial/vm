#!/bin/sh

set -ex

cwd=$(pwd)

cd ~/.local/src/neovim
trap "cd $cwd" EXIT

sudo apt-get -y install build-essential cmake curl gettext ninja-build unzip

mkdir -p local
prefix="$PWD/local"

make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$prefix"
make install
