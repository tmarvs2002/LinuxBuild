#!/bin/bash

set -e

echo "LFS: ${LFS:?}"
echo "BUILD: ${BUILD:?}"

SCRIPT="$BUILD"/master.py
SOURCE_EXTRACTION="$LFS"/sources/tmp

# if ! [ -d "$LFS/sources/tools" ]; then
# mkdir -pv "$LFS"/sources $BUILD && chmod a+wt "$LFS"/sources
# python3 $SCRIPT package_download
# bash -e "$BUILD"/preparation.sh
# fi


python3 $SCRIPT package_download

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


chown -v lfs $LFS/sources
chmod -v a+wt $LFS/sources

# configure_package_input "cross_toolchain"
# configure_package_input "temporary_tools"

# sudo -E bash -e "$BUILD"/chroot-setup.sh
# sudo -E bash -e "$BUILD"/system-software.sh "additional_temporary_tools"
sudo -E bash -e "$BUILD"/system-software.sh "basic_system_software"
sudo -E bash -e "$BUILD"/system-software.sh "strip"
sudo -E bash -e "$BUILD"/system-software.sh "cleanup"
