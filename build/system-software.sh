#!/bin/bash

set -e

echo "LFS: ${LFS:?}"
echo "BUILD: ${BUILD:?}"

CHROOT_DIR="$BUILD"/chroot

bash -e "$CHROOT_DIR"/mount-virt.sh

chroot "$LFS" /usr/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin \
    /dist/system_software/install.sh

bash -e "$CHROOT_DIR"/unmount-virt.sh