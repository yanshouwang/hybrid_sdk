# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(hybrid_uvc_library VERSION 0.0.1 LANGUAGES C)

add_library(hybrid_uvc SHARED
  "hybrid_uvc.c"
)

set_target_properties(hybrid_uvc PROPERTIES
  PUBLIC_HEADER hybrid_uvc.h
  OUTPUT_NAME "hybrid_uvc"
)

target_compile_definitions(hybrid_uvc PUBLIC DART_SHARED_LIB)
