#!/bin/sh

set -ex

cwd=$(pwd)

sudo apt-get -y install cmake

cd ~/.local/src/fish-shell
trap "cd $cwd" EXIT

mkdir -p build local
prefix="$PWD/local"
cd build

cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$prefix
make
make install
