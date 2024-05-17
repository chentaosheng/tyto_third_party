#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

source "${SCRIPT_DIR}/scripts/compiler_flags.sh"

echo C_BUILD_FLAGS="${C_BUILD_FLAGS_DEBUG}"
echo CXX_BUILD_FLAGS="${CXX_BUILD_FLAGS_DEBUG}"

SOURCE_DIR="${SCRIPT_DIR}/boost/include"
LIBRARY_DIR="${SCRIPT_DIR}/boost/lib"

BUILD_TYPE="linux-x64-debug"
BUILD_DIR="build/${BUILD_TYPE}"

cd "${SOURCE_DIR}"

bash ./bootstrap.sh

# build boost
./b2 --build-dir="${BUILD_DIR}" \
    toolset=gcc \
    architecture=x86 \
    address-model=64 \
    runtime-link=shared \
    link=static \
    threading=multi \
    variant=debug \
    cflags="${C_BUILD_FLAGS_DEBUG}" \
    cxxflags="${CXX_BUILD_FLAGS_DEBUG}" \
    --stagedir="${LIBRARY_DIR}" \
    stage

# rename output dir
mv "${LIBRARY_DIR}/lib" "${LIBRARY_DIR}/${BUILD_TYPE}"
