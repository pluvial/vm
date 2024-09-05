#!/bin/sh

set -ex

cwd=$(pwd)

cd ~/.local/src/luajit
trap "cd $cwd" EXIT

mkdir -p local
prefix="$PWD/local"

make PREFIX="$PWD/local"
make install PREFIX="$PWD/local"
