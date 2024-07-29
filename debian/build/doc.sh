#!/bin/sh

set -ex

cwd=$(pwd)

mkdir -p ~/.local/doc
cd ~/.local/doc
trap "cd $cwd" EXIT

clone() {
  git clone --depth 1 "https://github.com/$1/$2"
}

clone fish-shell fish-shell.wiki
clone janet-lang janet.wiki
clone janet-lang janet-lang.org
clone neovim neovim.wiki
clone tmux tmux.wiki
clone ziglang zig.wiki
