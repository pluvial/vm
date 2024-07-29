#!/bin/sh

set -ex

sudo apt-get install golang
echo 'export PATH="$PATH:$HOME/go/bin"' >>~/.profile
echo 'fish_add_path $HOME/go/bin' >>~/.config/fish/config.fish

. ~/.profile

go install github.com/dundee/gdu/v5/cmd/gdu@latest
