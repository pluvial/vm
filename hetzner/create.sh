#!/bin/sh

set -ex

cwd=$(pwd)
script=$(readlink -f "$0")
dir=$(dirname "$script")

project=$PROJECT
key_dir=~/.ssh/id
key_file="root-$project"
key_name="root@$project"
key_path="$key_dir/$key_file"
server=$project

# hcloud context create $project
hcloud context use $project

mkdir -pm 700 $key_dir
ssh-keygen -t ed25519 -a 100 -C $key_name -f $key_path
ssh-add $key_path
hcloud ssh-key create --name $key_name --public-key-from-file "$key_path.pub"

firewalls/create.sh

hcloud server create \
  --enable-backup \
  --enable-protection delete,rebuild \
  --firewall ping,ssh \
  --image debian-12 \
  --location nbg1 \
  --name $server \
  --ssh-key $key_name \
  --type cax11 \
  -o json >$dir/$server.json

ipv4=$(hcloud server ip $server)
ipv6=$(hcloud server ip -6 $server)

cat <<EOF >>~/.ssh/config

Host $server
  HostName $ipv4
  User root
  IdentityFile $key_path
EOF
