#!/bin/bash

./configure --prefix=/usr \
    --docdir=/usr/share/doc/bison-3.7.6

make && make install