#!/bin/sh

set -ex

file="install.sh"
url="https://tailscale.com/$file"

cwd=$(pwd)

mkdir -p ~/.local/cache/tailscale
cd ~/.local/cache/tailscale
trap "cd $cwd" EXIT

wget $url
chmod +x $file

./$file
