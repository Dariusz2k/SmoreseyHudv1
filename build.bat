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
echo 5. Extract Unity DLLs from Gorilla Tag
echo 6. Exit
echo.
echo ========================================
echo.
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto PULL_CODE
if "%choice%"=="2" goto BUILD_MOD
if "%choice%"=="3" goto LAUNCH_MANAGER
if "%choice%"=="4" goto INSTALL_DEPS
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

REM Check if .NET SDK is installed
where dotnet >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: .NET SDK is not installed or not in PATH!
    echo.
    echo Please install .NET SDK from:
    echo https://dotnet.microsoft.com/download
    echo.
    echo After installation, restart your command prompt and try again.
    echo.
    pause
    goto MENU
)

REM Display .NET SDK version
for /f "tokens=*" %%v in ('dotnet --version 2^>nul') do set DOTNET_VERSION=%%v
echo Found .NET SDK version: %DOTNET_VERSION%
echo Using BepInEx 6 with NuGet package management
echo.

REM Validate libs folder and Unity DLLs
echo Checking for Unity dependencies...
echo Current directory: %CD%
echo.

if not exist "libs" (
    echo WARNING: libs folder not found!
    echo Creating libs folder...
    mkdir libs
    echo.
    echo You need Unity DLLs from your Gorilla Tag installation.
    echo Use option 5 to extract Unity DLLs automatically.
    echo.
    set /p CONTINUE="Continue anyway? BepInEx 6 will be downloaded from NuGet. (Y/N): "
    if /i not "%CONTINUE%"=="Y" (
        goto MENU
    )
    echo.
) else (
    echo Found libs folder at: %CD%\libs
    echo.
)

REM Check for Unity dependencies (required for game-specific references)
set MISSING_UNITY=0

if not exist "libs\UnityEngine.dll" (
    echo [MISSING] UnityEngine.dll
    set MISSING_UNITY=1
) else (
    echo [OK] UnityEngine.dll
)

if not exist "libs\UnityEngine.CoreModule.dll" (
    echo [MISSING] UnityEngine.CoreModule.dll
    set MISSING_UNITY=1
) else (
    echo [OK] UnityEngine.CoreModule.dll
)

if not exist "libs\UnityEngine.IMGUIModule.dll" (
    echo [MISSING] UnityEngine.IMGUIModule.dll
    set MISSING_UNITY=1
) else (
    echo [OK] UnityEngine.IMGUIModule.dll
)

if not exist "libs\UnityEngine.InputLegacyModule.dll" (
    echo [MISSING] UnityEngine.InputLegacyModule.dll
    set MISSING_UNITY=1
) else (
    echo [OK] UnityEngine.InputLegacyModule.dll
)

echo.

if %MISSING_UNITY% EQU 1 (
    echo ========================================
    echo WARNING: Missing Unity DLLs!
    echo ========================================
    echo.
    echo Unity DLLs are required for Gorilla Tag specific references.
    echo Use option 5 to extract Unity DLLs from Gorilla Tag.
    echo.
    set /p CONTINUE="Continue build anyway? (Y/N): "

    if /i not "%CONTINUE%"=="Y" (
        goto MENU
    )
    echo.
) else (
    echo All Unity DLLs found!
    echo.
)

echo NOTE: Using BepInEx 6 - BepInEx and Harmony will be downloaded from NuGet automatically.
echo.

REM Build the project using dotnet build
echo Building project with dotnet build...
echo.
echo Running: dotnet build GTagSpeedMod\GTagSpeedMod.csproj -c Release
echo.

dotnet build GTagSpeedMod\GTagSpeedMod.csproj -c Release --verbosity minimal /flp:logfile=build.log;verbosity=diagnostic

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
    echo Detailed build log saved to: build.log
    echo.
) else (
    echo.
    echo ========================================
    echo BUILD FAILED!
    echo ========================================
    echo Check the error messages above
    echo.
    echo If you see errors about missing Unity DLLs, use option 5 to extract them.
    echo If you see .NET SDK errors, make sure .NET SDK is properly installed.
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
