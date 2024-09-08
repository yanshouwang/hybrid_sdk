#!/bin/sh

set -e

OUT=$PWD/out
HYBRID_JPEG_JNI_LIBS=$(dirname $(dirname $(dirname $(dirname $PWD))))/hybrid_jpeg/android/src/main/jniLibs

cp -r $OUT/arm64-v8a/include $PWD

for abi in arm64-v8a armeabi-v7a riscv64 x86 x86_64
do
if [ ! -d "$PWD/libs/$abi" ]; then
mkdir $PWD/libs/$abi
fi

cp $OUT/$abi/lib/*.so $PWD/libs/$abi
done

if [ ! -d $HYBRID_JPEG_JNI_LIBS ]; then
mkdir $HYBRID_JPEG_JNI_LIBS
fi

cp -r $PWD/libs/* $HYBRID_JPEG_JNI_LIBS