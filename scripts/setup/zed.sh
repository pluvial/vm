#!/bin/sh

set -ex

file="install.sh"
url="https://zed.dev/$file"

cwd=$(pwd)

mkdir -p ~/.local/cache/zed
cd ~/.local/cache/zed
trap "cd $cwd" EXIT

wget $url
chmod +x $file

./$file
