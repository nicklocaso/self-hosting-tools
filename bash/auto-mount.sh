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
fstype=$(lsblk -no FSTYPE "$part")
fstab="/etc/fstab"
mount_point="/mnt/auto-mount-$uuid"
options="defaults,nofail,noatime,x-systemd.automount 0 2"

if [[ -z "$uuid" ]]; then
    echo "Error: partition $part does not have a UUID"
    exit 1
fi

echo "Partition $part"
echo "- File system type: $fstype"
echo "- UUID: $uuid"
echo "- Size: $size"

if [[ ! -d "$mount_point" ]]; then
    echo "Creating mount point directory: $mount_point"
    mkdir "$mount_point"
fi

if grep -q "^UUID=$uuid" "$fstab"; then
    echo "Partition $part is already present in $fstab"
    exit 1
else
    echo "Adding partition $part to $fstab"
    echo "UUID=$uuid $mount_point $fstype $options" >>"$fstab"
fi

if mountpoint -q "$mount_point"; then
    echo "Partition $part is already mounted at $mount_point"
    exit 1
else
    echo "Mounting partition $part at $mount_point"
    if mount "$mount_point"; then
        echo "Partition $part mounted successfully at $mount_point"
    else
        echo "Error mounting partition $part at $mount_point"
        sed -i "\|^UUID=$uuid|d" "$fstab"
        exit 1
    fi
fi
