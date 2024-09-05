#!/bin/sh

set -ex

dir="$HOME/.local/opt/alpine"
initramfs="$dir/initramfs-lts"
kernel="$dir/vmlinuz-lts"
vda="$dir/vda.qcow2"

alpine_repo='http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/'
modloop='http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/aarch64/netboot/modloop-lts'

qemu-system-aarch64 \
  -machine virt \
  -cpu max \
  -m 1G \
  -initrd $initramfs \
  -kernel $kernel \
  --append "console=ttyAMA0 ip=dhcp alpine_repo=$alpine_repo modloop=$modloop" \
  -hda $vda \
  -netdev user,id=unet -device virtio-net-device,netdev=unet -net user \
  -nographic
