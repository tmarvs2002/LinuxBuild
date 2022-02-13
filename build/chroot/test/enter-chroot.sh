#!/bin/bash

set -e

echo "LFS: ${LFS:?}"
echo "BUILD: ${BUILD:?}"

CHROOT="$BUILD"/chroot/build_scripts

bash -e $CHROOT/mount-virt.sh

sudo -E chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /bin/bash --login +h

bash -e $CHROOT/unmount-virt.sh