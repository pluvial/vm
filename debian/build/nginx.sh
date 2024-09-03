#!/bin/sh

set -ex

cwd=$(pwd)

cd ~/.local/src/nginx
trap "cd $cwd" EXIT

mkdir -p local
prefix="$PWD/local"

auto/configure --prefix=$prefix
make
make install
