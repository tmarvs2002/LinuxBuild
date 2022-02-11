#!/bin/bash

set -e

SCRIPT=/tmp/system_software/master.py
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
        cd /tmp/system_software
        value=`python3 $SCRIPT package_configuration $1 $pkg`
        configure_package_run $value
        pkg=$((pkg+1))
    done
}

configure_package_input "system_software"
