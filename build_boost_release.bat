@echo off
setlocal enabledelayedexpansion

call "%~dp0\scripts\find_visual_studio.bat"

if %ERRORLEVEL% NEQ 0 goto :end

set SOURCE_DIR="%~dp0\boost\include"
set LIBRARY_DIR="%~dp0\boost\lib"

set BUILD_TYPE="windows-x64-release"
set BUILD_DIR="build\%BUILD_TYPE%"

cd "%SOURCE_DIR%"

call .\bootstrap.bat

rem build boost
.\b2 --build-dir="%BUILD_DIR%" ^
    toolset=msvc ^
    architecture=x86 ^
    address-model=64 ^
    runtime-link=static ^
    link=static ^
    threading=multi ^
    variant=release ^
    define=BOOST_USE_WINAPI_VERSION=0x0A00 ^
    --stagedir="%LIBRARY_DIR%" ^
    stage

rem rename output dir
rename "%LIBRARY_DIR%\lib" "%LIBRARY_DIR%\%BUILD_TYPE%"

rem exit
:end
pause
