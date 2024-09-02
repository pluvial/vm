#!/bin/sh

set -ex

# standard: Alpine as it was intended. Just enough to get you started. Network connection is required.
# A minimal installation image. Requires networking.
# https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/aarch64/alpine-standard-3.20.2-aarch64.iso
# netboot: Kernel, initramfs and modloop for netboot.
# A netboot image, intended to be used with PXE. Using PXE is outside the scope of this handbook, but it may be used in place of the standard image.
# https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/aarch64/alpine-netboot-3.20.2-aarch64.tar.gz
# uboot: Has default ARM kernel. Includes the uboot bootloader. Supports armv7 and aarch64.
# https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/aarch64/alpine-uboot-3.20.2-aarch64.tar.gz
# minirootfs: Minimal root filesystem. For use in containers and minimal chroots.
# https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/aarch64/alpine-minirootfs-3.20.2-aarch64.tar.gz
# virt: Similar to standard. Slimmed down kernel. Optimized for virtual systems.
# The standard image, but using a different kernel, optimized for virtual environments.
# https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/aarch64/alpine-virt-3.20.2-aarch64.iso

# variant="standard"
variant="netboot"
# variant="uboot"
# variant="minirootfs"
# variant="virt"

v="3.20"
version="$v.2"

name="alpine-$variant-$version-aarch64"
# file="$name.iso"
file="$name.tar.gz"
url="https://dl-cdn.alpinelinux.org/alpine/v$v/releases/aarch64/$file"

cwd=$(pwd)

mkdir -p ~/.local/cache
cd ~/.local/cache
trap "cd $cwd" EXIT

wget $url

mkdir -p ~/.local/opt/$name
cd ~/.local/opt/$name

rootfs=$(pwd)
tar xf ~/.local/cache/$file

mkdir -p ~/.local/opt/alpine
cd ~/.local/opt/alpine

qemu-img create -f qcow2 vda.qcow2 8G
cp $rootfs/boot/initramfs-lts $rootfs/boot/vmlinuz-lts .
