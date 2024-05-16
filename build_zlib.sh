#!/bin/bash

script_path=$(cd $(dirname $0); pwd)

# build abseil-cpp debug
build_type=linux-x64-debug
zlib_install_path="${script_path}/zlib"

cd "${script_path}/zlib-build"
mkdir -p "build/${build_type}"
cd "build/${build_type}"
cmake -G Ninja \
	-DCMAKE_BUILD_TYPE=Debug \
	-DCMAKE_INSTALL_PREFIX="${zlib_install_path}" \
    -DINSTALL_INC_DIR="${zlib_install_path}/include/linux" \
    -DINSTALL_LIB_DIR="${zlib_install_path}/lib/${build_type}" \
    -DINSTALL_MAN_DIR="${zlib_install_path}/share/man" \
    -DINSTALL_PKGCONFIG_DIR="${zlib_install_path}/lib/${build_type}/pkgconfig" \
	-DCMAKE_C_FLAGS='-g -fPIC' \
	../../
ninja install

# remove shared library
rm -f "${zlib_install_path}/lib/${build_type}/libz.so"*

# build abseil-cpp release
build_type=linux-x64-release
zlib_install_path="${script_path}/zlib"

cd "${script_path}/zlib-build"
mkdir -p "build/${build_type}"
cd "build/${build_type}"
cmake -G Ninja \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX="${zlib_install_path}" \
    -DINSTALL_INC_DIR="${zlib_install_path}/include/linux" \
    -DINSTALL_LIB_DIR="${zlib_install_path}/lib/${build_type}" \
    -DINSTALL_MAN_DIR="${zlib_install_path}/share/man" \
    -DINSTALL_PKGCONFIG_DIR="${zlib_install_path}/lib/${build_type}/pkgconfig" \
	-DCMAKE_C_FLAGS='-O2 -fPIC' \
	../../
ninja install

# remove shared library
rm -f "${zlib_install_path}/lib/${build_type}/libz.so"*

# remove share dir
rm -rf "${zlib_install_path}/share"
