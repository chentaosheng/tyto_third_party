#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

source "${SCRIPT_DIR}/scripts/compiler_flags.sh"

echo C_BUILD_FLAGS="${C_BUILD_FLAGS_DEBUG}"
echo CXX_BUILD_FLAGS="${CXX_BUILD_FLAGS_DEBUG}"

SOURCE_DIR="${SCRIPT_DIR}/libunwind-build"
INSTALL_DIR="/usr/local"

BUILD_TYPE="linux-x64-debug"
BUILD_DIR="build/${BUILD_TYPE}"

mkdir -p "${SOURCE_DIR}/${BUILD_DIR}"
cd "${SOURCE_DIR}/${BUILD_DIR}"

bash ../../configure \
    --prefix "${INSTALL_DIR}" \
    --libdir "${INSTALL_DIR}/lib64" \
    CFLAGS="${C_BUILD_FLAGS_DEBUG}"
make install

SOURCE_DIR="${SCRIPT_DIR}/gperftools-build"
INSTALL_DIR="${SCRIPT_DIR}/tcmalloc"

BUILD_TYPE="linux-x64-debug"
BUILD_DIR="build/${BUILD_TYPE}"

cd "${SOURCE_DIR}"
bash autogen.sh

mkdir -p "${SOURCE_DIR}/${BUILD_DIR}"
cd "${SOURCE_DIR}/${BUILD_DIR}"

bash "${SOURCE_DIR}/configure" \
    --prefix "${INSTALL_DIR}" \
    --includedir "${INSTALL_DIR}/include/linux" \
    --libdir "${INSTALL_DIR}/lib/${BUILD_TYPE}" \
    --disable-cpu-profiler \
    --disable-heap-profiler \
    --disable-heap-checker \
    --disable-debugalloc \
    --enable-minimal \
    --enable-static \
    --enable-shared=no \
    CXXFLAGS="${CXX_BUILD_FLAGS_DEBUG}"
make install

rm -rf "${INSTALL_DIR}/share"
