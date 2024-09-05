#!/bin/sh

set -ex

file="llvm.sh"
url="https://apt.llvm.org/$file"
cwd=$(pwd)

mkdir -p ~/.local/cache/llvm
cd ~/.local/cache/llvm
trap "cd $cwd" EXIT

wget $url
chmod +x $file

sudo ./$file 18
