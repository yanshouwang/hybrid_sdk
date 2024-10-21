cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "hybrid_v4l2")
project(${PROJECT_NAME} LANGUAGES CXX)

# Invoke the build for native code shared with the other target platforms.
# This can be changed to accommodate different builds.
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../src" "${CMAKE_CURRENT_BINARY_DIR}/shared")

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "hybrid_v4l2_plugin")

find_package(PkgConfig)
pkg_check_modules(GLIB REQUIRED IMPORTED_TARGET glib-2.0)

add_library(${PLUGIN_NAME} SHARED
  "hybrid_v4l2_api.cc"
  "hybrid_v4l2_plugin.cc"
  "hybrid_v4l2_texture.cc"
  "hybrid_v4l2_view_api.cc"
)
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::GLIB)

# List of absolute paths to libraries that should be bundled with the plugin
set(hybrid_v4l2_bundled_libraries
  # Defined in ../src/CMakeLists.txt.
  # This can be changed to accommodate different builds.
  $<TARGET_FILE:hybrid_v4l2>
  PARENT_SCOPE
)
