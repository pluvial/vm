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
clone fish-shell fish-site
clone janet-lang janet.wiki
clone janet-lang janet-lang.org
clone jqlang jq.wiki
clone mobile-shell mosh.wiki
clone mobile-shell mobile-shell.github.io
clone neovim neovim.wiki
clone neovim neovim.github.io
clone tmux tmux.wiki
clone ziglang zig.wiki
clone ziglang www.ziglang.org
