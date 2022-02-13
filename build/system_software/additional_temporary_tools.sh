#!/bin/bash

set -e

export LFS=/
export BUILD=/dist/

SCRIPT=/dist/master.py
SOURCE_EXTRACTION=/sources/tmp

function install {
    rm -rdf /sources/tmp
    mkdir /sources/tmp && cd /sources/tmp
    tar -xf /sources/"$1" -C /sources/tmp --strip-components=1
    bash -e $BUILD/config_scripts/additional_temporary_tools/"$2"
    rm -rdf /sources/tmp
}

install "gcc-11.2.0.tar.xz" "libstdc_pass-2.sh"
install "gettext-0.21.tar.xz" "gettext.sh"
install "bison-3.7.6.tar.xz" "bison.sh"
install "perl-5.34.0.tar.xz" "perl.sh"
install "python-3.9.6.tar.xz" "python.sh"
install "texinfo-6.8.tar.xz" "texinfo.sh"
install "util-linux-2.37.2.tar.xz" "util-linux.sh"

rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools
