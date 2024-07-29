#!/bin/sh

set -ex

cwd=$(pwd)
script=$(readlink -f "$0")
dir=$(dirname "$script")

sudo apt-get install build-essential fish git mosh neovim tmux

cd $dir
trap "cd $cwd" EXIT

setup/cache.sh
setup/go.sh
setup/rust.sh
