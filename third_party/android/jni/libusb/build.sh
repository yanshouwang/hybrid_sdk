#!/bin/sh

set -e

PROJECT=$(dirname $(dirname $(dirname $PWD)))/libusb

cd $PROJECT/android/jni
ndk-build USE_PC_NAME=1