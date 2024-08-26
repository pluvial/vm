#!/bin/sh

set -ex

cwd=$(pwd)
script=$(readlink -f "$0")
dir=$(dirname "$script")

cd $dir
trap "cd $cwd" EXIT

build/doc.sh
build/src.sh

build/fish.sh
build/jq.sh
build/janet.sh
build/lua.sh
build/luajit.sh
build/nvim.sh
build/tmux.sh
build/zig.sh

build/bin.sh
