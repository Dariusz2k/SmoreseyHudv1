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
echo 2. Build/Compile Mod
echo 3. Launch GTag Manager
echo 4. Install/Update BepInEx Dependencies
echo 5. Exit
echo.
echo ========================================
echo.
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" goto PULL_CODE
if "%choice%"=="2" goto BUILD_MOD
if "%choice%"=="3" goto LAUNCH_MANAGER
if "%choice%"=="4" goto INSTALL_DEPS
if "%choice%"=="5" goto EXIT_SCRIPT
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
) else (
    echo.
    echo ========================================
    echo Pull failed! Check errors above.
    echo ========================================
)
echo.
pause
goto MENU

REM ========================================
REM OPTION 2: Build/Compile Mod
REM ========================================
:BUILD_MOD
cls
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
    echo Please make sure Visual Studio is installed with .NET desktop development workload
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

REM Validate libs folder and required DLLs
echo Checking for required dependencies...
echo Current directory: %CD%
echo.

if not exist "libs" (
    echo ERROR: libs folder not found!
    echo Please ensure the libs folder exists with required DLLs
    echo Expected location: %CD%\libs
    echo.
    echo TIP: Use option 3 to launch GTag Manager and setup BepInEx DLLs
    echo.
    pause
    goto MENU
)

echo Found libs folder at: %CD%\libs
echo Contents:
dir /b libs\*.dll 2>nul
echo.

REM Check for BepInEx dependencies
set MISSING_DEPS=0

if not exist "libs\BepInEx.dll" (
    echo [MISSING] BepInEx.dll
    set MISSING_DEPS=1
) else (
    echo [OK] BepInEx.dll
)

if not exist "libs\BepInEx.Core.dll" (
    echo [MISSING] BepInEx.Core.dll
    set MISSING_DEPS=1
) else (
    echo [OK] BepInEx.Core.dll
)

if not exist "libs\0Harmony.dll" (
    echo [MISSING] 0Harmony.dll
    set MISSING_DEPS=1
) else (
    echo [OK] 0Harmony.dll
)

if not exist "libs\UnityEngine.dll" (
    echo [MISSING] UnityEngine.dll
    set MISSING_DEPS=1
) else (
    echo [OK] UnityEngine.dll
)

if not exist "libs\UnityEngine.CoreModule.dll" (
    echo [MISSING] UnityEngine.CoreModule.dll
    set MISSING_DEPS=1
) else (
    echo [OK] UnityEngine.CoreModule.dll
)

echo.

if %MISSING_DEPS% EQU 1 (
    echo ========================================
    echo ERROR: Missing required dependencies!
    echo ========================================
    echo.
    echo Some required DLLs are missing from the libs folder.
    echo.
    echo Would you like to automatically download BepInEx dependencies?
    echo.
    set /p DOWNLOAD_DEPS="Download BepInEx dependencies now? (Y/N): "

    if /i "%DOWNLOAD_DEPS%"=="Y" (
        echo.
        echo Running BepInEx setup script...
        echo.
        powershell.exe -ExecutionPolicy Bypass -File "%CD%\setup-bepinex.ps1"

        if %ERRORLEVEL% EQU 0 (
            echo.
            echo BepInEx dependencies installed successfully!
            echo.
            echo NOTE: You still need Unity DLLs from your Gorilla Tag installation.
            echo Use option 3 to launch GTag Manager for Unity DLL extraction.
            echo.
            pause
            goto BUILD_MOD
        ) else (
            echo.
            echo ERROR: Failed to download BepInEx dependencies!
            echo Please check your internet connection or download manually.
            echo.
            pause
            goto MENU
        )
    ) else (
        echo.
        echo Please install the missing dependencies:
        echo.
        echo For BepInEx DLLs: Run setup-bepinex.ps1
        echo For Unity DLLs: Use option 3 to launch GTag Manager
        echo.
        pause
        goto MENU
    )
)

echo All required DLLs found.
echo.

REM Build the project
echo Building project...
echo Running: MSBuild GTagSpeedMod\GTagSpeedMod.csproj /p:Configuration=Release
echo.
%MSBUILD_PATH% GTagSpeedMod\GTagSpeedMod.csproj /p:Configuration=Release /v:minimal /fl /flp:logfile=build.log;verbosity=diagnostic

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
    echo Detailed build log saved to: build.log
    echo.
) else (
    echo.
    echo ========================================
    echo BUILD FAILED!
    echo ========================================
    echo Check the error messages above
    echo.
    echo A detailed build log has been saved to: build.log
    echo This log contains diagnostic information to help troubleshoot the issue
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
REM OPTION 4: Install/Update BepInEx Dependencies
REM ========================================
:INSTALL_DEPS
cls
echo ========================================
echo Install/Update BepInEx Dependencies
echo ========================================
echo.

if not exist "setup-bepinex.ps1" (
    echo ERROR: setup-bepinex.ps1 not found!
    echo Expected location: %CD%\setup-bepinex.ps1
    echo.
    pause
    goto MENU
)

echo This will download and install the required BepInEx assemblies.
echo Existing files will be overwritten.
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause >nul

echo.
echo Running BepInEx setup script...
echo.
powershell.exe -ExecutionPolicy Bypass -File "%CD%\setup-bepinex.ps1"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Dependencies installed successfully!
    echo ========================================
    echo.
) else (
    echo.
    echo ========================================
    echo Installation failed or was cancelled.
    echo ========================================
    echo.
)

echo Returning to menu...
timeout /t 3 >nul
goto MENU

REM ========================================
REM OPTION 5: Exit
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
