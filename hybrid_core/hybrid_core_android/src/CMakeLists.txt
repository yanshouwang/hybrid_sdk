# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(hybrid_core_android_library VERSION 0.0.1 LANGUAGES C)

add_library(hybrid_core_android SHARED
  "hybrid_core_android.c"
)

set_target_properties(hybrid_core_android PROPERTIES
  PUBLIC_HEADER hybrid_core_android.h
  OUTPUT_NAME "hybrid_core_android"
)

target_compile_definitions(hybrid_core_android PUBLIC DART_SHARED_LIB)
