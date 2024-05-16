@echo off
setlocal enabledelayedexpansion

REM find the installation path of the Visual Studio
for /f "usebackq tokens=*" %%i in (`%~dp0\bin\vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
  set InstallDir=%%i
)

if "%InstallDir%" == "" goto :missing

REM find the version of the cl.exe
if exist "%InstallDir%\VC\Auxiliary\Build\Microsoft.VCToolsVersion.default.txt" (
  set /p Version=<"%InstallDir%\VC\Auxiliary\Build\Microsoft.VCToolsVersion.default.txt"

  rem Trim
  set Version=!Version: =!
)

if "%Version%" == "" goto :missing

REM set the environment variables
call "%InstallDir%\VC\Auxiliary\Build\vcvarsall.bat" x64 -vcvars_ver=%Version%

REM build abseil-cpp debug
set BuildType=windows-x64-debug
set AbseilPerfixPath="%~dp0\absl"
set AbseilInstallIncludedir="include"
set AbseilInstallLibdir="lib\%BuildType%"

cd "%~dp0\abseil-cpp-build"
mkdir build\%BuildType%
cd build\%BuildType%
cmake -G Ninja ^
	-DABSL_PROPAGATE_CXX_STD=ON ^
	-DABSL_BUILD_TESTING=OFF ^
	-DCMAKE_CXX_STANDARD=20 ^
	-DCMAKE_BUILD_TYPE=Debug ^
    -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebug ^
    -DCMAKE_INSTALL_PREFIX="%AbseilPerfixPath%" ^
	-DCMAKE_INSTALL_INCLUDEDIR="%AbseilInstallIncludedir%" ^
	-DCMAKE_INSTALL_LIBDIR="%AbseilInstallLibdir%" ^
	..\..\
ninja install

REM build abseil-cpp release
set BuildType=windows-x64-release
set AbseilInstallIncludedir="include"
set AbseilInstallLibdir="lib\%BuildType%"

cd "%~dp0\abseil-cpp-build"
mkdir build\%BuildType%
cd build\%BuildType%
cmake -G Ninja ^
	-DABSL_PROPAGATE_CXX_STD=ON ^
	-DABSL_BUILD_TESTING=OFF ^
	-DCMAKE_CXX_STANDARD=20 ^
	-DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded ^
    -DCMAKE_INSTALL_PREFIX="%AbseilPerfixPath%" ^
	-DCMAKE_INSTALL_INCLUDEDIR="%AbseilInstallIncludedir%" ^
	-DCMAKE_INSTALL_LIBDIR="%AbseilInstallLibdir%" ^
	..\..\
ninja install

REM build protobuf debug
set BuildType=windows-x64-debug
set ProtobufInstallDir="%~dp0\protobuf"
set ProtobufInstallIncludedir="include"
set ProtobufInstallLibdir="lib\%BuildType%"
REM 这里有BUG，要用/，不能用\
set ProtobufInstallCmakedir="lib/%BuildType%/cmake"
set ProtobufInstallBindir="bin"

set ZlibIncludeDir="%~dp0\zlib\include\windows"
set ZlibLibDir="%~dp0\zlib\lib\%BuildType%\zlibstaticd.lib"

cd "%~dp0\protobuf-build"
mkdir build\%BuildType%
cd build\%BuildType%
cmake -G Ninja ^
	-DCMAKE_CXX_STANDARD=20 ^
	-DCMAKE_BUILD_TYPE=Debug ^
    -Dprotobuf_MSVC_STATIC_RUNTIME=ON ^
	-Dprotobuf_BUILD_TESTS=OFF ^
	-Dprotobuf_ABSL_PROVIDER=package ^
    -Dprotobuf_WITH_ZLIB=ON ^
    -DZLIB_INCLUDE_DIR="%ZlibIncludeDir%" ^
    -DZLIB_LIBRARY="%ZlibLibDir%" ^
	-DCMAKE_PREFIX_PATH="%AbseilPerfixPath%\lib\%BuildType%\cmake\absl" ^
    -DCMAKE_INSTALL_PREFIX="%ProtobufInstallDir%" ^
	-DCMAKE_INSTALL_INCLUDEDIR="%ProtobufInstallIncludedir%" ^
	-DCMAKE_INSTALL_LIBDIR="%ProtobufInstallLibdir%" ^
    -DCMAKE_INSTALL_CMAKEDIR="%ProtobufInstallCmakedir%" ^
	-DCMAKE_INSTALL_BINDIR="%ProtobufInstallBindir%" ^
	..\..\
ninja install

REM build protobuf release
set BuildType=windows-x64-release
set ProtobufInstallIncludedir="include"
set ProtobufInstallLibdir="lib\%BuildType%"
REM 这里有BUG，要用/，不能用\
set ProtobufInstallCmakedir="lib/%BuildType%/cmake"
set ProtobufInstallBindir="bin"

set ZlibIncludeDir="%~dp0\zlib\include\windows"
set ZlibLibDir="%~dp0\zlib\lib\%BuildType%\zlibstatic.lib"

cd "%~dp0\protobuf-build"
mkdir build\%BuildType%
cd build\%BuildType%
cmake -G Ninja ^
	-DCMAKE_CXX_STANDARD=20 ^
    -Dprotobuf_MSVC_STATIC_RUNTIME=ON ^
	-DCMAKE_BUILD_TYPE=Release ^
	-Dprotobuf_BUILD_TESTS=OFF ^
	-Dprotobuf_ABSL_PROVIDER=package ^
    -Dprotobuf_WITH_ZLIB=ON ^
    -DZLIB_INCLUDE_DIR="%ZlibIncludeDir%" ^
    -DZLIB_LIBRARY="%ZlibLibDir%" ^
	-DCMAKE_PREFIX_PATH="%AbseilPerfixPath%\lib\%BuildType%\cmake\absl" ^
    -DCMAKE_INSTALL_PREFIX="%ProtobufInstallDir%" ^
	-DCMAKE_INSTALL_INCLUDEDIR="%ProtobufInstallIncludedir%" ^
	-DCMAKE_INSTALL_LIBDIR="%ProtobufInstallLibdir%" ^
    -DCMAKE_INSTALL_CMAKEDIR="%ProtobufInstallCmakedir%" ^
	-DCMAKE_INSTALL_BINDIR="%ProtobufInstallBindir%" ^
	..\..\
ninja install

goto :end

REM error
:missing
echo ERROR: the installation path of the Visual Studio not found.
goto :end

REM exit
:end
pause
