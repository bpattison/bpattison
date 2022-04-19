#!/bin/sh
export CC=/usr/bin/clang-13
export CXX=/usr/bin/clang++-13
rm -r build
cmake -B build -G Ninja