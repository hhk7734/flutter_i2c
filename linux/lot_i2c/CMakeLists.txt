cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "lot_i2c")
project(${PROJECT_NAME} LANGUAGES CXX)

add_library(${PROJECT_NAME} SHARED
    "${PROJECT_NAME}.cpp"
)

target_compile_options(${PROJECT_NAME} PRIVATE
    -std=c++17
    -Wall
    -Wextra
    -pedantic
    -Wshadow
)
target_include_directories(${PROJECT_NAME} PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}"
)