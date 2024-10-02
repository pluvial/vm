#!/bin/sh

set -ex

sudo apt-get -y install podman
sudo apt-get -y install passt netavark slirp4netns uidmap
