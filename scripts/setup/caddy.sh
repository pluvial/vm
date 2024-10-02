#!/bin/sh

set -ex

# sudo apt-get -y install caddy

cwd=$(pwd)

go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

mkdir -p ~/.local/opt/caddy
cd ~/.local/opt/caddy
trap "cd $cwd" EXIT

xcaddy build
cd ~/.local/bin
ln -s ~/.local/opt/caddy/caddy
