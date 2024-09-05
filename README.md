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
sudo mkdir /mnt/host
sudo mount -t virtiofs host /mnt/host
# or add to /etc/fstab :
# host /mnt/host virtiofs defaults 0 0
```

## Setup Alpine VM

In Ubuntu VM:

```sh
cd /mnt/host/cwd/alpine
sudo ./build.sh
```

Creates `/mnt/host/cwd/vm-build`

In host:

```sh
mv vm-build/* alpine
alpine/setup.sh
```

```sh
tree alpine
alpine
├── alpine-minirootfs.tar.gz
├── etc
│   ├── fstab
│   ├── group
│   ├── hosts
│   ├── init.d
│   │   ├── rcK
│   │   └── rcS
│   ├── inittab
│   └── passwd
├── image.sh
├── linux.config
├── linux.sh
├── linux.tar.xz
├── linux.version
├── mnt
├── root
│   ├── build.sh
│   ├── setup-podman.sh
│   └── setup-vdb.sh
├── run.sh
├── setup.sh
├── usr
│   └── share
│       └── udhcpc
│           └── default.script
├── vda.img
├── vdb.img
└── vmlinuz

8 directories, 22 files
```

## Run Alpine VM

```sh
alpine/run.sh
```

### SSH into VM

In VM:

```sh
apk add dropbear && reboot
```

In host:

```sh
alpine/ssh.sh
```

### Setup Podman

In VM:

```sh
./setup-vdb.sh
./setup-podman.sh
```

Test with:

```sh
podman run --rm -it alpine
```

### Build Linux in Podman

```sh
./build.sh
```

Creates `~/build/vmlinuz`, can be copied to host with:

```sh
cp build/vmlinuz /mnt/host/cwd/
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

Apple sample code:

- [Running Linux in a Virtual Machine](https://developer.apple.com/documentation/virtualization/running_linux_in_a_virtual_machine)
- [Running GUI Linux in a virtual machine on a Mac](https://developer.apple.com/documentation/virtualization/running_gui_linux_in_a_virtual_machine_on_a_mac)
