@echo off
REM Setup script for haxe-fmod-test
REM Installs all required Haxe libraries including haxefmod from the target branch.
REM
REM Usage: setup.cmd
REM
REM For local development with a local haxe-fmod checkout, use:
REM   haxelib dev haxefmod /path/to/haxe-fmod
REM instead of running this script.

if not defined HAXEFMOD_BRANCH set HAXEFMOD_BRANCH=hashlink-refactor
if not defined HAXEFMOD_REPO set HAXEFMOD_REPO=https://github.com/Tanz0rz/haxe-fmod.git

echo === haxe-fmod-test setup ===
echo   haxefmod branch: %HAXEFMOD_BRANCH%
echo.

REM Ensure haxelib is configured
if not exist "%USERPROFILE%\haxelib\" (
  mkdir "%USERPROFILE%\haxelib"
  haxelib setup "%USERPROFILE%\haxelib"
)

REM Install dependencies
echo Installing dependencies...
haxelib install lime 8.3.0 --always --quiet
haxelib install openfl 9.5.0 --always --quiet
haxelib install flixel 6.1.2 --always --quiet
haxelib install hxcpp 4.3.2 --always --quiet

REM Remove any existing haxefmod installation (git, dev, or haxelib)
haxelib remove haxefmod 2>nul

REM Install haxefmod fresh from git branch
echo Installing haxefmod from %HAXEFMOD_REPO% @ %HAXEFMOD_BRANCH%
haxelib git haxefmod "%HAXEFMOD_REPO%" "%HAXEFMOD_BRANCH%" --always

REM Setup lime
echo y | haxelib run lime setup

echo.
echo === Setup complete ===
echo Build with: haxelib run lime build ^<target^>
echo   Targets: linux, mac, windows, hl, html5
