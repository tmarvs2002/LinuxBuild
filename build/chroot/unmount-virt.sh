#!/bin/bash

set -e

echo "LFS: ${LFS:?}"
echo "BUILD: ${BUILD:?}"

umount "$LFS"/dist
umount "$LFS"/run
umount "$LFS"/sys
umount "$LFS"/proc
umount/pts "$LFS"/dev/pts
umount "$LFS"/dev