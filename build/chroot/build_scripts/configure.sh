#!/bin/bash

set -e

echo "LFS: ${LFS:?}"
echo "BUILD: ${BUILD:?}"

CHROOT_DIR=$BUILD/chroot

chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac

mkdir -pv $LFS/{dev,proc,sys,run}

mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3