@echo off
setlocal enabledelayedexpansion

call "%~dp0\scripts\find_visual_studio.bat"

if %ERRORLEVEL% NEQ 0 goto :end

set SOURCE_DIR="%~dp0\abseil-cpp-build"
set INSTALL_DIR="%~dp0\absl"

set BUILD_TYPE="windows-x64-release"
set BUILD_DIR="build\%BUILD_TYPE%"

mkdir "%SOURCE_DIR%\%BUILD_DIR%"
cd "%SOURCE_DIR%\%BUILD_DIR%"

rem build abseil-cpp
cmake -G Ninja ^
	-DABSL_PROPAGATE_CXX_STD=ON ^
	-DABSL_BUILD_TESTING=OFF ^
	-DCMAKE_CXX_STANDARD=20 ^
	-DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded ^
    -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%" ^
	-DCMAKE_INSTALL_INCLUDEDIR="include" ^
	-DCMAKE_INSTALL_LIBDIR="lib\%BUILD_TYPE%" ^
	..\..\
ninja install

rem protobuf env
set ABSL_INSTALL_DIR="%INSTALL_DIR%"
set SOURCE_DIR="%~dp0\protobuf-build"
set INSTALL_DIR="%~dp0\protobuf"

set ZLIB_INCLUDE_DIR="%~dp0\zlib\include\windows"
set ZLIB_LIB_FILE="%~dp0\zlib\lib\%BUILD_TYPE%\zlibstatic.lib"

mkdir "%SOURCE_DIR%\%BUILD_DIR%"
cd "%SOURCE_DIR%\%BUILD_DIR%"

cmake -G Ninja ^
	-DCMAKE_CXX_STANDARD=20 ^
	-DCMAKE_BUILD_TYPE=Release ^
    -Dprotobuf_MSVC_STATIC_RUNTIME=ON ^
	-Dprotobuf_BUILD_TESTS=OFF ^
	-Dprotobuf_ABSL_PROVIDER=package ^
    -Dprotobuf_WITH_ZLIB=ON ^
    -DZLIB_INCLUDE_DIR="%ZLIB_INCLUDE_DIR%" ^
    -DZLIB_LIBRARY="%ZLIB_LIB_FILE%" ^
	-DCMAKE_PREFIX_PATH="%ABSL_INSTALL_DIR%\lib\%BUILD_TYPE%\cmake\absl" ^
    -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%" ^
	-DCMAKE_INSTALL_INCLUDEDIR="include" ^
	-DCMAKE_INSTALL_LIBDIR="lib\%BUILD_TYPE%" ^
    -DCMAKE_INSTALL_CMAKEDIR="lib/%BUILD_TYPE%/cmake" ^
	-DCMAKE_INSTALL_BINDIR="bin" ^
	..\..\
ninja install

rem exit
:end
pause
