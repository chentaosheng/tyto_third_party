#!/bin/bash

# debug
C_BUILD_FLAGS_DEBUG="-pipe -g -fPIC -std=c11"
CXX_BUILD_FLAGS_DEBUG="-pipe -g -fPIC -std=c++20"

# release
C_BUILD_FLAGS_RELEASE="-pipe -g -O2 -fPIC -std=c11"
CXX_BUILD_FLAGS_RELEASE="-pipe -g -O2 -fPIC -std=c++20"

# 优化参数，注意CPU类型，编译出的exe在其他不同CPU的设备上可能会出问题
# C_BUILD_FLAGS_RELEASE="-pipe -g -O2 -fPIC -std=c11 -march=native -mtune=native -flto"
# CXX_BUILD_FLAGS_RELEASE="-pipe -g -O2 -fPIC -std=c++20 -march=native -mtune=native -flto"
