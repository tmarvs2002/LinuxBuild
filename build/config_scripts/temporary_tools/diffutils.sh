#!/bin/bash

./configure --prefix=/usr --host=$LFS_TGT

make && DESTDIR=$LFS install