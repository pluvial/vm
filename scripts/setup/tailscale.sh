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

echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
