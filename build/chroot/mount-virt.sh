#!/bin/bash

set -e

echo "LFS: ${LFS:?}"
echo "BUILD: ${BUILD:?}"

mount -v --bind /dev "$LFS"/dev

mount -v --bind /dev/pts "$LFS"/dev/pts
mount -vt proc proc "$LFS"/proc
mount -vt sysfs sysfs "$LFS"/sys
mount -vt tmpfs tmpfs "$LFS"/run

if [ -h "$LFS"/dev/shm ]; then
  mkdir -pv "$LFS"/$(readlink "$LFS"/dev/shm)
fi

mkdir -p "$LFS"/dist
mount -v --bind $BUILD "$LFS"/dist