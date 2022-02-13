#!/bin/bash

SCRIPT="$BUILD"/master.py
SOURCE_EXTRACTION="$LFS"/sources/tmp
USER=$(whoami)

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

if [ $USER != "lfs" ] && [ $USER != "root" ]; then
mkdir -pv $LFS/sources $BUILD && chmod a+wt $LFS/sources
python3 $SCRIPT package_download
sudo -E bash -e "$BUILD"/preparation.sh
exit  
fi

if [ $USER == "lfs" ]; then
python3 $SCRIPT package_download
configure_package_input "cross_toolchain"
configure_package_input "temporary_tools"
fi

if [ $USER == "root" ]; then
bash -e $BUILD/chroot-setup.sh
fi

# sudo -E bash -e "$BUILD"/system-software.sh "additional_temporary_tools"
# sudo -E bash -e "$BUILD"/system-software.sh "basic_system_software"
# sudo -E bash -e "$BUILD"/system-software.sh "strip"
# sudo -E bash -e "$BUILD"/system-software.sh "cleanup"
