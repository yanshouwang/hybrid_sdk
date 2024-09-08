#!/bin/sh

set -e

PROJECT=$(dirname $(dirname $(dirname $PWD)))
HYBRID_USB_JNI_LIBS=$(dirname $(dirname $(dirname $(dirname $PWD))))/hybrid_usb/android/src/main/jniLibs

cp -r $PROJECT/out/libusb/include $PWD
cp -r $PROJECT/libusb/android/libs $PWD

if [ ! -d $HYBRID_USB_JNI_LIBS ]; then
mkdir $HYBRID_USB_JNI_LIBS
fi

cp -r $PWD/libs/* $HYBRID_USB_JNI_LIBS