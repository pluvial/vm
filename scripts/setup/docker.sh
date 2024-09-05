#!/bin/sh

set -ex

# sudo apt-get install docker.io docker-cli docker-compose

# for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

# sudo apt-get update
# sudo apt-get install ca-certificates curl
# sudo install -m 0755 -d /etc/apt/keyrings
# sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
# sudo chmod a+r /etc/apt/keyrings/docker.asc

# echo \
#   "deb [arch=arm64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bullseye stable" | \
#   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# cat <<EOF >/etc/apt/sources.list.d/docker.list
# deb [arch=arm64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bullseye stable
# EOF

# sudo apt-get update
# sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

file="install-docker.sh"
url="https://get.docker.com"
cwd=$(pwd)

mkdir -p ~/.local/cache/docker
cd ~/.local/cache/docker
trap "cd $cwd" EXIT

wget -O $file $url
chmod +x $file

./$file

sudo apt-get install uidmap
dockerd-rootless-setuptool.sh install
