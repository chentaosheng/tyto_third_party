#!/bin/bash

script_path=$(cd $(dirname $0); pwd)

# build abseil-cpp debug
build_type=linux-x64-debug
abseil_perfix_path="${script_path}/absl"
abseil_install_includedir="include"
abseil_install_libdir="lib/${build_type}"

cd "${script_path}/abseil-cpp-build"
mkdir -p build/${build_type}
cd build/${build_type}
cmake -G Ninja \
	-DABSL_PROPAGATE_CXX_STD=ON \
	-DABSL_BUILD_TESTING=OFF \
	-DCMAKE_CXX_STANDARD=20 \
	-DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_CXX_FLAGS='-g -fPIC' \
    -DCMAKE_INSTALL_PREFIX=${abseil_perfix_path} \
	-DCMAKE_INSTALL_INCLUDEDIR=${abseil_install_includedir} \
	-DCMAKE_INSTALL_LIBDIR=${abseil_install_libdir} \
	../../
ninja install

# build abseil-cpp release
build_type=linux-x64-release
abseil_install_includedir="include"
abseil_install_libdir="lib/${build_type}"

cd "${script_path}/abseil-cpp-build"
mkdir -p build/${build_type}
cd build/${build_type}
cmake -G Ninja \
	-DABSL_PROPAGATE_CXX_STD=ON \
	-DABSL_BUILD_TESTING=OFF \
	-DCMAKE_CXX_STANDARD=20 \
	-DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS='-O2 -fPIC' \
    -DCMAKE_INSTALL_PREFIX=${abseil_perfix_path} \
	-DCMAKE_INSTALL_INCLUDEDIR=${abseil_install_includedir} \
	-DCMAKE_INSTALL_LIBDIR=${abseil_install_libdir} \
	../../
ninja install

# build protobuf debug
build_type=linux-x64-debug
protobuf_install_dir="${script_path}/protobuf"
protobuf_install_includedir="${protobuf_install_dir}/include"
protobuf_install_libdir="${protobuf_install_dir}/lib/${build_type}"
protobuf_install_cmakedir="${protobuf_install_libdir}/cmake"
protobuf_install_bindir="${protobuf_install_dir}/bin"

zlib_includedir="${script_path}/zlib/include/linux"
zlib_libdir="${script_path}/zlib/lib/${build_type}/libz.a"

cd "${script_path}/protobuf-build"
mkdir -p build/${build_type}
cd build/${build_type}
cmake -G Ninja \
	-DCMAKE_CXX_STANDARD=20 \
	-DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_CXX_FLAGS='-g -fPIC' \
	-Dprotobuf_BUILD_TESTS=OFF \
	-Dprotobuf_ABSL_PROVIDER=package \
    -Dprotobuf_WITH_ZLIB=ON \
    -DZLIB_INCLUDE_DIR=${zlib_includedir} \
    -DZLIB_LIBRARY=${zlib_libdir} \
	-DCMAKE_PREFIX_PATH=${abseil_perfix_path}/lib/${build_type}/cmake/absl \
    -DDCMAKE_INSTALL_PREFIX=${protobuf_install_dir} \
	-DCMAKE_INSTALL_INCLUDEDIR=${protobuf_install_includedir} \
	-DCMAKE_INSTALL_LIBDIR=${protobuf_install_libdir} \
    -DCMAKE_INSTALL_CMAKEDIR=${protobuf_install_cmakedir} \
	-DCMAKE_INSTALL_BINDIR=${protobuf_install_bindir} \
	../../
ninja install

# build protobuf release
build_type=linux-x64-release
protobuf_install_includedir="${protobuf_install_dir}/include"
protobuf_install_libdir="${protobuf_install_dir}/lib/${build_type}"
protobuf_install_cmakedir="${protobuf_install_libdir}/cmake"
protobuf_install_bindir="${protobuf_install_dir}/bin"

zlib_includedir="${script_path}/zlib/include/linux"
zlib_libdir="${script_path}/zlib/lib/${build_type}/libz.a"

cd "${script_path}/protobuf-build"
mkdir -p build/${build_type}
cd build/${build_type}
cmake -G Ninja \
	-DCMAKE_CXX_STANDARD=20 \
	-DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS='-O2 -fPIC' \
	-Dprotobuf_BUILD_TESTS=OFF \
	-Dprotobuf_ABSL_PROVIDER=package \
    -Dprotobuf_WITH_ZLIB=ON \
    -DZLIB_INCLUDE_DIR=${zlib_includedir} \
    -DZLIB_LIBRARY=${zlib_libdir} \
	-DCMAKE_PREFIX_PATH=${abseil_perfix_path}/lib/${build_type}/cmake/absl \
    -DDCMAKE_INSTALL_PREFIX=${protobuf_install_dir} \
	-DCMAKE_INSTALL_INCLUDEDIR=${protobuf_install_includedir} \
	-DCMAKE_INSTALL_LIBDIR=${protobuf_install_libdir} \
    -DCMAKE_INSTALL_CMAKEDIR=${protobuf_install_cmakedir} \
	-DCMAKE_INSTALL_BINDIR=${protobuf_install_bindir} \
	../../
ninja install
