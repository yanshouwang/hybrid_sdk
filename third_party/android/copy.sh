#!/bin/sh

set -e

HYBRID_UVC_JNI_LIBS=$(dirname $(dirname $PWD))/hybrid_uvc/android/src/main/jniLibs

for abi in arm64-v8a armeabi-v7a riscv64 x86 x86_64
do
if [ ! -d $HYBRID_UVC_JNI_LIBS/$abi ]; then
mkdir -p $HYBRID_UVC_JNI_LIBS/$abi
fi

cp libs/$abi/libuvc.so $HYBRID_UVC_JNI_LIBS/$abi
done
