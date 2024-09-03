#!/bin/sh

set -ex

sudo apt-get install libpcre2-dev zlib1g-dev

dir="openresty-1.25.3.2"
file="$dir.tar.gz"
url="https://openresty.org/download/$file"
cwd=$(pwd)

mkdir -p ~/.local/cache
cd ~/.local/cache
trap "cd $cwd" EXIT

wget $url

mkdir -p ~/.local/src
cd ~/.local/src
tar xf ~/.local/cache/$file
cd $dir

mkdir -p local
prefix="$PWD/local"
PATH="/sbin:$PATH" ./configure -j2 --prefix=$prefix --with-pcre-jit
make
make install

cd ~/.local/bin
for file in $prefix/bin/*; do
  ln -s $file .
done
