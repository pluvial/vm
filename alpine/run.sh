#!/bin/bash

set -e
# set -x

script=$(readlink -f "$0")
dir=$(dirname "$script")
cwd=$(pwd)

check() {
  if [ ! -f "$1" ]; then
    echo "no $1"
    cd $cwd
    return 1
  fi
}

cd $dir
check vmlinuz
check vda.img
check vdb.img || echo "no podman support"

cd $cwd
$dir/../build/Release/vm $dir
