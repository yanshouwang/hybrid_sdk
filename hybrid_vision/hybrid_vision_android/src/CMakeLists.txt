# jni_native_build (Build with jni:setup. Do not delete this line.)

# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(hybrid_vision_android VERSION 0.0.1 LANGUAGES C)

add_library(hybrid_vision_android SHARED
  "./hybrid_vision_android.c"
)

set_target_properties(hybrid_vision_android PROPERTIES
  OUTPUT_NAME "hybrid_vision_android"
)

target_compile_definitions(hybrid_vision_android PUBLIC DART_SHARED_LIB)

if(WIN32)
	set_target_properties(${TARGET_NAME} PROPERTIES
		LINK_FLAGS "/DELAYLOAD:jvm.dll")
endif()

if (ANDROID)
	target_link_libraries(hybrid_vision_android log)
else()
	find_package(Java REQUIRED)
	find_package(JNI REQUIRED)
	include_directories(${JNI_INCLUDE_DIRS})
	target_link_libraries(hybrid_vision_android ${JNI_LIBRARIES})
endif()
