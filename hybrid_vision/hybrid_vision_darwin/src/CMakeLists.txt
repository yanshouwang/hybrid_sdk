# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(hybrid_vision_darwin_library VERSION 0.0.1 LANGUAGES C)

add_library(hybrid_vision_darwin SHARED
  "hybrid_vision_darwin.c"
)

set_target_properties(hybrid_vision_darwin PROPERTIES
  PUBLIC_HEADER hybrid_vision_darwin.h
  OUTPUT_NAME "hybrid_vision_darwin"
)

target_compile_definitions(hybrid_vision_darwin PUBLIC DART_SHARED_LIB)
