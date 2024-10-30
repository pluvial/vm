#!/bin/sh

set -ex

cwd=$(pwd)
script=$(readlink -f "$0")
dir=$(dirname "$script")

project=$PROJECT

hcloud context use $project

cd $dir
trap "cd $cwd" EXIT

hcloud firewall create --name https --rules-file https.json
hcloud firewall create --name mosh --rules-file mosh.json
hcloud firewall create --name ping --rules-file ping.json
hcloud firewall create --name ssh --rules-file ssh.json
hcloud firewall create --name tailnet --rules-file tailnet.json
hcloud firewall create --name vite --rules-file vite.json
