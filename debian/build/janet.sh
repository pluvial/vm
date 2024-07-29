#!/bin/sh

set -ex

cwd=$(pwd)

cd ~/.local/src/janet
trap "cd $cwd" EXIT

make
make test
# make repl
sudo make install
sudo make install-jpm-git
