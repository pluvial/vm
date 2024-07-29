#!/bin/sh

set -ex

file="install.sh"
url="https://deno.land/$file"

cwd=$(pwd)

mkdir -p ~/.local/cache/deno
cd ~/.local/cache/deno
trap "cd $cwd" EXIT

wget $url
chmod +x $file

./$file

echo 'export DENO_INSTALL="$HOME/.deno"' >>~/.profile
echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >>~/.profile
echo 'set -gx DENO_INSTALL "$HOME/.deno"' >>~/.config/fish/config.fish
echo 'fish_add_path -p "$DENO_INSTALL/bin"' >>~/.config/fish/config.fish
