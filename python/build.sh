#!/bin/bash

rm -rf Python-3.3.0.tgz Python-3.3.0

wget https://www.python.org/ftp/python/3.3.0/Python-3.3.0.tgz
tar -xf Python-3.3.0.tgz
cd Python-3.3.0


./configure 

echo "*static*" >> Modules/Setup.local

make python Parser/pgen
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

echo ac_cv_file__dev_ptmx=no > ./config.site
echo ac_cv_file__dev_ptc=no >> ./config.site
export CONFIG_SITE=config.site

./configure --host=arm-linux-gnueabi --build=x86_64-linux --disable-ipv6

make BLDSHARED="$TOOL_PREFIX-gcc -shared" CROSS_COMPILE=$TOOL_PREFIX- CROSS_COMPILE_TARGET=yes HOSTPYTHON=./python_for_build HOSTPGEN=./Parser/pgen_for_build

