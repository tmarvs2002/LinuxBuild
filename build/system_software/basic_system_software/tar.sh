#!/bin/bash

FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr

make && make check && make install

make -C doc install-html docdir=/usr/share/doc/tar-1.34
