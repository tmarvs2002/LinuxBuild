#!/bin/bash

SCRIPT=$BUILD/master.py
SOURCE_EXTRACTION=$LFS/sources/tmp
USER=$(whoami)
CHROOT=$BUILD/chroot/build_scripts

set -e
echo "LFS: ${LFS:?}"
echo "BUILD: ${BUILD:?}"

function configure_package_run {
    cd $SOURCE_EXTRACTION
    bash -e "$1"
    cd "$LFS"/sources
    rm -rdf $SOURCE_EXTRACTION
}

function configure_package_input {
    pkg=0
    while :
    do
        value=`python3 $SCRIPT package_configuration $1 $pkg`
        file="$BUILD""$value"
        configure_package_run $file
        pkg=$((pkg+1))
    done
}

function chroot_script {
    chroot "$LFS" /usr/bin/env -i \
        HOME=/root \
        TERM="$TERM" \
        PS1='(lfs chroot) \u:\w\$ ' \
        PATH=/usr/bin:/usr/sbin \
        /dist/chroot/"$1".sh
}

if [ $1 == "prep" ] && [ $USER == "root" ] ; then
    mkdir -pv $LFS/sources $BUILD && chmod a+wt $LFS/sources
    python3 $SCRIPT package_download
    bash -e "$BUILD"/preparation.sh
    python3 $SCRIPT package_download

elif [ $1 == "pkg1" ] && [ $USER == "lfs" ]; then
    configure_package_input "cross_toolchain"

elif [ $1 == "pkg2" ] && [ $USER == "lfs" ]; then
    configure_package_input "temporary_tools"

elif [ $1 == "chroot" ] && [ $USER == "root" ]; then
    bash -e $CHROOT/configure.sh
    bash -e $CHROOT/mount-virt.sh
    chroot_script "setup-env"
    bash -e $CHROOT/unmount-virt.sh

elif [ $1 == "pkg3" ] && [ $USER == "root" ]; then
    bash -e $CHROOT/mount-virt.sh
    chroot_script "additional-temporary-tools"
    bash -e $CHROOT/unmount-virt.sh
    cd $LFS && tar -cJpf /mnt/linux_dist/saved/lfs-temp-tools-11.0.tar.xz .

elif [ $1 == "pkg4" ] && [ $USER == "root" ]; then
    bash -e $CHROOT/mount-virt.sh
    chroot_script "basic-system-software"
    chroot_script "strip"
    chroot_script "cleanup"
    bash -e $CHROOT/unmount-virt.sh

fi