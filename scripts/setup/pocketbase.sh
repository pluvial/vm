#!/bin/sh

set -ex

arch=$(uname -m | sed -e 's/aarch64/arm64/' -e 's/x86_64/amd64/')
version="0.22.23"
file="pocketbase_${version}_linux_$arch.zip"
url="https://github.com/pocketbase/pocketbase/releases/download/v$version/$file"

cwd=$(pwd)

mkdir -p ~/.local/cache/pocketbase
cd ~/.local/cache/pocketbase
trap "cd $cwd" EXIT

wget $url

unzip $file

sudo mkdir -p /root/pb
sudo cp pocketbase /root/pb

sudo tee /lib/systemd/system/pocketbase.service <<EOF
[Unit]
Description = pocketbase

[Service]
Type           = simple
User           = root
Group          = root
LimitNOFILE    = 4096
Restart        = always
RestartSec     = 5s
StandardOutput = append:/root/pb/errors.log
StandardError  = append:/root/pb/errors.log
ExecStart      = /root/pb/pocketbase serve --dev --http 127.0.0.1:9080

[Install]
WantedBy = multi-user.target
EOF

sudo systemctl enable --now pocketbase
