#!/bin/sh

set -ex

file="install.sh"
url="https://raw.githubusercontent.com/Homebrew/install/HEAD/$file"

cwd=$(pwd)

mkdir -p ~/.local/cache/brew
cd ~/.local/cache/brew
trap "cd $cwd" EXIT

wget $url
chmod +x $file

sudo apt-get -y install ruby3.3
ln -s $(which ruby3.3) ~/.local/bin/ruby

# edit file to remove abort on arm64 linux
./$file

echo "export HOMEBREW_NO_ANALYTICS=1" >>~/.profile
echo "set -gx HOMEBREW_NO_ANALYTICS 1" >>~/.config/fish/config.fish

echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.config/fish/config.fish
