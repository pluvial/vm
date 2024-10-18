#!/bin/sh

set -ex

# sudo apt-get -y install caddy

# sudo apt-get -y install debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt-get update
sudo apt-get -y install caddy

# cwd=$(pwd)

# go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
#
# mkdir -p ~/.local/opt/caddy
# cd ~/.local/opt/caddy
# trap "cd $cwd" EXIT
#
# xcaddy build
# xcaddy build --with github.com/caddy-dns/cloudflare
# cd ~/.local/bin
# ln -s ~/.local/opt/caddy/caddy
