#!/bin/sh

set -ex

file="install.sh"
url="https://code-server.dev/$file"

cwd=$(pwd)

mkdir -p ~/.local/cache/code-server
cd ~/.local/cache/code-server
trap "cd $cwd" EXIT

wget $url
chmod +x $file

./$file
