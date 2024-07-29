#!/bin/sh

set -ex

version="0.13.0"
# version="0.14.0-dev.658+4a77c7f25"

name="zig-linux-aarch64-$version"
file="$name.tar.xz"

url="https://ziglang.org/download/$version/$file"
# url="https://ziglang.org/builds/$file"

cwd=$(pwd)

mkdir -p ~/.local/cache
cd ~/.local/cache
trap "cd $cwd" EXIT

wget $url

mkdir -p ~/.local/opt
cd ~/.local/opt
tar xf ../cache/$file

mkdir -p ~/.local/bin
cd ~/.local/bin
ln -s ~/.local/opt/$name/zig .
