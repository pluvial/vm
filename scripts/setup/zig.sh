#!/bin/sh

set -ex

cwd=$(pwd)

mkdir -p ~/.local/cache/zig
cd ~/.local/cache/zig
trap "cd $cwd" EXIT

wget https://ziglang.org/download/index.json

arch=$(uname -m)
# version="0.13.0"
version=$(cat index.json | jq -r .master.version)
# tarball=$(cat index.json | jq -r '.master.["$arch-linux"].tarball')

name="zig-linux-$arch-$version"
file="$name.tar.xz"

# url="https://ziglang.org/download/$version/$file"
url="https://ziglang.org/builds/$file"

wget $url

mkdir -p ~/.local/opt
cd ~/.local/opt
tar xf ../cache/zig/$file

mkdir -p ~/.local/bin
cd ~/.local/bin
ln -s ~/.local/opt/$name/zig .
