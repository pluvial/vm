#!/bin/sh

set -ex

cwd=$(pwd)

cd ~/.local/src/zig-bootstrap
trap "cd $cwd" EXIT

# CMAKE_GENERATOR=Ninja ./build native-linux-gnu native
# CMAKE_GENERATOR=Ninja ./build native-linux-musl native
CMAKE_BUILD_PARALLEL_LEVEL=4 ./build native-linux-musl native