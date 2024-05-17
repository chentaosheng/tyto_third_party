rem find the installation path of the Visual Studio
for /f "usebackq tokens=*" %%i in (`%~dp0\..\bin\vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
  set VISUAL_STUDIO_DIR=%%i
)

if "%VISUAL_STUDIO_DIR%" == "" goto :error

rem find the version of the cl.exe
if exist "%VISUAL_STUDIO_DIR%\VC\Auxiliary\Build\Microsoft.VCToolsVersion.default.txt" (
  set /p VISUAL_STUDIO_VERSION=<"%VISUAL_STUDIO_DIR%\VC\Auxiliary\Build\Microsoft.VCToolsVersion.default.txt"

  rem Trim
  set VISUAL_STUDIO_VERSION=!VISUAL_STUDIO_VERSION: =!
)

if "%VISUAL_STUDIO_VERSION%" == "" goto :error

goto :success

rem error
:error
echo ERROR: the installation path of the Visual Studio not found.
exit /b 1

rem success
:success
rem set the environment variables
call "%VISUAL_STUDIO_DIR%\VC\Auxiliary\Build\vcvarsall.bat" x64 -vcvars_ver=%VISUAL_STUDIO_VERSION%
exit /b 0
