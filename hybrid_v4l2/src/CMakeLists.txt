# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(hybrid_v4l2_library VERSION 0.0.1 LANGUAGES C)

add_library(hybrid_v4l2 SHARED
  "hybrid_v4l2.c"
)

set_target_properties(hybrid_v4l2 PROPERTIES
  PUBLIC_HEADER hybrid_v4l2.h
  OUTPUT_NAME "hybrid_v4l2"
)

target_compile_definitions(hybrid_v4l2 PUBLIC DART_SHARED_LIB)

pkg_check_modules(JPEG REQUIRED IMPORTED_TARGET libjpeg)
target_link_libraries(hybrid_v4l2 PRIVATE PkgConfig::JPEG)
