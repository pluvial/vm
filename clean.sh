#!/bin/sh

rm -f */vda.img */vdb.img */vdc.iso
if [ "$1" = "--all" ]; then
  rm -rf build */initrd */linux */vmlinuz */vmlinuz.gz */*.tar.gz */*.tar.xz
fi
