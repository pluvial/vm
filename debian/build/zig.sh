#!/bin/sh

set -ex

cwd=$(pwd)

cd ~/.local/src/zig-bootstrap
trap "cd $cwd" EXIT

arch=native
os=linux
# abi=gnu
abi=musl
triple=$arch-$os-$abi
mcpu=native

# ./build $triple $mcpu
# CMAKE_BUILD_PARALLEL_LEVEL=2 ./build $triple $mcpu
CMAKE_GENERATOR=Ninja ./build $triple $mcpu

ZIG_PREFIX="$PWD/out/zig-$triple-$mcpu"
# LLVM_PREFIX="$PWD/out/$triple-$mcpu"
# LLVM_PREFIX="$PWD/out/build-llvm-$triple-$mcpu"
LLVM_PREFIX="$PWD/out/host"

cd ~/.local/src/zig

"$ZIG_PREFIX/zig" build \
  -p stage3 \
  --search-prefix "$LLVM_PREFIX" \
  --zig-lib-dir lib \
  -Dstatic-llvm
