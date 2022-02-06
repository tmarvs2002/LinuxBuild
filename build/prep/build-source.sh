#!/bin/bash


if ! [[ -n $LFS ]]; then
echo 'export LFS=/mnt/linux_dist/root' >> ~/.bashrc
. ~/.bashrc
fi

if ! [[ -n $BUILD ]]; then
echo 'export BUILD=/mnt/linux_dist/build' >> ~/.bashrc
. ~/.bashrc
fi

echo "LFS: ${LFS:?}"
echo "BUILD: ${BUILD:?}"

mkdir -pv $LFS $BUILD
mkdir -pv $LFS/sources
chmod -v a+wt $LFS/sources