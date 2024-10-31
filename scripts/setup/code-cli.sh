#!/bin/sh

set -ex

arch=$(uname -m | sed -e 's/aarch64/arm64/' -e 's/x86_64/x64/')
file="vscode_cli.tar.gz"
url="https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-$arch"

cwd=$(pwd)

mkdir -p ~/.local/cache
cd ~/.local/cache
trap "cd $cwd" EXIT

wget -O $file $url

mkdir -p ~/.local/opt/code-cli
cd ~/.local/opt/code-cli

tar xf ~/.local/cache/$file

cd ~/.local/bin
ln -s ~/.local/opt/code-cli/code
