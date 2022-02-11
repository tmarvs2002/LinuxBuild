#!/bin/bash

echo "LFS: ${LFS:?}"
echo "BUILD: ${BUILD:?}"

SS="$LFS"/tmp/system_software

cp -r "$BUILD"/system_software $SS

chroot "$LFS" /usr/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin \
    /bin/bash --login +h

rm -rdf $SS