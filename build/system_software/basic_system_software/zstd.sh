#!/bin/bash

make && make check && make prefix=/usr install

rm -v /usr/lib/libzstd.a