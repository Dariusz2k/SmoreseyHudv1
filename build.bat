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
echo 2. Build/Compile Mod (with auto-deploy option)
echo 3. Deploy Mod to BepInEx (no rebuild)
echo 4. Launch GTag Manager
echo 5. Install/Update BepInEx Dependencies
echo 6. Extract Unity DLLs from Gorilla Tag
echo 7. Exit
echo.
echo ========================================
echo.
set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" goto PULL_CODE
if "%choice%"=="2" goto BUILD_MOD
if "%choice%"=="3" goto DEPLOY_MOD
if "%choice%"=="4" goto LAUNCH_MANAGER
if "%choice%"=="5" goto INSTALL_DEPS
if "%choice%"=="6" goto EXTRACT_UNITY
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

set "PULL_BRANCH="

if exist "build.config" (
    for /f "usebackq tokens=1,* delims==" %%a in ("build.config") do (
        if /i "%%a"=="PULL_BRANCH" set "PULL_BRANCH=%%b"
    )
)

if not defined PULL_BRANCH (
    set "PULL_BRANCH=%CURRENT_BRANCH%"
)

echo Current branch: %CURRENT_BRANCH%
echo Configured pull branch: %PULL_BRANCH%
echo.
echo Fetching latest changes...
git fetch origin

echo.
echo Pulling changes for branch: %PULL_BRANCH%
git pull origin %PULL_BRANCH%

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
    echo TIP: Use option 4 to launch GTag Manager and setup BepInEx DLLs
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
        echo For BepInEx DLLs: Use option 5 to install BepInEx dependencies
        echo For Unity DLLs: Use option 6 to extract Unity DLLs from Gorilla Tag
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

    REM Check if we should auto-deploy
    set "GAME_PATH=C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag"

    REM Try to load custom path from config
    if exist "build.config" (
        for /f "usebackq tokens=1,* delims==" %%a in ("build.config") do (
            if /i "%%a"=="GAME_PATH" set "GAME_PATH=%%b"
        )
    )

    echo Would you like to deploy to BepInEx plugins folder?
    echo Current game path: %GAME_PATH%
    echo.
    set /p DEPLOY_MOD="Deploy mod now? (Y/N): "

    if /i "%DEPLOY_MOD%"=="Y" (
        echo.
        echo Checking game installation...

        if not exist "%GAME_PATH%" (
            echo ERROR: Game path not found: %GAME_PATH%
            echo.
            echo To set a custom path, create a file named "build.config" with:
            echo GAME_PATH=C:\Your\Custom\Path\To\Gorilla Tag
            echo.
            pause
            goto MENU
        )

        if not exist "%GAME_PATH%\BepInEx\plugins" (
            echo ERROR: BepInEx\plugins folder not found!
            echo Make sure BepInEx is installed at: %GAME_PATH%
            echo.
            pause
            goto MENU
        )

        echo Deploying to: %GAME_PATH%\BepInEx\plugins\
        copy /Y "GTagSpeedMod\bin\Release\GTagSpeedMod.dll" "%GAME_PATH%\BepInEx\plugins\" >nul

        if %ERRORLEVEL% EQU 0 (
            echo.
            echo ========================================
            echo DEPLOYMENT SUCCESSFUL!
            echo ========================================
            echo.
            echo Mod installed to: %GAME_PATH%\BepInEx\plugins\GTagSpeedMod.dll
            echo.
            echo Next steps:
            echo 1. Launch Gorilla Tag
            echo 2. Wait for game to fully load
            echo 3. Press F1 on keyboard (or Y on controller)
            echo 4. Check logs: %GAME_PATH%\BepInEx\LogOutput.log
            echo.
            echo Look for these messages:
            echo   [Info] [Update] Update() is being called
            echo   [Info] [OnGUI] First OnGUI call
            echo   [Info] [Input] === Input Debug === (every 5 seconds)
            echo.
        ) else (
            echo.
            echo ERROR: Failed to copy DLL!
            echo Try running as Administrator.
            echo.
        )
    ) else (
        echo.
        echo Skipping deployment.
        echo.
        echo To deploy manually, copy:
        echo   FROM: GTagSpeedMod\bin\Release\GTagSpeedMod.dll
        echo   TO:   %GAME_PATH%\BepInEx\plugins\
        echo.
    )

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
REM OPTION 3: Deploy Mod to BepInEx
REM ========================================
:DEPLOY_MOD
cls
echo ========================================
echo Deploy Mod to BepInEx Plugins
echo ========================================
echo.

