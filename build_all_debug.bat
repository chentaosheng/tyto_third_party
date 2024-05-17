@echo off
setlocal enabledelayedexpansion

call "%~dp0build_zlib_debug.bat"
call "%~dp0build_protobuf_debug.bat"
call "%~dp0build_boost_debug.bat"
