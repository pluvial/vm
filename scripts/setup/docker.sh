#!/bin/sh

set -ex

arch=$(uname -m | sed -e 's/aarch64/arm64/' -e 's/x86_64/amd64/')

# sudo apt-get -y install docker.io docker-cli docker-compose

sudo apt-get -y remove docker.io docker-doc docker-compose podman-docker containerd runc
sudo apt-get update
sudo apt-get -y install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$arch signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# file="install-docker.sh"
# url="https://get.docker.com"
# cwd=$(pwd)

# mkdir -p ~/.local/cache/docker
# cd ~/.local/cache/docker
# trap "cd $cwd" EXIT

# wget -O $file $url
# chmod +x $file

# ./$file

sudo apt-get -y install docker-ce-rootless-extras slirp4netns uidmap
# sudo apt-get -y install docker-ce-rootless-extras uidmap vpnkit
dockerd-rootless-setuptool.sh install
