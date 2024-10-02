#!/bin/sh

set -ex

cwd=$(pwd)

cd ~/.local/src/jq
trap "cd $cwd" EXIT

sudo apt-get -y install libtool

mkdir -p local
prefix="$PWD/local"

autoreconf -i
./configure --prefix=$prefix --with-oniguruma=builtin
make clean
make -j8
# make LDFLAGS=-all-static -j8
make check
make install
