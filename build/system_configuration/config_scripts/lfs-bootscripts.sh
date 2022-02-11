#!/bin/bash

BUILD_DIR="$LFS"/sources/tmp

mkdir $BUILD_DIR && cd $BUILD_DIR
tar -xf lfs-bootscripts-20210608.tar.xz -C $BUILD_DIR --strip-components=1
make install
rm -rdf $BUILD_DIR