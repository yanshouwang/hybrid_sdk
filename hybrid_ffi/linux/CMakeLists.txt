# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

# Project-level configuration.
set(PROJECT_NAME "hybrid_ffi")
project(${PROJECT_NAME} LANGUAGES CXX)

# Invoke the build for native code shared with the other target platforms.
# This can be changed to accommodate different builds.
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../src" "${CMAKE_CURRENT_BINARY_DIR}/shared")

add_library(hybrid_ffi_linux SHARED
  "hybrid_linux.cc"
)

set_target_properties(hybrid_ffi_linux PROPERTIES
  PUBLIC_HEADER hybrid_linux.h
  OUTPUT_NAME "hybrid_linux"
)

target_compile_definitions(hybrid_ffi_linux PUBLIC DART_SHARED_LIB)

# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
set(hybrid_ffi_bundled_libraries
  # Defined in ../src/CMakeLists.txt.
  # This can be changed to accommodate different builds.
  $<TARGET_FILE:hybrid_ffi>
  $<TARGET_FILE:hybrid_ffi_linux>
  PARENT_SCOPE
)
