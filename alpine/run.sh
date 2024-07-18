#!/bin/bash

set -e
# set -x

cwd=$(pwd)
script=$(readlink -f "$0")
dir=$(dirname "$script")

cd $dir
trap "cd $cwd" EXIT

check() {
  if [ ! -f "$1" ]; then
    echo "no $1"
    return 1
  fi
}

check vmlinuz
check vda.img
check vdb.img || echo "no podman support"

cd $cwd
$dir/../build/Release/vm $dir
