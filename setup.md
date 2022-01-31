This is the story of how `shuriken` was forged. `shuriken` is my virtual
machine that runs NixOS as a guest under QEMU. It boots up in UEFI mode and
stores data inside of an encrypted ZFS pool.

## QEMU Image Creation 

``` sh
# Create the disk image
qemu-img create -f qcow2 shuriken.img 400G

# Boot the NixOS live CD
qemu-system-x86_64 \
  -enable-kvm \
  -bios $UEFI_FIRMWARE \
  -drive file=shuriken.img \
  -cdrom $NIX_LIVE_CD \
  -cpu host \
  -m 8G
```

`$UEFI_FIRMWARE` is the file path to the OVMF firmware image (`OVMF_CODE.fd`)
and `$NIX_LIVE_CD` is the file path to the minimal NixOS live CD image. 

## Disk Partitioning

- 1 GiB (minus 1 MiB) Boot Partition
- 9 GiB Swap Partition
- 390 GiB Data Partition

``` sh
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart ESP fat32 1MiB 1GiB
sudo parted /dev/sda -- set 1 esp on
sudo parted /dev/sda -- mkpart primary linux-swap 1GiB 10GiB
sudo parted /dev/sda -- mkpart primary 10GiB 100%
```

This should yield a partition table that looks something like this:

```
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda      8:0    0  400G  0 disk 
├─sda1   8:1    0 1023M  0 part /boot
├─sda2   8:2    0    9G  0 part 
└─sda3   8:3    0  390G  0 part 
```

## Disk Formatting

``` sh
# Format the boot partition
sudo mkfs.fat -F 32 -n boot /dev/sda1

# Format the data partition
sudo zpool create \
  -o ashift=12 \
  -O mountpoint=none \
  -O atime=off \
  -O compression=lz4 \
  -O xattr=sa \
  -O acltype=posixacl \
  -O encryption=aes-256-gcm \
  -O keylocation=prompt \
  -O keyformat=passphrase \
  -R /mnt \
  scroll \
  /dev/sda3
```

## NixOS Installation

``` sh
# Mount the data partition
sudo zfs create -o mountpoint=legacy scroll/root
sudo mount -t zfs scroll/root /mnt

# Mount the boot partition
sudo mkdir /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```

Generate `configuration.nix` and `hardware-configuration.nix` files using the
following command: `sudo nixos-generate-config --root /mnt`. Edit the generated
`configuration.nix` so that it looks something like:

``` nix
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  time.timeZone = "UTC";
  system.stateVersion = "21.11";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "shuriken";
  networking.hostId = "948e3734";
  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;
}
```

Finally, run `sudo nixos-install` to install NixOS and reboot!

Note: Legacy BIOS boot entries may have higher precedence in the boot options,
so make sure to update the boot order to load the disk image in UEFI mode by
default.
