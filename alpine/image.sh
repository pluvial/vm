#!/bin/sh

set -ex

if [ ! -f alpine-minirootfs.tar.gz ]; then
  wget -O alpine-minirootfs.tar.gz https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/aarch64/alpine-minirootfs-3.20.1-aarch64.tar.gz
fi

# umount mnt
dd if=/dev/zero of=vda.img bs=1M count=512
mkfs.ext4 vda.img
rm -rf mnt
mkdir mnt
sudo mount vda.img mnt

cd mnt
sudo tar xf ../alpine-minirootfs.tar.gz
sudo rm -rf etc/logrotate.d etc/modprobe.d etc/modules-load.d etc/network etc/opt etc/sysctl.d etc/udhcpc lib/modules-load.d
sudo rm etc/modules etc/sysctl.conf etc/hostname etc/motd etc/issue etc/shadow
sudo cp ../etc/passwd etc/passwd
sudo cp ../etc/group etc/group
sudo cp ../etc/hosts etc/hosts
sudo cp ../etc/inittab etc/inittab
sudo cp ../etc/fstab etc/fstab
sudo cp -Tr ../etc/init.d etc/init.d
sudo mkdir etc/dropbear mnt/host
sudo cp -Tr ../root root
sudo cp ../usr/share/udhcpc/default.script usr/share/udhcpc/default.script
sudo rm -rf lib/sysctl.d
sudo rm -rf media opt srv
cd ..

sudo umount mnt
