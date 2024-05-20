# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(hybrid_os_linux_library VERSION 0.0.1 LANGUAGES C)

add_library(hybrid_os_linux SHARED
  "hybrid_os_linux.c"
)

set_target_properties(hybrid_os_linux PROPERTIES
  PUBLIC_HEADER hybrid_os_linux.h
  OUTPUT_NAME "hybrid_os_linux"
)

target_compile_definitions(hybrid_os_linux PUBLIC DART_SHARED_LIB)
