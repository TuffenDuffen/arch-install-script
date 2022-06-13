#!/bin/bash

# Configure time
timedatectl set-ntp true

# Create 512mB EFI, 8gB swap & root partition
printf 'g\nn\n\n\n+512M\ny\nt\n1\nn\n\n\n+8G\ny\nt\n\n19\nn\n\n\n\ny\nw\n' | fdisk