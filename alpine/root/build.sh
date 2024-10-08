#!/bin/sh

set -e
set -x

if [ ! -d build ]; then
  mkdir build
  podman run -d --name build -v $PWD/build:/root/build docker.io/ubuntu:24.04 sleep infinity
  podman exec build sh -c 'apt update && apt install -y git sudo wget xz-utils bc && cd /root && git clone https://github.com/pluvial/vm'
else
  podman start build
fi

podman exec -e -it build sh -c 'cd /root/vm/alpine && ./linux.sh && cp vmlinuz ../../build/vmlinuz'
podman stop build
