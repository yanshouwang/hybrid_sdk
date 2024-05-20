# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(hybrid_os_windows_library VERSION 0.0.1 LANGUAGES C)

add_library(hybrid_os_windows SHARED
  "hybrid_os_windows.c"
)

set_target_properties(hybrid_os_windows PROPERTIES
  PUBLIC_HEADER hybrid_os_windows.h
  OUTPUT_NAME "hybrid_os_windows"
)

target_compile_definitions(hybrid_os_windows PUBLIC DART_SHARED_LIB)
