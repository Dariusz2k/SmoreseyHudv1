@echo off
title GTag Mod Menu
color 0A

:MENU
cls
echo ========================================
echo        GTag Mod Development Menu
echo ========================================
echo.
echo 1. Pull Latest Code from Git
echo 2. Build/Compile Mod (Uses NuGet Packages)
echo 3. Launch GTag Manager
echo 4. Install BepInEx Templates (for .NET SDK)
echo 5. Extract Unity DLLs from Gorilla Tag
echo 6. Exit
echo.
echo ========================================
echo.
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto PULL_CODE
if "%choice%"=="2" goto BUILD_MOD
if "%choice%"=="3" goto LAUNCH_MANAGER
if "%choice%"=="4" goto INSTALL_TEMPLATES
if "%choice%"=="5" goto EXTRACT_UNITY
if "%choice%"=="6" goto EXIT_SCRIPT
echo Invalid choice! Please try again.
timeout /t 2 >nul
goto MENU

REM ========================================
REM OPTION 1: Pull Latest Code
REM ========================================
:PULL_CODE
cls
echo ========================================
echo Pulling Latest Code from Git
echo ========================================
echo.

REM Check if git is available
where git >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Git is not installed or not in PATH!
    echo Please install Git for Windows from https://git-scm.com/
    echo.
    pause
    goto MENU
)

REM Get current branch
for /f "tokens=*" %%b in ('git rev-parse --abbrev-ref HEAD 2^>nul') do set CURRENT_BRANCH=%%b

if not defined CURRENT_BRANCH (
    echo ERROR: Not in a git repository!
    echo.
    pause
    goto MENU
)

echo Current branch: %CURRENT_BRANCH%
echo.
echo Fetching latest changes...
git fetch origin

echo.
echo Pulling changes for branch: %CURRENT_BRANCH%
git pull origin %CURRENT_BRANCH%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Pull completed successfully!
    echo ========================================
    echo.
    echo Reloading build menu with latest changes...
    timeout /t 2 >nul
    call "%~f0"
    exit /b
) else (
    echo.
    echo ========================================
    echo Pull failed! Check errors above.
    echo ========================================
    echo.
    pause
    goto MENU
)

REM ========================================
REM OPTION 2: Build/Compile Mod
REM ========================================
:BUILD_MOD
cls
echo ========================================
echo Building GTag Speed Mod
echo ========================================
echo.

REM Check for .NET SDK first (preferred method)
where dotnet >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Found .NET SDK, using dotnet build...
    echo.

    REM Clean previous builds
    if exist "GTagSpeedMod\bin" rmdir /s /q "GTagSpeedMod\bin" 2>nul
    if exist "GTagSpeedMod\obj" rmdir /s /q "GTagSpeedMod\obj" 2>nul

    REM Build using dotnet CLI (handles restore automatically)
    dotnet build GTagSpeedMod\GTagSpeedMod.csproj -c Release -v minimal

    if %ERRORLEVEL% EQU 0 (
        echo.
        echo ========================================
        echo BUILD SUCCESSFUL!
        echo ========================================
        echo.
        echo Your mod DLL is located at:
        echo GTagSpeedMod\bin\Release\net472\GTagSpeedMod.dll
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
        echo TIP: Make sure you have .NET Framework 4.7.2 targeting pack installed
        echo Download from: https://dotnet.microsoft.com/download/dotnet-framework/net472
        echo.
    )
    pause
    goto MENU
)

echo .NET SDK not found, checking for Visual Studio...
echo.

REM Fall back to MSBuild if dotnet is not available
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"

if not exist "%VSWHERE%" (
    echo ERROR: Neither .NET SDK nor Visual Studio found!
    echo.
    echo Please install one of the following:
    echo   1. .NET SDK 6.0+ from: https://dotnet.microsoft.com/download
    echo   2. Visual Studio with .NET desktop development workload
    echo.
    pause
    goto MENU
)

