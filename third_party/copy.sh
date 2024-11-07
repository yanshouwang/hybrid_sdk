#!/bin/sh

set -e

OUT=$PWD/out
HYBRID_SDK=$(dirname $PWD)

# hybrid_yuv
if [ ! -d "$HYBRID_SDK/hybrid_yuv/src" ]; then
mkdir $HYBRID_SDK/hybrid_yuv/src
fi

if [ ! -d "$HYBRID_SDK/hybrid_yuv/linux/lib" ]; then
mkdir $HYBRID_SDK/hybrid_yuv/linux/lib
fi

cp -r $OUT/libyuv/include $HYBRID_SDK/hybrid_yuv/src
cp $OUT/libjpeg-turbo/lib/*.so $HYBRID_SDK/hybrid_yuv/linux/lib
cp $OUT/libyuv/lib/*.so $HYBRID_SDK/hybrid_yuv/linux/lib

# hybrid_usb
if [ ! -d "$HYBRID_SDK/hybrid_usb/src" ]; then
mkdir $HYBRID_SDK/hybrid_usb/src
fi

if [ ! -d "$HYBRID_SDK/hybrid_usb/linux/lib" ]; then
mkdir $HYBRID_SDK/hybrid_usb/linux/lib
fi

cp -r $OUT/libusb/include $HYBRID_SDK/hybrid_usb/src
cp $OUT/libusb/lib/*.so $HYBRID_SDK/hybrid_usb/linux/lib

# hybrid_uvc
# if [ ! -d "$HYBRID_SDK/hybrid_uvc/src" ]; then
# mkdir $HYBRID_SDK/hybrid_uvc/src
# fi

# if [ ! -d "$HYBRID_SDK/hybrid_uvc/linux/lib" ]; then
# mkdir $HYBRID_SDK/hybrid_uvc/linux/lib
# fi

# cp -r $OUT/libuvc/include $HYBRID_SDK/hybrid_uvc/src
# cp $OUT/libuvc/lib/*.so $HYBRID_SDK/hybrid_uvc/linux/lib
