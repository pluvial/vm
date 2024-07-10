#!/bin/bash

set -e
# set -x

script=$(readlink -f "$0")
dir=$(dirname "$script")

check() {
  if [ ! -f "$1" ]; then
    echo "no $1"
    popd
    exit 1
  fi
}

pushd $dir >/dev/null
check vmlinuz
check initrd
check vda.img
check vdb.img
check vdc.iso
popd >/dev/null

$dir/../build/Release/vm $dir
