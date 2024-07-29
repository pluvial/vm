#!/bin/sh

set -ex

sudo apt-get install ccache

echo 'export PATH="/usr/lib/ccache/bin:$PATH"' >>~/.profile
echo 'fish_add_path -p /usr/lib/ccache' >>~/.config/fish/config.fish

sudo apt-get install sccache

echo 'export RUSTC_WRAPPER=/usr/bin/sccache' >>~/.profile
echo 'set -gx RUSTC_WRAPPER /usr/bin/sccache' >>~/.config/fish/config.fish

. ~/.profile
