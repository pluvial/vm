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
symlink lua-5.4.7 lua
symlink luajit luajit
symlink fish-shell fish
symlink neovim nvim
symlink tmux tmux
