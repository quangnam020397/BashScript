#!/bin/bash

echo "which swap size you want: ...G"

read -r size

size=$size"G"

sudo fallocate -l $size /swapfile

echo $size

sudo chmod 600 /swapfile

sudo mkswap /swapfile

sudo swapon /swapfile

sudo echo "/swapfile none swap sw 0 0" >> /etc/fstab

sudo swapon --show

sudo free -h