#!/bin/sh

set -ex

cwd=$(pwd)
script=$(readlink -f "$0")
dir=$(dirname "$script")

project=$PROJECT
key_dir="~/.ssh/id"
key_file="root-$project"
key_name="root@$project"
key_path="$key_dir/$key_file"
server=$project

hcloud context use $project

hcloud server disable-protection $server delete rebuild
hcloud server delete $server

firewalls/delete.sh

hcloud ssh-key delete $key_name
echo "local key path: $key_path"
