#!/bin/sh

set -ex

cwd=$(pwd)

sudo apt-get -y install autoconf automake libtool

cd ~/.local/src/jq
trap "cd $cwd" EXIT

mkdir -p local
prefix="$PWD/local"

git submodule update --init

autoreconf -i
./configure --prefix=$prefix --with-oniguruma=builtin
make -j8
# make clean
# make LDFLAGS=-all-static -j8
make check
make install
