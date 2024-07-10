#!/usr/bin/env bash

set -e
set -x

script=$(readlink -f "$0")
dir=$(dirname "$script")

pushd $dir >/dev/null

if [ ! -f vmlinuz ]; then
  echo "no vmlinuz"
  exit 1
fi

if [ ! -f vda.img ]; then
  echo "no vda.img"
  exit 1
fi

if [ ! -f vdb.img ]; then
  truncate -s 16G vdb.img
fi

popd >/dev/null
