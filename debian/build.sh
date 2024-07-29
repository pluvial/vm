#!/bin/sh

set -ex

cwd=$(pwd)
script=$(readlink -f "$0")
dir=$(dirname "$script")

cd $dir
trap "cd $cwd" EXIT

build/src.sh
build/doc.sh
build/fish.sh
build/janet.sh
build/nvim.sh
build/tmux.sh
build/zig.sh
