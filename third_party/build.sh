#!/bin/sh

set -e

PROJECT=$PWD
BUILD=$PWD/build
OUT=$PWD/out

if [ -d $BUILD ]; then
rm -rf $BUILD/*
else
mkdir $BUILD
fi

if [ -d $OUT ]; then
rm -rf $OUT/*
else
mkdir $OUT
fi

# LibJPEG
mkdir $BUILD/libjpeg-turbo
mkdir $OUT/libjpeg-turbo
cd $BUILD/libjpeg-turbo
cmake \
  -G"Unix Makefiles" \
  -DCMAKE_INSTALL_PREFIX="$OUT/libjpeg-turbo" \
  $PROJECT/libjpeg-turbo
make && make install

# LibUSB
mkdir $OUT/libusb
cd $PROJECT/libusb
sh autogen.sh
sh configure --prefix="$OUT/libusb"
make && make install

# LibUVC
mkdir $BUILD/libuvc
mkdir $OUT/libuvc
cd $BUILD/libuvc
cmake \
  -DCMAKE_INSTALL_PREFIX="$OUT/libuvc" \
  $PROJECT/libuvc
make && make install
