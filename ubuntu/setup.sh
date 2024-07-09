#!/bin/sh

if [ ! -f vmlinuz ]; then
  if [ ! -f vmlinuz.gz ]; then
    wget -O vmlinuz.gz https://cloud-images.ubuntu.com/noble/current/unpacked/noble-server-cloudimg-arm64-vmlinuz-generic
  fi

  gunzip -k vmlinuz.gz
fi

if [ ! -f initrd ]; then
  wget -O initrd https://cloud-images.ubuntu.com/noble/current/unpacked/noble-server-cloudimg-arm64-initrd-generic
fi

if [ ! -f vda.img ]; then
  if [ ! -f noble-server-cloudimg-arm64.tar.gz ]; then
    wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-arm64.tar.gz
  fi

  tar xf noble-server-cloudimg-arm64.tar.gz noble-server-cloudimg-arm64.img
  mv noble-server-cloudimg-arm64.img vda.img
  truncate -s 64G vda.img
fi

if [ ! -f vdc.iso ]; then
  hdiutil makehybrid -o vdc cidata -iso -joliet
fi
