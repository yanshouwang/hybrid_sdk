LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := usb-1.0
LOCAL_SRC_FILES := $(LOCAL_PATH)/libusb/libs/$(TARGET_ARCH_ABI)/libusb-1.0.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/libusb/include/libusb-1.0

include $(PREBUILT_SHARED_LIBRARY)