REM Find the installation path of the latest Visual Studio
for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.Component.MSBuild -property installationPath`) do (
    set VS_PATH=%%i
)

if not defined VS_PATH (
    echo ERROR: Visual Studio installation not found!
    echo Please install .NET SDK or Visual Studio with .NET desktop development workload
    echo.
    pause
    goto MENU
)

REM Construct MSBuild path
set MSBUILD_PATH="%VS_PATH%\MSBuild\Current\Bin\MSBuild.exe"

if not exist %MSBUILD_PATH% (
    echo ERROR: MSBuild not found at expected location!
    echo Expected: %MSBUILD_PATH%
    echo.
    pause
    goto MENU
)

echo Found Visual Studio at: %VS_PATH%
echo Found MSBuild at: %MSBUILD_PATH%
echo.

REM Build the project with MSBuild (using restore target)
echo Building project with MSBuild...
echo.
%MSBUILD_PATH% GTagSpeedMod\GTagSpeedMod.csproj /t:Restore;Build /p:Configuration=Release /v:minimal

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo BUILD SUCCESSFUL!
    echo ========================================
    echo.
    echo Your mod DLL is located at:
    echo GTagSpeedMod\bin\Release\net472\GTagSpeedMod.dll
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
    echo TIP: Make sure you have .NET Framework 4.7.2 targeting pack installed
    echo Download from: https://dotnet.microsoft.com/download/dotnet-framework/net472
    echo.
)
pause
goto MENU

REM ========================================
REM OPTION 3: Launch GTag Manager
REM ========================================
:LAUNCH_MANAGER
cls
echo ========================================
echo Launching GTag Manager
echo ========================================
echo.

if not exist "GTagManager.ps1" (
    echo ERROR: GTagManager.ps1 not found!
    echo Expected location: %CD%\GTagManager.ps1
    echo.
    pause
    goto MENU
)

echo Starting PowerShell GUI Manager...
echo This will help you setup BepInEx and extract required DLLs.
echo.
echo Press any key to launch...
pause >nul

REM Launch PowerShell script
powershell.exe -ExecutionPolicy Bypass -File "%CD%\GTagManager.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo WARNING: GTag Manager closed or encountered an error.
    echo.
)

echo.
echo Returning to menu...
timeout /t 2 >nul
goto MENU

REM ========================================
REM OPTION 4: Install BepInEx Templates
REM ========================================
:INSTALL_TEMPLATES
cls
echo ========================================
echo Install BepInEx Templates for .NET SDK
echo ========================================
echo.

REM Check if dotnet is installed
where dotnet >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: .NET SDK is not installed!
    echo.
    echo Please install .NET SDK 6.0 or later from:
    echo https://dotnet.microsoft.com/download
    echo.
    echo After installing, you can use this option to install BepInEx templates
    echo for creating new plugins easily.
    echo.
    pause
    goto MENU
)

echo Found .NET SDK. Checking version...
dotnet --version
echo.

echo This will install BepInEx plugin templates for creating new mods.
echo.
echo Available templates after installation:
echo   - BepInEx 5 Plugin (bepinex5plugin)
echo   - BepInEx 6 Unity Mono Plugin (bep6plugin_unity_mono)
echo   - BepInEx 6 Unity Il2Cpp Plugin (bep6plugin_unity_il2cpp)
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause >nul

echo.
echo Installing BepInEx templates from NuGet...
echo.
dotnet new install BepInEx.Templates --nuget-source https://nuget.bepinex.dev/v3/index.json

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Templates installed successfully!
    echo ========================================
    echo.
    echo You can now create new BepInEx plugins using:
    echo   dotnet new bepinex5plugin -n YourModName
    echo.
    echo To see all available templates, run:
    echo   dotnet new list
    echo.
) else (
    echo.
    echo ========================================
    echo Installation failed!
    echo ========================================
    echo Check your internet connection and try again.
    echo.
)

pause
goto MENU

REM ========================================
REM OPTION 5: Extract Unity DLLs
REM ========================================
:EXTRACT_UNITY
cls
echo ========================================
echo Extract Unity DLLs from Gorilla Tag
echo ========================================
echo.

if not exist "extract-unity-dlls.ps1" (
    echo ERROR: extract-unity-dlls.ps1 not found!
    echo Expected location: %CD%\extract-unity-dlls.ps1
    echo.
    pause
    goto MENU
)

echo This will extract required Unity DLLs from your Gorilla Tag installation.
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause >nul

echo.
echo Running Unity DLL extraction script...
echo.
powershell.exe -ExecutionPolicy Bypass -File "%CD%\extract-unity-dlls.ps1"

echo.
echo Returning to menu...
timeout /t 2 >nul
goto MENU

REM ========================================
REM OPTION 6: Exit
REM ========================================
:EXIT_SCRIPT
cls
echo ========================================
echo Exiting GTag Mod Menu
echo ========================================
echo.
echo Thank you for using GTag Mod Development Menu!
echo.
timeout /t 2 >nul
exit /b 0
