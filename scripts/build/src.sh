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
clone jqlang jq
clone mobile-shell mosh
clone neovim neovim
clone nginx nginx
clone tmux tmux

# clone janet-lang janet
# clone ziglang zig
# clone ziglang zig-bootstrap
# git clone https://luajit.org/git/luajit.git
