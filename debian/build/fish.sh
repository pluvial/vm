#!/bin/sh

set -ex

cwd=$(pwd)

cd ~/.local/src/fish-shell
trap "cd $cwd" EXIT

mkdir build local
prefix="$PWD/local"
cd build

cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$prefix
make
make install
