#!/bin/bash

# Configure time
timedatectl set-ntp true

# Create 512mB EFI, 8gB swap & root partition using fdisk
printf 'g\nn\n\n\n+512M\ny\nt\n1\nn\n\n\n+8G\ny\nt\n\n19\nn\n\n\n\ny\nw\n' | fdisk /dev/sda

# Fomat file systems
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
mkfs.fat -F 32 /dev/sda1

# Mount partitions
mount /dev/sda3 /mnt
mount --mkdir /dev/sda1 /mnt/boot
swapon /dev/sda2

# Preinstall packages
pacstrap /mnt base linux linux-firmware broadcom-wl networkmanager nano sudo man-db man-pages texinfo git base-devel fish

# Prepare the next script
curl -LJO https://raw.githubusercontent.com/tuffenduffen/arch-install-script/main/chroot.sh --output-dir /mnt
chmod +x /mnt/chroot.sh

# chroot into new system
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt ./chroot.sh