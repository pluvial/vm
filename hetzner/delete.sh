#!/bin/sh

set -ex

cwd=$(pwd)
script=$(readlink -f "$0")
dir=$(dirname "$script")

project=$PROJECT
key_file=id_root-$project
key_name=root@$project
key_path=$dir/id/$key_file
server=$project

hcloud context use $project

firewalls/delete.sh

hcloud server disable-protection $server delete rebuild
hcloud server delete $server

hcloud ssh-key delete $key_name
# rm $key_path
