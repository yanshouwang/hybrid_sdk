# This is the Android makefile for libyuv for NDK.
LOCAL_PATH:= $(call my-dir)
PROJECT_PATH := $(LOCAL_PATH)/../../libyuv

include $(CLEAR_VARS)

LOCAL_CPP_EXTENSION := .cc

LOCAL_SRC_FILES := \
    $(PROJECT_PATH)/source/compare.cc           \
    $(PROJECT_PATH)/source/compare_common.cc    \
    $(PROJECT_PATH)/source/compare_gcc.cc       \
    $(PROJECT_PATH)/source/compare_mmi.cc       \
    $(PROJECT_PATH)/source/compare_msa.cc       \
    $(PROJECT_PATH)/source/compare_neon.cc      \
    $(PROJECT_PATH)/source/compare_neon64.cc    \
    $(PROJECT_PATH)/source/compare_win.cc       \
    $(PROJECT_PATH)/source/convert.cc           \
    $(PROJECT_PATH)/source/convert_argb.cc      \
    $(PROJECT_PATH)/source/convert_from.cc      \
    $(PROJECT_PATH)/source/convert_from_argb.cc \
    $(PROJECT_PATH)/source/convert_to_argb.cc   \
    $(PROJECT_PATH)/source/convert_to_i420.cc   \
    $(PROJECT_PATH)/source/cpu_id.cc            \
    $(PROJECT_PATH)/source/planar_functions.cc  \
    $(PROJECT_PATH)/source/rotate.cc            \
    $(PROJECT_PATH)/source/rotate_any.cc        \
    $(PROJECT_PATH)/source/rotate_argb.cc       \
    $(PROJECT_PATH)/source/rotate_common.cc     \
    $(PROJECT_PATH)/source/rotate_gcc.cc        \
    $(PROJECT_PATH)/source/rotate_mmi.cc        \
    $(PROJECT_PATH)/source/rotate_msa.cc        \
    $(PROJECT_PATH)/source/rotate_neon.cc       \
    $(PROJECT_PATH)/source/rotate_neon64.cc     \
    $(PROJECT_PATH)/source/rotate_win.cc        \
    $(PROJECT_PATH)/source/row_any.cc           \
    $(PROJECT_PATH)/source/row_common.cc        \
    $(PROJECT_PATH)/source/row_gcc.cc           \
    $(PROJECT_PATH)/source/row_mmi.cc           \
    $(PROJECT_PATH)/source/row_msa.cc           \
    $(PROJECT_PATH)/source/row_neon.cc          \
    $(PROJECT_PATH)/source/row_neon64.cc        \
    $(PROJECT_PATH)/source/row_win.cc           \
    $(PROJECT_PATH)/source/scale.cc             \
    $(PROJECT_PATH)/source/scale_any.cc         \
    $(PROJECT_PATH)/source/scale_argb.cc        \
    $(PROJECT_PATH)/source/scale_common.cc      \
    $(PROJECT_PATH)/source/scale_gcc.cc         \
    $(PROJECT_PATH)/source/scale_mmi.cc         \
    $(PROJECT_PATH)/source/scale_msa.cc         \
    $(PROJECT_PATH)/source/scale_neon.cc        \
    $(PROJECT_PATH)/source/scale_neon64.cc      \
    $(PROJECT_PATH)/source/scale_uv.cc          \
    $(PROJECT_PATH)/source/scale_win.cc         \
    $(PROJECT_PATH)/source/video_common.cc

common_CFLAGS := -Wall -fexceptions
ifneq ($(LIBYUV_DISABLE_JPEG), "yes")
LOCAL_SRC_FILES += \
    $(PROJECT_PATH)/source/convert_jpeg.cc      \
    $(PROJECT_PATH)/source/mjpeg_decoder.cc     \
    $(PROJECT_PATH)/source/mjpeg_validate.cc
common_CFLAGS += -DHAVE_JPEG
LOCAL_SHARED_LIBRARIES := libjpeg
endif

LOCAL_CFLAGS += $(common_CFLAGS)
LOCAL_EXPORT_C_INCLUDES := $(PROJECT_PATH)/include
LOCAL_C_INCLUDES += $(PROJECT_PATH)/include
LOCAL_EXPORT_C_INCLUDE_DIRS := $(PROJECT_PATH)/include

LOCAL_MODULE := libyuv_static
LOCAL_MODULE_TAGS := optional

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_WHOLE_STATIC_LIBRARIES := libyuv_static
LOCAL_MODULE := libyuv
ifneq ($(LIBYUV_DISABLE_JPEG), "yes")
LOCAL_SHARED_LIBRARIES := libjpeg
endif

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_STATIC_LIBRARIES := libyuv_static
LOCAL_SHARED_LIBRARIES := libjpeg
LOCAL_MODULE_TAGS := tests
LOCAL_CPP_EXTENSION := .cc
LOCAL_C_INCLUDES += $(PROJECT_PATH)/include
LOCAL_SRC_FILES := \
    $(PROJECT_PATH)/unit_test/basictypes_test.cc  \
    $(PROJECT_PATH)/unit_test/color_test.cc       \
    $(PROJECT_PATH)/unit_test/compare_test.cc     \
    $(PROJECT_PATH)/unit_test/convert_test.cc     \
    $(PROJECT_PATH)/unit_test/cpu_test.cc         \
    $(PROJECT_PATH)/unit_test/cpu_thread_test.cc  \
    $(PROJECT_PATH)/unit_test/math_test.cc        \
    $(PROJECT_PATH)/unit_test/planar_test.cc      \
    $(PROJECT_PATH)/unit_test/rotate_argb_test.cc \
    $(PROJECT_PATH)/unit_test/rotate_test.cc      \
    $(PROJECT_PATH)/unit_test/scale_argb_test.cc  \
    $(PROJECT_PATH)/unit_test/scale_test.cc       \
    $(PROJECT_PATH)/unit_test/scale_uv_test.cc    \
    $(PROJECT_PATH)/unit_test/unit_test.cc        \
    $(PROJECT_PATH)/unit_test/video_common_test.cc

LOCAL_MODULE := libyuv_unittest
include $(BUILD_NATIVE_TEST)
