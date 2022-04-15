cmake_minimum_required(VERSION 3.18)

project(tile3d CXX)

set(CMAKE_C_COMPILER   /usr/bin/clang-13)
set(CMAKE_CXX_COMPILER /usr/bin/clang++-13)

include(cmakes/macros.cmake)

make_app(load_data src/examples/load_data.cpp)