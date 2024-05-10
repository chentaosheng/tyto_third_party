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

REM build boost debug
cd "%~dp0\boost\include"
call .\bootstrap.bat
.\b2 --build-dir=build\windows-x64-debug toolset=msvc architecture=x86 address-model=64 runtime-link=static link=static threading=multi variant=debug define=BOOST_USE_WINAPI_VERSION=0x0A00 --stagedir=..\lib\ stage

REM rename output dir
cd ..
cd lib
rename lib windows-x64-debug
cd ..

REM build boost release
cd include
.\b2 --build-dir=build\windows-x64-release toolset=msvc architecture=x86 address-model=64 runtime-link=static link=static threading=multi variant=release define=BOOST_USE_WINAPI_VERSION=0x0A00 --stagedir=..\lib\ stage

REM rename output dir
cd ..
cd lib
rename lib windows-x64-release
cd ..

goto :end

REM error
:missing
echo ERROR: the installation path of the Visual Studio not found.
goto :end

REM exit
:end
pause