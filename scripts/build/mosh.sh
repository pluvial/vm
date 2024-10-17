#!/bin/sh

set -ex

cwd=$(pwd)

# sudo apt -y install pkg-config libutempter-dev zlib1g-dev libncurses5-dev libssl-dev bash-completion
sudo apt -y install protobuf-compiler libprotobuf-dev

cd ~/.local/src/mosh
trap "cd $cwd" EXIT

mkdir -p local
prefix="$PWD/local"

./autogen.sh
./configure --prefix=$prefix
make
make install
