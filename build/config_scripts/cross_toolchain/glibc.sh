#!/bin/bash

echo && echo "Tom" && echo
sleep(10)

case $(uname -m) in
i?86)
ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
;;
x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
;;
esac

patch -Np1 -i /mnt/linux_dist/root/sources/glibc-2.34-fhs-1.patch

echo && echo "tom" && echo 
sleep(10)

echo "rootsbindir=/usr/sbin" > configparms

mkdir -v build && cd build

../configure \
    --prefix=/usr \
    --host=$LFS_TGT \
    --build=$(../scripts/config.guess) \
    --enable-kernel=3.2 \
    --with-headers=$LFS/usr/include \
    libc_cv_slibdir=/usr/lib

make && make DESTDIR=$LFS install

sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd

echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep '/ld-linux'

rm -v dummy.c a.out

$LFS/tools/libexec/gcc/$LFS_TGT/11.2.0/install-tools/mkheaders