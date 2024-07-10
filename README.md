# vm

Linux VMs on ARM64

## Building `vm` binary

```sh
./build.sh
# or
xcodebuild -arch arm64
```

```sh
$ tree build/Release
build/Release/
├── vm
├── vm.dSYM
│   └── Contents
│       ├── Info.plist
│       └── Resources
│           ├── DWARF
│           │   └── vm
│           └── Relocations
│               └── aarch64
│                   └── vm.yml
└── vm.swiftmodule
    ├── Project
    │   └── arm64-apple-macos.swiftsourceinfo
    ├── arm64-apple-macos.abi.json
    ├── arm64-apple-macos.swiftdoc
    └── arm64-apple-macos.swiftmodule

9 directories, 8 files
```

## Setup Ubuntu VM

```sh
ubuntu/setup.sh
```

```sh
tree ubuntu
ubuntu
├── cidata
│   ├── meta-data
│   └── user-data
├── initrd
├── noble-server-cloudimg-arm64.tar.gz
├── run.sh
├── setup.sh
├── vda.img
├── vdb.img
├── vdc.iso
├── vmlinuz
└── vmlinuz.gz

2 directories, 11 files
```

## Run Ubuntu VM

```sh
ubuntu/run.sh
```

Mount host shared directories:

```sh
mkdir host
sudo mount -t virtiofs host host
# or add to /etc/fstab :
# host /mnt/host virtiofs defaults 0 0
```

## Build Alpine

Inside Ubuntu VM:

```sh
cd host/cwd/alpine
./linux.sh
./image.sh
```

## Cleaning

Clean disk images:

```sh
./clean.sh
```

Clean disk images, downloads, and build artifacts

```sh
./clean.sh --all
```

## Inspiration

[apinske/virt](https://github.com/apinske/virt)

Apple sample code: [Running Linux in a Virtual Machine](https://developer.apple.com/documentation/virtualization/running_linux_in_a_virtual_machine)
