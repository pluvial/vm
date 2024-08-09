#!/bin/sh

set -ex

cwd=$(pwd)

mkdir -p ~/.local/src
cd ~/.local/src
trap "cd $cwd" EXIT

clone() {
  git clone --depth 1 "https://github.com/$1/$2"
}

clone fish-shell fish-shell
clone janet-lang janet
clone jqlang jq
clone neovim neovim
clone tmux tmux
clone ziglang zig
clone ziglang zig-bootstrap
