@echo off
setlocal enabledelayedexpansion

call "%~dp0\scripts\find_visual_studio.bat"

if %ERRORLEVEL% NEQ 0 goto :end

set SOURCE_DIR="%~dp0\zlib-build"
set INSTALL_DIR="%~dp0\zlib"

set BUILD_TYPE="windows-x64-debug"
set BUILD_DIR="build\%BUILD_TYPE%"

mkdir "%SOURCE_DIR%\%BUILD_DIR%"
cd "%SOURCE_DIR%\%BUILD_DIR%"

rem build zlib
cmake -G Ninja ^
	-DCMAKE_BUILD_TYPE=Debug ^
	-DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%" ^
    -DINSTALL_INC_DIR="%INSTALL_DIR%\include\windows" ^
    -DINSTALL_LIB_DIR="%INSTALL_DIR%\lib\%BUILD_TYPE%" ^
    -DINSTALL_MAN_DIR="%INSTALL_DIR%\share\man" ^
    -DINSTALL_PKGCONFIG_DIR="%INSTALL_DIR%\lib\%BUILD_TYPE%\pkgconfig" ^
	-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebug ^
	..\..\
ninja install

rem remove shared library
rmdir /S /Q "%INSTALL_DIR%\bin"
del /Q /S "%INSTALL_DIR%\lib\%BUILD_TYPE%\zlibd.lib"

REM remove share dir
rmdir /S /Q "%INSTALL_DIR%\share"

rem exit
:end
pause
