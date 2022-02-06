#!/bin/bash

SCRIPT=$1

SOURCES=/mnt/linux_dist/root/sources
BUILD_DIR="$SOURCES"/tmp

set -e

cd $BUILD_DIR
sudo -E bash -e $SCRIPT
cd $SOURCES