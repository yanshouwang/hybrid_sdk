LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := jpeg
LOCAL_SRC_FILES := $(LOCAL_PATH)/libjpeg-turbo/libs/$(TARGET_ARCH_ABI)/libjpeg.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/libjpeg-turbo/include

include $(PREBUILT_SHARED_LIBRARY)
