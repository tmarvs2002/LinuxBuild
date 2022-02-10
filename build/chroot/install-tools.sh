#!/bin/bash

set -e

SCRIPTS=/tmp/config_scripts
SRC_DIR=/sources
BUILD_DIR="$SRC_DIR"/tmp

function chroot_install {
    mkdir $BUILD_DIR
    tar -xf "$SRC_DIR"/"$1" -C $BUILD_DIR --strip-components=1
    cd $BUILD_DIR
    bash -e "$SCRIPTS"/$2
    rm -rdf $BUILD_DIR   
}

chroot_install gcc-11.2.0.tar.xz libstdc_pass-2.sh
chroot_install gettext-0.21.tar.xz gettext.sh  
chroot_install bison-3.7.6.tar.xz bison.sh
chroot_install perl-5.34.0.tar.xz perl.sh  
chroot_install Python-3.9.6.tar.xz python.sh  
chroot_install texinfo-6.8.tar.xz texinfo.sh
chroot_install util-linux-2.37.2.tar.xz util-linux.sh