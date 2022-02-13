#!/bin/bash

set -e

export LFS=""
export BUILD=/dist

SCRIPT=/dist/master.py
SOURCE_EXTRACTION=/sources/tmp

function configure_package_run {
    cd $SOURCE_EXTRACTION
    echo && echo "Configuring $1" && echo
    sleep 2
    bash -e "$1"
    echo && echo "Done Configuring $1" && echo
    sleep 2
    cd /dist
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

configure_package_input "basic_system_software"