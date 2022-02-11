#!/bin/bash

set -e

export LFS=/
export BUILD=/dist/

SCRIPT=/dist/master.py
SOURCE_EXTRACTION=/sources/tmp

function configure_package_run {
    cd $SOURCE_EXTRACTION
    bash -e "$1"
    rm -rdf $SOURCE_EXTRACTION
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

configure_package_input "basic_system_software"