#!/bin/bash

mkdir -p $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
    ln -sf usr/"$i" "$LFS"/"$i"
done

mkdir -p $LFS/lib64

mkdir -p $LFS/tools

if ! [ $(getent group lfs) ]; then
    groupadd lfs
fi


if ! [ $(getent passwd lfs) ]; then
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs

HOME_DIR=/home/lfs

cat > $HOME_DIR/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > $HOME_DIR/.bashrc << "EOF"
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
EOF

[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE
source $HOME_DIR/.bash_profile
fi

sudo chown lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
sudo chown lfs $LFS/lib64
sudo chown -R lfs:lfs $LFS/sources


