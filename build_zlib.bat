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

REM build zlib debug
set BuildType=windows-x64-debug
set ZlibInstallDir="%~dp0\zlib"

cd "%~dp0\zlib-build"
mkdir build\%BuildType%
cd build\%BuildType%
cmake -G Ninja ^
	-DCMAKE_BUILD_TYPE=Debug ^
	-DCMAKE_INSTALL_PREFIX="%ZlibInstallDir%" ^
    -DINSTALL_INC_DIR="%ZlibInstallDir%\include\windows" ^
    -DINSTALL_LIB_DIR="%ZlibInstallDir%\lib\%BuildType%" ^
    -DINSTALL_MAN_DIR="%ZlibInstallDir%\share\man" ^
    -DINSTALL_PKGCONFIG_DIR="%ZlibInstallDir%\lib\%BuildType%\pkgconfig" ^
	-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebug ^
	..\..\
ninja install

REM remove shared library
rmdir /S /Q "%ZlibInstallDir%\bin"
del /Q /S "%ZlibInstallDir%\lib\%BuildType%\zlibd.lib"

REM build zlib release
set BuildType=windows-x64-release
set ZlibInstallDir="%~dp0\zlib"

cd "%~dp0\zlib-build"
mkdir build\%BuildType%
cd build\%BuildType%
cmake -G Ninja ^
	-DCMAKE_BUILD_TYPE=Release ^
	-DCMAKE_INSTALL_PREFIX="%ZlibInstallDir%" ^
    -DINSTALL_INC_DIR="%ZlibInstallDir%\include\windows" ^
    -DINSTALL_LIB_DIR="%ZlibInstallDir%\lib\%BuildType%" ^
    -DINSTALL_MAN_DIR="%ZlibInstallDir%\share\man" ^
    -DINSTALL_PKGCONFIG_DIR="%ZlibInstallDir%\lib\%BuildType%\pkgconfig" ^
	-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded ^
	..\..\
ninja install

REM remove shared library
rmdir /S /Q "%ZlibInstallDir%\bin"
del /Q /S "%ZlibInstallDir%\lib\%BuildType%\zlib.lib"

REM remove share dir
rmdir /S /Q "%ZlibInstallDir%\share"

goto :end

REM error
:missing
echo ERROR: the installation path of the Visual Studio not found.
goto :end

REM exit
:end
pause