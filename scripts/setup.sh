#!/bin/sh

set -ex

cwd=$(pwd)
script=$(readlink -f "$0")
dir=$(dirname "$script")

sudo apt-get -y install build-essential fish git mosh neovim tmux
sudo apt-get -y install btop gh hcloud-cli httpie jq psmisc

cd $dir
trap "cd $cwd" EXIT

setup/cache.sh
setup/go.sh
setup/node.sh
setup/rust.sh

setup/bun.sh
setup/deno.sh
setup/zig.sh

setup/caddy.sh
setup/cloudflared.sh
setup/docker.sh
setup/podman.sh
setup/tailscale.sh

# setup/brew.sh
# setup/code-server.sh
