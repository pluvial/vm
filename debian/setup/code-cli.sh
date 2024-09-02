#!/bin/sh

set -ex

file="vscode_cli.tar.gz"
url="https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-arm64"

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
