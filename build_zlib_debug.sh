#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

source "${SCRIPT_DIR}/scripts/compiler_flags.sh"

echo C_BUILD_FLAGS="${C_BUILD_FLAGS_DEBUG}"
echo CXX_BUILD_FLAGS="${CXX_BUILD_FLAGS_DEBUG}"

SOURCE_DIR="${SCRIPT_DIR}/zlib-build"
INSTALL_DIR="${SCRIPT_DIR}/zlib"

BUILD_TYPE="linux-x64-debug"
BUILD_DIR="build/${BUILD_TYPE}"

mkdir -p "${SOURCE_DIR}/${BUILD_DIR}"
cd "${SOURCE_DIR}/${BUILD_DIR}"

# build zlib
cmake -G Ninja \
	-DCMAKE_BUILD_TYPE=Debug \
	-DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
    -DINSTALL_INC_DIR="${INSTALL_DIR}/include/linux" \
    -DINSTALL_LIB_DIR="${INSTALL_DIR}/lib/${BUILD_TYPE}" \
    -DINSTALL_MAN_DIR="${INSTALL_DIR}/share/man" \
    -DINSTALL_PKGCONFIG_DIR="${INSTALL_DIR}/lib/${BUILD_TYPE}/pkgconfig" \
	-DCMAKE_C_FLAGS="${C_BUILD_FLAGS_DEBUG}" \
	../../
ninja install

# remove shared library
rm -f "${INSTALL_DIR}/lib/${BUILD_TYPE}/libz.so"*

# remove share dir
rm -rf "${INSTALL_DIR}/share"
