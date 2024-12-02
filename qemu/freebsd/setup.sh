#!/bin/sh

set -ex

version="14.1-RELEASE"

name="FreeBSD-$version-arm64-aarch64-zfs"
file="$name.qcow2"
file_xz="$file.xz"
url="https://download.freebsd.org/releases/VM-IMAGES/$version/aarch64/Latest/$file_xz"

cwd=$(pwd)

mkdir -p ~/.local/cache/freebsd
cd ~/.local/cache/freebsd
trap "cd $cwd" EXIT

wget $url
unxz -k $file_xz

mkdir -p ~/.local/opt/qemu
cd ~/.local/opt/qemu

mv ~/.local/cache/freebsd/$file freebsd.qcow2
