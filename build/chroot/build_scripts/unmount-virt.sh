#!/bin/bash

set -e

echo "LFS: ${LFS:?}"
echo "BUILD: ${BUILD:?}"

function unmount {
    if mountpoint -q $LFS/"$1"; then
    umount -lf $LFS/"$1"
    fi
}

unmount dist
unmount run
unmount sys
unmount proc
unmount dev/pts
unmount dev