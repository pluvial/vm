#!/bin/sh

if [ ! -f vmlinuz ]; then
  echo "no vmlinuz"
  exit 1
fi

if [ ! -f initrd ]; then
  echo "no initrd"
  exit 1
fi

if [ ! -f vda.img ]; then
  echo "no vda.img"
  exit 1
fi

if [ ! -f vdc.iso ]; then
  echo "no vdc.iso"
  exit 1
fi

../build/Release/vm vmlinuz initrd