REM Check if DLL exists
if not exist "GTagSpeedMod\bin\Release\GTagSpeedMod.dll" (
    echo ERROR: Mod DLL not found!
    echo Expected location: GTagSpeedMod\bin\Release\GTagSpeedMod.dll
    echo.
    echo You need to build the mod first (Option 2).
    echo.
    pause
    goto MENU
)

echo Found mod DLL: GTagSpeedMod\bin\Release\GTagSpeedMod.dll
echo.

REM Get game path
set "GAME_PATH=C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag"

REM Try to load custom path from config
if exist "build.config" (
    for /f "usebackq tokens=1,* delims==" %%a in ("build.config") do (
        if /i "%%a"=="GAME_PATH" set "GAME_PATH=%%b"
    )
)

echo Target game path: %GAME_PATH%
echo.

REM Validate game path
if not exist "%GAME_PATH%" (
    echo ERROR: Game path not found!
    echo.
    echo Current path: %GAME_PATH%
    echo.
    echo To set a custom path, create a file named "build.config" with:
    echo GAME_PATH=C:\Your\Custom\Path\To\Gorilla Tag
    echo.
    pause
    goto MENU
)

if not exist "%GAME_PATH%\BepInEx" (
    echo ERROR: BepInEx folder not found!
    echo Make sure BepInEx is installed at: %GAME_PATH%
    echo.
    echo See BEPINEX_SETUP.md for installation instructions.
    echo.
    pause
    goto MENU
)

if not exist "%GAME_PATH%\BepInEx\plugins" (
    echo Creating plugins folder...
    mkdir "%GAME_PATH%\BepInEx\plugins"
)

echo Deploying mod...
copy /Y "GTagSpeedMod\bin\Release\GTagSpeedMod.dll" "%GAME_PATH%\BepInEx\plugins\" >nul

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo DEPLOYMENT SUCCESSFUL!
    echo ========================================
    echo.
    echo Mod installed to:
    echo %GAME_PATH%\BepInEx\plugins\GTagSpeedMod.dll
    echo.
    echo Next steps:
    echo 1. Launch Gorilla Tag
    echo 2. Wait for game to fully load
    echo 3. Press F1 on keyboard (or Y on controller)
    echo 4. Check logs at: %GAME_PATH%\BepInEx\LogOutput.log
    echo.
    echo Expected log messages:
    echo   [Info :GTag Mod Menu] [Update] Update() is being called
    echo   [Info :GTag Mod Menu] [OnGUI] First OnGUI call
    echo   [Info :GTag Mod Menu] [Input] === Input Debug ===
    echo.
    echo For troubleshooting, see:
    echo   - INPUT_TROUBLESHOOTING.md
    echo   - QUICK-START.md
    echo.
) else (
    echo.
    echo ========================================
    echo DEPLOYMENT FAILED!
    echo ========================================
    echo.
    echo Could not copy DLL to plugins folder.
    echo.
    echo Possible solutions:
    echo 1. Run this script as Administrator
    echo 2. Make sure Gorilla Tag is not running
    echo 3. Check file permissions
    echo.
)

pause
goto MENU

REM ========================================
REM OPTION 4: Launch GTag Manager
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
REM OPTION 5: Install/Update BepInEx Dependencies
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
REM OPTION 6: Extract Unity DLLs
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
