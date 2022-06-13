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

# chroot into new system
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

# Basic config
ln -s /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
hwclock --systohc

sed -i "s/^#sv_SE.UTF-8 UTF-8/sv_SE.UTF-8 UTF-8/" /etc/locale.gen
sed -i "s/^#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/" /etc/locale.gen

locale-gen

# Creating locale.conf
cat > /etc/locale.conf << EOF
LANG=sv_SE.UTF-8
LANGUAGES=en_GB.UTF-8
LC_MESSAGES=en_GB.UTF-8
EOF

# Creating vconsole.conf
echo "KEYMAP=sv-latin1" > "/etc/vconsole.conf"

# Creating hostname
echo "tuffen-Mac" > "/etc/hostname"

passwd