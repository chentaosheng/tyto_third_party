#!/bin/bash

script_path=$(cd $(dirname $0); pwd)

# build abseil-cpp debug
abseil_perfix_path="${script_path}/absl"
abseil_install_includedir="${abseil_perfix_path}/include"
abseil_install_libdir="${abseil_perfix_path}/lib/linux-x64-debug"

cd "${script_path}/abseil-cpp-build"
mkdir -p build/linux-x64-debug
cd build/linux-x64-debug
cmake -G Ninja \
	-DABSL_PROPAGATE_CXX_STD=ON \
	-DABSL_BUILD_TESTING=OFF \
	-DCMAKE_CXX_STANDARD=20 \
	-DCMAKE_BUILD_TYPE=Debug \
	-DCMAKE_INSTALL_INCLUDEDIR=${abseil_install_includedir} \
	-DCMAKE_INSTALL_LIBDIR=${abseil_install_libdir} \
	../../
ninja install

# build abseil-cpp release
abseil_install_includedir="${abseil_perfix_path}/include"
abseil_install_libdir="${abseil_perfix_path}/lib/linux-x64-release"

cd "${script_path}/abseil-cpp-build"
mkdir -p build/linux-x64-release
cd build/linux-x64-release
cmake -G Ninja \
	-DABSL_PROPAGATE_CXX_STD=ON \
	-DABSL_BUILD_TESTING=OFF \
	-DCMAKE_CXX_STANDARD=20 \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_INCLUDEDIR=${abseil_install_includedir} \
	-DCMAKE_INSTALL_LIBDIR=${abseil_install_libdir} \
	../../
ninja install

# build protobuf debug
protobuf_install_dir="${script_path}/protobuf"
protobuf_install_includedir="${protobuf_install_dir}/include"
protobuf_install_libdir="${protobuf_install_dir}/lib/linux-x64-debug"
protobuf_install_bindir="${protobuf_install_dir}/bin"

cd "${script_path}/protobuf-build"
mkdir -p build/linux-x64-debug
cd build/linux-x64-debug
cmake -G Ninja \
	-DCMAKE_CXX_STANDARD=20 \
	-DCMAKE_BUILD_TYPE=Debug \
	-Dprotobuf_BUILD_TESTS=OFF \
	-Dprotobuf_ABSL_PROVIDER=package \
	-DCMAKE_PREFIX_PATH=${abseil_perfix_path}/lib/linux-x64-debug/cmake/absl \
	-DCMAKE_INSTALL_INCLUDEDIR=${protobuf_install_includedir} \
	-DCMAKE_INSTALL_LIBDIR=${protobuf_install_libdir} \
	-DCMAKE_INSTALL_BINDIR=${protobuf_install_bindir} \
	../../
ninja install

# build protobuf release
protobuf_install_includedir="${protobuf_install_dir}/include"
protobuf_install_libdir="${protobuf_install_dir}/lib/linux-x64-release"
protobuf_install_bindir="${protobuf_install_dir}/bin"

cd "${script_path}/protobuf-build"
mkdir -p build/linux-x64-release
cd build/linux-x64-release
cmake -G Ninja \
	-DCMAKE_CXX_STANDARD=20 \
	-DCMAKE_BUILD_TYPE=Release \
	-Dprotobuf_BUILD_TESTS=OFF \
	-Dprotobuf_ABSL_PROVIDER=package \
	-DCMAKE_PREFIX_PATH=${abseil_perfix_path}/lib/linux-x64-release/cmake/absl \
	-DCMAKE_INSTALL_INCLUDEDIR=${protobuf_install_includedir} \
	-DCMAKE_INSTALL_LIBDIR=${protobuf_install_libdir} \
	-DCMAKE_INSTALL_BINDIR=${protobuf_install_bindir} \
	../../
ninja install
