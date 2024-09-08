#!/bin/sh

set -e

PROJECT=$(dirname $(dirname $(dirname $PWD)))/libjpeg-turbo
BUILD=$PWD/build
OUT=$PWD/out

NDK_PATH=$HOME/Android/SDK/ndk/27.0.12077973
TOOLCHAIN=clang
ANDROID_VERSION=21

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

for abi in arm64-v8a armeabi-v7a riscv64 x86 x86_64
do
mkdir $BUILD/$abi
mkdir $OUT/$abi
cd $BUILD/$abi
cmake \
  -G"Unix Makefiles" \
  -DANDROID_ABI=$abi \
  -DANDROID_PLATFORM=android-${ANDROID_VERSION} \
  -DANDROID_TOOLCHAIN=${TOOLCHAIN} \
  -DCMAKE_TOOLCHAIN_FILE=${NDK_PATH}/build/cmake/android.toolchain.cmake \
  -DCMAKE_INSTALL_PREFIX=$OUT/$abi \
  $PROJECT
make && make install
done
