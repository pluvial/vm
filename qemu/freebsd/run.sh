#!/bin/sh

set -ex

dir="$HOME/.local/opt/qemu"
efi="/opt/homebrew/share/qemu/edk2-aarch64-code.fd"
vda="$dir/freebsd.qcow2"

# -monitor stdio
# -nographic
# -hda
# -drive file=$vda,if=virtio

qemu-system-aarch64 \
  -machine virt \
  -cpu max \
  -smp 4 \
  -m 8G \
  -bios $efi \
  -drive file=$vda,if=virtio \
  -nic user,hostfwd=tcp::2222-:22 \
  -nographic
