#!/bin/sh

set -ex

sudo apt-get install rustup
rustup default stable
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>~/.profile
echo 'fish_add_path -p $HOME/.cargo/bin' >>~/.config/fish/config.fish

. ~/.profile

cargo install fd-find ripgrep
