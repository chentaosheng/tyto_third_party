#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

source "${SCRIPT_DIR}/scripts/compiler_flags.sh"

echo C_BUILD_FLAGS="${C_BUILD_FLAGS_RELEASE}"
echo CXX_BUILD_FLAGS="${CXX_BUILD_FLAGS_RELEASE}"

SOURCE_DIR="${SCRIPT_DIR}/abseil-cpp-build"
INSTALL_DIR="${SCRIPT_DIR}/absl"

BUILD_TYPE="linux-x64-release"
BUILD_DIR="build/${BUILD_TYPE}"

mkdir -p "${SOURCE_DIR}/${BUILD_DIR}"
cd "${SOURCE_DIR}/${BUILD_DIR}"

# build abseil-cpp
cmake -G Ninja \
    -DABSL_PROPAGATE_CXX_STD=ON \
    -DABSL_BUILD_TESTING=OFF \
    -DCMAKE_CXX_STANDARD=20 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="${CXX_BUILD_FLAGS_RELEASE}" \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
    -DCMAKE_INSTALL_INCLUDEDIR="include" \
    -DCMAKE_INSTALL_LIBDIR="lib/${BUILD_TYPE}" \
    ../../
ninja install

# protobuf env
ABSL_INSTALL_DIR="${INSTALL_DIR}"
SOURCE_DIR="${SCRIPT_DIR}/protobuf-build"
INSTALL_DIR="${SCRIPT_DIR}/protobuf"

ZLIB_INCLUDE_DIR="${SCRIPT_DIR}/zlib/include/linux"
ZLIB_LIB_FILE="${SCRIPT_DIR}/zlib/lib/${BUILD_TYPE}/libz.a"

mkdir -p "${SOURCE_DIR}/${BUILD_DIR}"
cd "${SOURCE_DIR}/${BUILD_DIR}"

# build protobuf
cmake -G Ninja \
    -DCMAKE_CXX_STANDARD=20 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="${CXX_BUILD_FLAGS_RELEASE}" \
    -Dprotobuf_BUILD_TESTS=OFF \
    -Dprotobuf_ABSL_PROVIDER=package \
    -Dprotobuf_WITH_ZLIB=ON \
    -DZLIB_INCLUDE_DIR="${ZLIB_INCLUDE_DIR}" \
    -DZLIB_LIBRARY="${ZLIB_LIB_FILE}" \
    -DCMAKE_PREFIX_PATH="${ABSL_INSTALL_DIR}/lib/${BUILD_TYPE}/cmake/absl" \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
    -DCMAKE_INSTALL_INCLUDEDIR="include" \
    -DCMAKE_INSTALL_LIBDIR="lib/${BUILD_TYPE}" \
    -DCMAKE_INSTALL_CMAKEDIR="lib/${BUILD_TYPE}/cmake" \
    -DCMAKE_INSTALL_BINDIR="bin" \
    ../../
ninja install
