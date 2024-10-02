#!/bin/sh

set -ex

cwd=$(pwd)

cd ~/.local/src/tmux
trap "cd $cwd" EXIT

sudo apt-get -y install autoconf automake bison libevent-dev libncurses-dev pkgconf

mkdir -p local
prefix="$PWD/local"

sh autogen.sh
./configure --prefix=$prefix
make
make install
