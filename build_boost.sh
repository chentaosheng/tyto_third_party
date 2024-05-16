#!/bin/bash

script_path=$(cd $(dirname $0); pwd)

# build boost debug
cd "${script_path}/boost/include"
./bootstrap.sh
./b2 --build-dir=build/linux-x64-debug toolset=gcc architecture=x86 address-model=64 runtime-link=shared link=static threading=multi variant=debug cxxflags="-fPIC -std=c++20" cflags="-fPIC -std=c++20" --stagedir=../lib/ stage

# rename output dir
cd ..
cd lib
mv lib linux-x64-debug
cd ..

# build boost release
cd "${script_path}/boost/include"
./b2 --build-dir=build/linux-x64-release toolset=gcc architecture=x86 address-model=64 runtime-link=shared link=static threading=multi variant=release cxxflags="-fPIC -std=c++20" cflags="-fPIC -std=c++20" --stagedir=../lib/ stage

# rename output dir
cd ..
cd lib
mv lib linux-x64-release
cd ..
