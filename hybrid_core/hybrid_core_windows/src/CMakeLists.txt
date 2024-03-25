# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(hybrid_core_windows_library VERSION 0.0.1 LANGUAGES C)

add_library(hybrid_core_windows SHARED
  "hybrid_core_windows.c"
)

set_target_properties(hybrid_core_windows PROPERTIES
  PUBLIC_HEADER hybrid_core_windows.h
  OUTPUT_NAME "hybrid_core_windows"
)

target_compile_definitions(hybrid_core_windows PUBLIC DART_SHARED_LIB)
