#!/bin/sh

set -e
set -x

doas apk add git

# neovim build deps
doas apk add build-base cmake coreutils curl unzip gettext-tiny-dev

mkdir -p ~/.local/src
cd ~/.local/src

git clone --depth 1 https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=Release
doas make install
cd ..

# tmux build deps
doas apk add automake bison libevent-dev ncurses-dev

git clone --depth 1 https://github.com/tmux/tmux
cd tmux
sh autogen.sh
./configure && make
doas make install
cd ..

doas apk add rustup
rustup-init -y
. .cargo/env

cargo install ripgrep

git clone --depth 1 https://github.com/fish-shell/fish-shell
cd fish-shell
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
doas make install

doas apk add go

go install github.com/dundee/gdu/v5/cmd/gdu@latest

doas apk add docs texinfo
