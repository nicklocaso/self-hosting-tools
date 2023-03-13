#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <partition>"
    echo ""
    echo "Available partitions:"
    lsblk -o NAME,TYPE,SIZE,MOUNTPOINT
    exit 1
fi

part="$1"
uuid=$(lsblk -no UUID "$part")
fstab="/etc/fstab"
mount_point="/mnt/auto-mount-$uuid"

if ! mountpoint -q "$mount_point"; then
    echo "Partition $part is not currently mounted"
    exit 1
fi

echo "Unmounting partition $part from $mount_point"
if ! umount "$mount_point"; then
    echo "Error: unmounting partition $part failed"
    exit 1
fi

echo "Removing partition $part from $fstab"
if ! sed -i "/UUID=$uuid/d" "$fstab"; then
    echo "Error: removing partition $part from $fstab failed"
    exit 1
fi

echo "Removing mount point directory: $mount_point"
if ! rmdir "$mount_point"; then
    echo "Error: removing mount point directory $mount_point failed"
    exit 1
fi

echo "Partition $part successfully unmounted and removed from fstab"
