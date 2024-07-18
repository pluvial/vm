#!/bin/sh

set -e
set -x

cwd=$(pwd)

doas apk add ccache git
echo 'export PATH="/usr/lib/ccache/bin:$PATH"' >>~/.profile
. ~/.profile

# neovim build deps
doas apk add build-base cmake coreutils curl unzip gettext-tiny-dev

trap "cd $cwd" EXIT
mkdir -p ~/.local/src
cd ~/.local/src

git clone --depth 1 https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=Release
doas make install
cd ..

# tmux build deps
doas apk add autoconf automake bison libevent-dev ncurses-dev

git clone --depth 1 https://github.com/tmux/tmux
cd tmux
sh autogen.sh
./configure && make
doas make install
cd ..

doas apk add rustup sccache
rustup-init -y
echo 'RUSTC_WRAPPER=/usr/bin/sccache' >>~/.profile
. ~/.profile

cargo install fd-find ripgrep

git clone --depth 1 https://github.com/fish-shell/fish-shell
cd fish-shell
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
doas make install
cd ../..

doas apk add go

go install github.com/dundee/gdu/v5/cmd/gdu@latest

doas apk add docs texinfo
