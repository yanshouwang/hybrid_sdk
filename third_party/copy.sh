#!/bin/sh

set -e

OUT=$PWD/out
HYBRID_SDK=$(dirname $PWD)

# LibJPEG
if [ ! -d "$HYBRID_SDK/hybrid_jpeg/src" ]; then
mkdir $HYBRID_SDK/hybrid_jpeg/src
fi

if [ ! -d "$HYBRID_SDK/hybrid_jpeg/linux/lib" ]; then
mkdir $HYBRID_SDK/hybrid_jpeg/linux/lib
fi

cp -r $OUT/libjpeg-turbo/include $HYBRID_SDK/hybrid_jpeg/src
cp $OUT/libjpeg-turbo/lib/*.so $HYBRID_SDK/hybrid_jpeg/linux/lib

# LibUSB
if [ ! -d "$HYBRID_SDK/hybrid_usb/src" ]; then
mkdir $HYBRID_SDK/hybrid_usb/src
fi

if [ ! -d "$HYBRID_SDK/hybrid_usb/linux/lib" ]; then
mkdir $HYBRID_SDK/hybrid_usb/linux/lib
fi

cp -r $OUT/libusb/include $HYBRID_SDK/hybrid_usb/src
cp $OUT/libusb/lib/*.so $HYBRID_SDK/hybrid_usb/linux/lib

# LibUVC
if [ ! -d "$HYBRID_SDK/hybrid_uvc/src" ]; then
mkdir $HYBRID_SDK/hybrid_uvc/src
fi

if [ ! -d "$HYBRID_SDK/hybrid_uvc/linux/lib" ]; then
mkdir $HYBRID_SDK/hybrid_uvc/linux/lib
fi

cp -r $OUT/libuvc/include $HYBRID_SDK/hybrid_uvc/src
cp $OUT/libuvc/lib/*.so $HYBRID_SDK/hybrid_uvc/linux/lib
