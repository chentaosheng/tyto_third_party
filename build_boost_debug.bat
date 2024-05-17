@echo off
setlocal enabledelayedexpansion

call "%~dp0scripts\find_visual_studio.bat"

if %ERRORLEVEL% NEQ 0 goto :end

set SOURCE_DIR=%~dp0boost\include
set LIBRARY_DIR=%~dp0boost\lib

set BUILD_TYPE=windows-x64-debug
set BUILD_DIR=build\%BUILD_TYPE%

cd "%SOURCE_DIR%"

if not exist "b2.exe" (
    call .\bootstrap.bat
)

rem build boost
.\b2 --build-dir="%BUILD_DIR%" ^
    toolset=msvc ^
    architecture=x86 ^
    address-model=64 ^
    runtime-link=static ^
    link=static ^
    threading=multi ^
    variant=debug ^
    define=BOOST_USE_WINAPI_VERSION=0x0A00 ^
    --stagedir="%LIBRARY_DIR%" ^
    stage

rem rename output dir
cd "%LIBRARY_DIR%"
rmdir /S /Q "%BUILD_TYPE%"
rename "lib" "%BUILD_TYPE%"

rem exit
:end
exit /b 0
