#!/bin/sh

set -ex

sudo apt-get -y install unzip

file="install"
url="https://bun.sh/$file"

cwd=$(pwd)

mkdir -p ~/.local/cache/bun
cd ~/.local/cache/bun
trap "cd $cwd" EXIT

wget $url
chmod +x $file

./$file

echo 'export BUN_INSTALL="$HOME/.bun"' >>~/.profile
echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >>~/.profile
