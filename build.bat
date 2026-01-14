@echo off
echo ========================================
echo Building GTag Speed Mod
echo ========================================
echo.

REM Use vswhere to find any installed Visual Studio
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"

if not exist "%VSWHERE%" (
    echo ERROR: vswhere.exe not found!
    echo Visual Studio installer may not be present.
    echo Please reinstall Visual Studio with .NET desktop development workload
    pause
    exit /b 1
)

REM Find the installation path of the latest Visual Studio
for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.Component.MSBuild -property installationPath`) do (
    set VS_PATH=%%i
)

if not defined VS_PATH (
    echo ERROR: Visual Studio installation not found!
    echo Please make sure Visual Studio is installed with .NET desktop development workload
    pause
    exit /b 1
)

REM Construct MSBuild path
set MSBUILD_PATH="%VS_PATH%\MSBuild\Current\Bin\MSBuild.exe"

if not exist %MSBUILD_PATH% (
    echo ERROR: MSBuild not found at expected location!
    echo Expected: %MSBUILD_PATH%
    pause
    exit /b 1
)

echo Found Visual Studio at: %VS_PATH%
echo Found MSBuild at: %MSBUILD_PATH%
echo.

REM Validate libs folder and required DLLs
echo Checking for required dependencies...
if not exist "libs" (
    echo ERROR: libs folder not found!
    echo Please ensure the libs folder exists with required DLLs
    pause
    exit /b 1
)

if not exist "libs\BepInEx.dll" (
    echo ERROR: BepInEx.dll not found in libs folder!
    echo Please ensure BepInEx.dll is in the libs folder
    pause
    exit /b 1
)

if not exist "libs\UnityEngine.dll" (
    echo ERROR: UnityEngine.dll not found in libs folder!
    echo Please ensure UnityEngine.dll is in the libs folder
    pause
    exit /b 1
)

if not exist "libs\UnityEngine.CoreModule.dll" (
    echo ERROR: UnityEngine.CoreModule.dll not found in libs folder!
    echo Please ensure UnityEngine.CoreModule.dll is in the libs folder
    pause
    exit /b 1
)

echo All required DLLs found.
echo.

REM Build the project
echo Building project...
%MSBUILD_PATH% GTagSpeedMod\GTagSpeedMod.csproj /p:Configuration=Release /v:minimal

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo BUILD SUCCESSFUL!
    echo ========================================
    echo.
    echo Your mod DLL is located at:
    echo GTagSpeedMod\bin\Release\GTagSpeedMod.dll
    echo.
    echo Copy this file to:
    echo [Gorilla Tag Folder]\BepInEx\plugins\
    echo.
) else (
    echo.
    echo ========================================
    echo BUILD FAILED!
    echo ========================================
    echo Check the error messages above
    echo.
)

pause