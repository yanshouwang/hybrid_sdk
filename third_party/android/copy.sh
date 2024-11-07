#!/bin/sh

set -e

# hybrid_yuv
HYBRID_YUV_JNI_LIBS=$(dirname $(dirname $PWD))/hybrid_yuv/android/src/main/jniLibs

for abi in arm64-v8a armeabi-v7a x86 x86_64
do
if [ ! -d $HYBRID_YUV_JNI_LIBS/$abi ]; then
mkdir -p $HYBRID_YUV_JNI_LIBS/$abi
fi

cp libs/$abi/libjpeg.so $HYBRID_YUV_JNI_LIBS/$abi
cp libs/$abi/libturbojpeg.so $HYBRID_YUV_JNI_LIBS/$abi
cp libs/$abi/libyuv.so $HYBRID_YUV_JNI_LIBS/$abi
done

# hybrid_usb
HYBRID_USB_JNI_LIBS=$(dirname $(dirname $PWD))/hybrid_usb/android/src/main/jniLibs

for abi in arm64-v8a armeabi-v7a x86 x86_64
do
if [ ! -d $HYBRID_USB_JNI_LIBS/$abi ]; then
mkdir -p $HYBRID_USB_JNI_LIBS/$abi
fi

cp libs/$abi/libusb-1.0.so $HYBRID_USB_JNI_LIBS/$abi
done

# hybrid_uvc
# HYBRID_UVC_JNI_LIBS=$(dirname $(dirname $PWD))/hybrid_uvc/android/src/main/jniLibs

# for abi in arm64-v8a armeabi-v7a riscv64 x86 x86_64
# do
# if [ ! -d $HYBRID_UVC_JNI_LIBS/$abi ]; then
# mkdir -p $HYBRID_UVC_JNI_LIBS/$abi
# fi

# cp libs/$abi/libuvc.so $HYBRID_UVC_JNI_LIBS/$abi
# done
