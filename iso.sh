#!/bin/sh

# Configure time
timedatectl set-ntp true

# Create GPT table for 128gB SSD
parted /dev/sda mklabel gpt \
 mkpart "EFI system partition" fat32 1MiB 512MiB \
 set 1 esp on \
 mkpart "Linux swap" ext4 512MiB 8512MiB\
 mkpart "root partition" ext4 8512MiB 100%