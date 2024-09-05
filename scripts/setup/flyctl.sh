#!/bin/sh

set -ex

file="install.sh"
url="https://fly.io/$file"

cwd=$(pwd)

mkdir -p ~/.local/cache/flyctl
cd ~/.local/cache/flyctl
trap "cd $cwd" EXIT

wget $url
chmod +x $file

./$file

echo 'export FLYCTL_INSTALL="$HOME/.fly"' >>~/.profile
echo 'export PATH="$FLYCTL_INSTALL/bin:$PATH"' >>~/.profile
echo 'set -gx FLYCTL_INSTALL "$HOME/.fly"' >>~/.config/fish/config.fish
echo 'fish_add_path -p "$FLYCTL_INSTALL/bin"' >>~/.config/fish/config.fish
