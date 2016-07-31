#!/bin/bash

mkdir -p /tmp/build
cd /tmp/build

rm -rf Python-3.3.0 bin/*

wget https://www.python.org/ftp/python/3.3.0/Python-3.3.0.tgz
tar -xf Python-3.3.0.tgz
rm -rf Python-3.3.0.tgz

cd Python-3.3.0

./configure 

make -j6 python Parser/pgen
mv python python_for_build
mv Parser/pgen Parser/pgen_for_build
make distclean

patch -p1 < ../Python-3.3.0-cross.patch

export TOOL_PREFIX=arm-linux-gnueabi
export CXX=$TOOL_PREFIX-g++
export CPP="$TOOL_PREFIX-g++ -E"
export AR=$TOOL_PREFIX-ar
export RANLIB=$TOOL_PREFIX-ranlib
export CC=$TOOL_PREFIX-gcc
export LD=$TOOL_PREFIX-ld
export READELF=$TOOL_PREFIX-readelf

export CCFLAGS="-march=armv7-a -mtune=cortex-a8 -mfpu=vfp"
export LDFLAGS="-static -static-libgcc"
export CPPFLAGS="-static"
export CONFIG_SITE=config.site

echo ac_cv_file__dev_ptmx=no > $CONFIG_SITE
echo ac_cv_file__dev_ptc=no >> $CONFIG_SITE

cp Modules/Setup.dist Modules/Setup
echo "*static*" >> Modules/Setup.local

./configure --host=arm-linux-gnueabi --build=x86_64-linux --disable-ipv6

make -j6 BLDSHARED="$TOOL_PREFIX-gcc -shared" CROSS_COMPILE=$TOOL_PREFIX- CROSS_COMPILE_TARGET=yes HOSTPYTHON=./python_for_build HOSTPGEN=./Parser/pgen_for_build
chmod 777 python && mv python ../bin/
cd .. && rm -rf Python-3.3.0

