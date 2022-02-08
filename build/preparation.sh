#!/bin/bash

mkdir -p "$LFS"/{etc,var} "$LFS"/usr/{bin,lib,sbin}
for i in bin lib sbin; do
    ln -s usr/"$i" "$LFS"/"$i"
done
case $(uname -m) in
    x86_64) mkdir -p "$LFS"/lib64 ;;
esac
mkdir -p "$LFS"/tools

if ! [ $(getent group lfs) ]; then
    
    groupadd lfs

fi

if ! [ $(getent passwd lfs) ]; then
    
    useradd -s /bin/bash -g lfs -m -k /dev/null lfs
    passwd lfs

fi
chown lfs "$LFS"/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
    x86_64) chown lfs "$LFS"/lib64 ;;
esac
chown -R lfs:lfs "$LFS"/sources

su - lfs

HOME_DIR=/home/lfs

file="$HOME_DIR"/.bash_profile
touch $file
echo "
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
" >> $file

file2="$HOME_DIR"/.bashrc
touch $file2
echo "
set +h
umask 022
LFS=/mnt/linux_dist/root
BUILD=/mnt/linux_dist/build
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE BUILD
export MAKEFLAGS='-j4'
" >> $file2

[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

source "$HOME_DIR"/.bash_profile