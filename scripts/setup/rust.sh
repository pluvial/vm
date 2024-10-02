#!/bin/sh

set -ex

# sudo apt-get -y install rustup
# rustup default stable
# echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>~/.profile
# echo 'fish_add_path -p $HOME/.cargo/bin' >>~/.config/fish/config.fish

file="install.sh"
url="https://sh.rustup.rs"
cwd=$(pwd)

mkdir -p ~/.local/cache/rustup
cd ~/.local/cache/rustup
trap "cd $cwd" EXIT

wget -O $file $url
chmod +x $file

./$file

. ~/.profile

cargo install fd-find ripgrep
