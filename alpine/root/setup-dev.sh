#!/bin/sh

set -e
set -x

cwd=$(pwd)

doas apk add docs git texinfo

## go
doas apk add go
echo 'export PATH="$PATH:$HOME/go/bin"' >>~/.profile

## rust
doas apk add rustup
rustup-init -y
# echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>~/.profile

## ccache/sccache
doas apk add ccache sccache

echo 'export PATH="/usr/lib/ccache/bin:$PATH"' >>~/.profile
echo 'export RUSTC_WRAPPER=/usr/bin/sccache' >>~/.profile

. ~/.profile

cargo install fd-find ripgrep
go install github.com/dundee/gdu/v5/cmd/gdu@latest

## dev src
trap "cd $cwd" EXIT
mkdir -p ~/.local/src
cd ~/.local/src

## alpine
doas apk add alpine-sdk
# git clone git://git.alpinelinux.org/abuild
# git clone git://git.alpinelinux.org/aports
git clone --depth 1 https://git.alpinelinux.org/abuild
git clone --depth 1 https://git.alpinelinux.org/aports

## neovim
doas apk add build-base cmake coreutils curl unzip gettext-tiny-dev

git clone --depth 1 https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=Release
doas make install
cd ..

## tmux
doas apk add autoconf automake bison libevent-dev ncurses-dev

git clone --depth 1 https://github.com/tmux/tmux
cd tmux
sh autogen.sh
./configure && make
doas make install
cd ..

## fish
git clone --depth 1 https://github.com/fish-shell/fish-shell
cd fish-shell
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
doas make install
cd ../..

## zig
doas apk add zig

# doas apk add samurai # ninja alternative
#
# arch=native
# os=linux
# abi=musl
# cpu=native
# target=$arch-$os-$abi
#
# git clone --depth 1 https://github.com/ziglang/zig-bootstrap
# cd zig-bootstrap
# zig_bootstrap_dir=$(pwd)
# CMAKE_GENERATOR=Ninja ./build $target $cpu
# cd ..
#
# export ZIG_PREFIX=$zig_bootstrap_dir/out/zig-$target-$cpu
# export LLVM_PREFIX=$zig_bootstrap_dir/out/$target-$cpu
#
# git clone --depth 1 https://github.com/ziglang/zig
# cd zig
# $ZIG_PREFIX/zig build -p stage3 --search-prefix $LLVM_PREFIX --zig-lib-dir lib -Dstatic-llvm
# cd ..
