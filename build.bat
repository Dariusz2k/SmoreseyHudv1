@echo off
setlocal enabledelayedexpansion
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
echo 6. Fix BepInEx Development DLLs
echo 7. Exit
echo.
echo ========================================
echo.
set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" goto PULL_CODE
if "%choice%"=="2" goto BUILD_MOD
if "%choice%"=="3" goto LAUNCH_MANAGER
if "%choice%"=="4" goto INSTALL_DEPS
if "%choice%"=="5" goto EXTRACT_UNITY
if "%choice%"=="6" goto FIX_BEPINEX_DEVDLLS
if "%choice%"=="7" goto EXIT_SCRIPT
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
echo Select update method:
echo.
echo 1. Normal Pull (merge with current branch)
echo 2. Hard Reset (discard ALL local changes and overwrite)
echo 3. Select Different Branch
echo 4. Cancel
echo.
set /p PULL_CHOICE="Enter your choice (1-4): "

if "%PULL_CHOICE%"=="1" goto NORMAL_PULL
if "%PULL_CHOICE%"=="2" goto HARD_RESET
if "%PULL_CHOICE%"=="3" goto SELECT_BRANCH
if "%PULL_CHOICE%"=="4" goto MENU
echo Invalid choice!
timeout /t 2 >nul
goto PULL_CODE

:NORMAL_PULL
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

:HARD_RESET
echo.
echo WARNING: This will discard ALL local changes!
echo Your working directory will be reset to match the remote branch.
echo.
set /p CONFIRM="Are you sure you want to continue? (Y/N): "

if /i not "%CONFIRM%"=="Y" (
    echo.
    echo Operation cancelled.
    echo.
    pause
    goto MENU
)

echo.
echo Fetching latest changes from origin...
git fetch origin

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to fetch from remote!
    echo.
    pause
    goto MENU
)

echo.
echo Discarding all local changes...
git reset --hard origin/%CURRENT_BRANCH%

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to reset to remote branch!
    echo.
    pause
    goto MENU
)

echo.
echo Cleaning untracked files...
git clean -fd

echo.
echo ========================================
echo Repository synced successfully!
echo ========================================
echo.
echo Your working directory now matches: origin/%CURRENT_BRANCH%
echo All local changes have been discarded.
echo.
echo Reloading build menu with latest changes...
timeout /t 2 >nul
call "%~f0"
exit /b

:SELECT_BRANCH
echo.
echo Fetching branch list...
git fetch origin

echo.
echo Available remote branches:
git branch -r

echo.
set /p NEW_BRANCH="Enter branch name (e.g., main, claude/branch-name): "

if not defined NEW_BRANCH (
    echo.
    echo No branch specified.
    echo.
    pause
    goto MENU
)

echo.
echo Checking out branch: %NEW_BRANCH%
git checkout %NEW_BRANCH%

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to checkout branch!
    echo.
    pause
    goto MENU
)

echo.
echo Pulling latest changes...
git pull origin %NEW_BRANCH%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Branch switched successfully!
    echo ========================================
    echo.
    echo You are now on: %NEW_BRANCH%
    echo.
    echo Reloading build menu with latest changes...
    timeout /t 2 >nul
    call "%~f0"
    exit /b
) else (
    echo.
    echo ========================================
    echo Branch switch completed with warnings.
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
    powershell.exe -ExecutionPolicy Bypass -Command "try { $asm=[System.Reflection.Assembly]::LoadFrom((Resolve-Path 'libs\\BepInEx.dll').Path); if ($null -eq $asm.GetType('BepInEx.BaseUnityPlugin')) { exit 2 } } catch { exit 3 }"
    if errorlevel 3 (
        echo [ERROR] BepInEx.dll could not be loaded for verification.
        echo         Try running verify-bepinex-dll.ps1 for details.
        set MISSING_DEPS=1
    ) else if errorlevel 2 (
        echo [ERROR] BepInEx.BaseUnityPlugin not found in BepInEx.dll.
        echo         You need the 5.4.x DEVELOPMENT DLLs.
        echo.
        set /p FIX_DEVDLLS="Run fix-bepinex-dev-dlls.ps1 now? (Y/N): "
        if /i "%FIX_DEVDLLS%"=="Y" (
            echo.
            echo Running BepInEx development DLL installer...
            powershell.exe -ExecutionPolicy Bypass -File "%CD%\fix-bepinex-dev-dlls.ps1"
            echo.
            echo Re-checking dependencies...
            goto BUILD_MOD
        )
        set MISSING_DEPS=1
    )
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

if not exist "libs\UnityEngine.IMGUIModule.dll" (
    echo [MISSING] UnityEngine.IMGUIModule.dll
    set MISSING_DEPS=1
) else (
    echo [OK] UnityEngine.IMGUIModule.dll
)

if not exist "libs\UnityEngine.InputLegacyModule.dll" (
    echo [MISSING] UnityEngine.InputLegacyModule.dll
    set MISSING_DEPS=1
) else (
    echo [OK] UnityEngine.InputLegacyModule.dll
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
            echo Use option 5 to extract Unity DLLs automatically.
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
        echo For BepInEx DLLs: Use option 4 to install BepInEx dependencies
        echo For Unity DLLs: Use option 5 to extract Unity DLLs from Gorilla Tag
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

    REM Check if the error is related to BaseUnityPlugin
    findstr /C:"BaseUnityPlugin" build.log >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo ========================================
        echo DETECTED: BepInEx.dll Issue
        echo ========================================
        echo.
        echo The build failed because BepInEx.BaseUnityPlugin could not be found.
        echo This usually means you have the RUNTIME version of BepInEx.dll
        echo instead of the DEVELOPMENT version needed for compilation.
        echo.
        echo Would you like to automatically download the correct BepInEx DLLs?
        echo.
        set /p FIX_BEPINEX="Download and install BepInEx dev DLLs? (Y/N): "

        if /i "%FIX_BEPINEX%"=="Y" (
            echo.
            echo Running BepInEx development DLL installer...
            echo.
            powershell.exe -ExecutionPolicy Bypass -File "%CD%\fix-bepinex-dev-dlls.ps1"

            if %ERRORLEVEL% EQU 0 (
                echo.
                echo BepInEx development DLLs installed successfully!
                echo.
                set /p RETRY_BUILD="Try building again? (Y/N): "
                if /i "!RETRY_BUILD!"=="Y" (
                    goto BUILD_MOD
                )
            )
        )
    )
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
REM OPTION 6: Fix BepInEx Development DLLs
REM ========================================
:FIX_BEPINEX_DEVDLLS
cls
echo ========================================
echo Fix BepInEx Development DLLs
echo ========================================
echo.

if not exist "fix-bepinex-dev-dlls.ps1" (
    echo ERROR: fix-bepinex-dev-dlls.ps1 not found!
    echo Expected location: %CD%\fix-bepinex-dev-dlls.ps1
    echo.
    pause
    goto MENU
)

echo This will download and install BepInEx 5.4.x DEVELOPMENT DLLs.
echo These are required for compiling mods, not for running the game.
echo.
echo The following DLLs will be downloaded and installed to libs folder:
echo   - BepInEx.dll (development version)
echo   - 0Harmony.dll
echo   - Mono.Cecil.dll
echo   - MonoMod.RuntimeDetour.dll
echo   - MonoMod.Utils.dll
echo.
echo Existing files will be overwritten.
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause >nul

echo.
echo Running BepInEx development DLL installer...
echo.
powershell.exe -ExecutionPolicy Bypass -File "%CD%\fix-bepinex-dev-dlls.ps1"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Installation completed successfully!
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
REM OPTION 7: Exit
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
