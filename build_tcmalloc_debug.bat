@echo off
setlocal enabledelayedexpansion

call "%~dp0scripts\find_visual_studio.bat"

if %ERRORLEVEL% NEQ 0 goto :end

set SOURCE_DIR=%~dp0gperftools-build
set INSTALL_DIR=%~dp0tcmalloc

set BUILD_TYPE=windows-x64-debug
set BUILD_DIR=build\%BUILD_TYPE%

mkdir "%SOURCE_DIR%\%BUILD_DIR%"
cd "%SOURCE_DIR%\%BUILD_DIR%"

rem build gperftools
cmake -G Ninja ^
    -DCMAKE_BUILD_TYPE=Debug ^
    -DCMAKE_CXX_STANDARD=20 ^
    -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebug ^
    -DGPERFTOOLS_BUILD_CPU_PROFILER=OFF ^
    -DGPERFTOOLS_BUILD_HEAP_PROFILER=OFF ^
    -DGPERFTOOLS_BUILD_HEAP_CHECKER=OFF ^
    -DGPERFTOOLS_BUILD_DEBUGALLOC=OFF ^
    -Dgperftools_build_minimal=ON ^
    -DBUILD_TESTING=OFF ^
    -DWITH_STACK_TRACE=OFF ^
    ..\..\
ninja

rem exit
:end
exit /b 0
