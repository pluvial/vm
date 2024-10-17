#!/bin/sh

set -ex

cwd=$(pwd)

mkdir -p ~/.local/bin
cd ~/.local/bin
trap "cd $cwd" EXIT

symlink() {
  ln -sf ~/.local/src/$1/local/bin/$2 $2.local
}

symlink jq jq
symlink fish-shell fish
symlink mosh mosh
symlink neovim nvim
symlink tmux tmux

# symlink lua-5.4.7 lua
# symlink luajit luajit
# symlink nginx nginx
# symlink openresty resty
