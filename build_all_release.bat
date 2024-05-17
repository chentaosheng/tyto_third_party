@echo off
setlocal enabledelayedexpansion

call "%~dp0build_zlib_release.bat"
call "%~dp0build_protobuf_release.bat"
call "%~dp0build_boost_release.bat"
