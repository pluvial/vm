#!/bin/sh

set -ex

file="install.sh"
url="https://astral.sh/uv/$file"

cwd=$(pwd)

mkdir -p ~/.local/cache/uv
cd ~/.local/cache/uv
trap "cd $cwd" EXIT

wget $url
chmod +x $file

./$file
