cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "lot_i2c")
project(${PROJECT_NAME} LANGUAGES CXX)

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "lot_i2c_plugin")

add_library(${PLUGIN_NAME} SHARED
    "lot_i2c_plugin.cc"
    "lot_i2c/lot_i2c.cpp"
)
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE
    "${CMAKE_CURRENT_SOURCE_DIR}/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/lot_i2c"
)
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::GTK)

# List of absolute paths to libraries that should be bundled with the plugin
set(lot_i2c_bundled_libraries
    "$<TARGET_FILE:lot_i2c>" # Library target name
    PARENT_SCOPE
)

add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/lot_i2c")
