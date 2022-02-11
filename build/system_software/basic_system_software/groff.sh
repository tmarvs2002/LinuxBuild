#!/bin/bash

PAGE=<paper_size> ./configure --prefix=/usr

make -j1 && make install