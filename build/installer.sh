#!/bin/bash

set -e
echo "LFS: ${LFS:?}"
echo "BUILD: ${BUILD:?}"

SCRIPT="$BUILD"/master.py
SOURCE_EXTRACTION="$LFS"/sources/tmp


# mkdir -pv $LFS/sources $BUILD && chmod a+wt $LFS/sources

# python3 $SCRIPT package_download

#sudo -E bash -e "$BUILD"/preparation.sh

function configure_package_run {
    cd $SOURCE_EXTRACTION
    bash -e "$1"
    cd ..
    rm -rdf tmp
}

function configure_package_input {
    pkg=0
    while :
    do
        value=`python3 $SCRIPT package_configuration $1 $pkg`
        configure_package_run $value
        pkg=$((pkg+1))
    done
}

# configure_package_input "cross_toolchain"
# configure_package_input "temporary_tools"

# sudo -E bash -e "$BUILD"/chroot.sh