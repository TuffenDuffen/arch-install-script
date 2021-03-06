#!/bin/bash
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

# Add user
groupadd sudo
useradd -m -G sudo -s /bin/fish tuffen
passwd tuffen

# Add sudo permission
sed -i "s/^#%sudo	ALL=(ALL:ALL) ALL/%sudo	ALL=(ALL:ALL) ALL/" /etc/sudoers

mkinitcpio -P

# Installing bootloader
pacman -S intel-ucode
bootctl install

# Making arch bootable
e2label /dev/sda3 root
cat > /boot/loader/loader.conf << EOF
default  arch.conf
timeout 3
console-mode max
EOF
cat > /boot/loader/entries/arch.conf << EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root="LABEL=root" rw
EOF

exit