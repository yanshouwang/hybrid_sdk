LOCAL_PATH := $(call my-dir)
PROJECT_PATH := $(LOCAL_PATH)/../..

include $(CLEAR_VARS)

LOCAL_MODULE := uvc

LOCAL_SHARED_LIBRARIES += jpeg
LOCAL_SHARED_LIBRARIES += usb-1.0

LOCAL_SRC_FILES := \
  $(PROJECT_PATH)/libuvc/src/ctrl.c \
  $(PROJECT_PATH)/libuvc/src/ctrl-gen.c \
  $(PROJECT_PATH)/libuvc/src/device.c \
  $(PROJECT_PATH)/libuvc/src/diag.c \
  $(PROJECT_PATH)/libuvc/src/frame.c \
  $(PROJECT_PATH)/libuvc/src/frame-mjpeg.c \
  $(PROJECT_PATH)/libuvc/src/init.c \
  $(PROJECT_PATH)/libuvc/src/misc.c \
  $(PROJECT_PATH)/libuvc/src/stream.c

LOCAL_C_INCLUDES += \
  $(PROJECT_PATH)/libuvc/include \
  $(PROJECT_PATH)/build/libuvc/include

include $(BUILD_SHARED_LIBRARY)
