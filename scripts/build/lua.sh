#!/bin/sh

set -ex

dir="lua-5.4.7"
file="$dir.tar.gz"
url="https://lua.org/ftp/$file"
cwd=$(pwd)

mkdir -p ~/.local/cache
cd ~/.local/cache
trap "cd $cwd" EXIT

wget $url

mkdir -p ~/.local/src
cd ~/.local/src
tar xf ~/.local/cache/$file
cd $dir

# make
sudo apt-get -y install libreadline-dev
make linux-readline
make test
mkdir -p local
make install INSTALL_TOP="$PWD/local"
