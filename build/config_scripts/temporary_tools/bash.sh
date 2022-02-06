#!/bin/bash

./configure --prefix=/usr                   \
            --build=$(support/config.guess) \
            --host=$LFS_TGT                 \
            --without-bash-malloc

make && DESTDIR=$LFS install

ln -sv bash $LFS/bin/sh