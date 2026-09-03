@echo off
setlocal enabledelayedexpansion

set VCVARS="C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat"
if not exist %VCVARS% (
    echo Error: vcvarsall.bat not found
    exit /b 1
)

call %VCVARS% x86

set CONFIG=Debug
if not "%1"=="" set CONFIG=%1

set BUILD_DIR=%~dp0build\%CONFIG%

echo === Configuring CMake ===
cmake -B "%BUILD_DIR%" -S "%~dp0." -G "Visual Studio 17 2022" -A Win32
if %ERRORLEVEL% neq 0 (
    echo CMake configure failed
    exit /b 1
)

echo === Building %CONFIG% ===
cmake --build "%BUILD_DIR%" --config %CONFIG%
if %ERRORLEVEL% neq 0 (
    echo CMake build failed
    exit /b 1
)

echo === Build successful ===
set OUTPUT=%BUILD_DIR%\bin\AnimFix.dll
if exist "%OUTPUT%" (
    echo Output: %OUTPUT%
    for %%F in ("%OUTPUT%") do echo Size: %%~zF bytes
) else (
    set OUTPUT=%BUILD_DIR%\AnimFix.dll
    if exist "!OUTPUT!" (
        echo Output: !OUTPUT!
        for %%F in ("!OUTPUT!") do echo Size: %%~zF bytes
    )
)
