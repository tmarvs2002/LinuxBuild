#!/bin/bash

SCRIPT=$BUILD/master.py
SOURCE_EXTRACTION=$LFS/sources/tmp
USER=$(whoami)
CHROOT=$BUILD/chroot/build_scripts

set -e
echo "LFS: ${LFS:?}"
echo "BUILD: ${BUILD:?}"

function check_root {
    if [ $USER != "root" ] ; then
        echo "Must run as root" && exit
    fi
}

function check_lfs {
    if [ $USER != "lfs" ] ; then
        echo "Must run as lfs" && exit
    fi
}

function configure_package_run {
    cd $SOURCE_EXTRACTION
    bash -e "$1"
    cd $LFS/sources
    rm -rdf $SOURCE_EXTRACTION
}

function configure_package_input {
    pkg=0
    while :
    do
        value=`python3 $SCRIPT package_configuration $1 $pkg`
        file=$BUILD$value
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

if [ $1 == "prep" ]; then
    check_root
    mkdir -pv $LFS/sources $BUILD && chmod a+wt $LFS/sources
    python3 $SCRIPT package_download
    bash -e $BUILD/preparation.sh
    python3 $SCRIPT package_download

elif [ $1 == "pkg1" ]; then
    check_lfs
    configure_package_input "cross_toolchain"

elif [ $1 == "pkg2" ]; then
    check_lfs
    configure_package_input "temporary_tools"

elif [ $1 == "chroot" ]; then
    check_root
    bash -e $CHROOT/configure.sh
    bash -e $CHROOT/mount-virt.sh
    chroot_script "setup-env"
    bash -e $CHROOT/unmount-virt.sh

elif [ $1 == "pkg3" ]; then
    check_root
    bash -e $CHROOT/mount-virt.sh
    chroot_script "additional-temporary-tools"
    bash -e $CHROOT/unmount-virt.sh
    cd $LFS && mkdir ../saved
    tar -cJpf /mnt/linux_dist/saved/lfs-temp-tools-11.0.tar.xz .

elif [ $1 == "pkg4" ]; then
    check_root
    bash -e $CHROOT/mount-virt.sh
    chroot_script "basic-system-software"
    chroot_script "strip"
    chroot_script "cleanup"
    bash -e $CHROOT/unmount-virt.sh

fi