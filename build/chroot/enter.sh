#!/bin/bash

set -e

echo "LFS: ${LFS:?}"
echo "BUILD: ${BUILD:?}"

CHROOT_DIR="$BUILD"/chroot

sudo -E bash -e "$CHROOT_DIR"/mount-virt.sh

sudo -E chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /bin/bash --login +h

sudo -E bash -e "$CHROOT_DIR"/unmount-virt.sh