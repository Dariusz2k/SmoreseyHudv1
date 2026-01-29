@echo off
REM Build and Deploy Script for GTag Mod Menu
REM This script builds the mod and copies it to your Gorilla Tag BepInEx folder

echo ========================================
echo GTag Mod Menu - Build and Deploy
echo ========================================
echo.

REM Set default game path (modify if yours is different)
set GAME_PATH=C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag

REM Check if custom path provided as argument
if not "%1"=="" set GAME_PATH=%~1

echo Game Path: %GAME_PATH%
echo.

REM Check if game path exists
if not exist "%GAME_PATH%" (
    echo ERROR: Gorilla Tag folder not found at: %GAME_PATH%
    echo.
    echo Please either:
    echo 1. Edit this script and set GAME_PATH to your actual game folder
    echo 2. Run with path as argument: build-and-deploy.bat "D:\Steam\steamapps\common\Gorilla Tag"
    echo.
    pause
    exit /b 1
)

REM Check if BepInEx is installed
if not exist "%GAME_PATH%\BepInEx" (
    echo ERROR: BepInEx folder not found!
    echo BepInEx must be installed first.
    echo.
    echo Download from: https://github.com/BepInEx/BepInEx/releases
    echo Extract to: %GAME_PATH%
    echo.
    pause
    exit /b 1
)

if not exist "%GAME_PATH%\BepInEx\plugins" (
    echo ERROR: BepInEx\plugins folder not found!
    echo BepInEx may not be properly installed.
    echo.
    pause
    exit /b 1
)

echo Step 1: Building mod...
echo.

REM Try to find MSBuild
set MSBUILD_PATH=

REM Check common Visual Studio locations
if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" (
    set MSBUILD_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe
) else if exist "C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe" (
    set MSBUILD_PATH=C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe
) else if exist "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe" (
    set MSBUILD_PATH=C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe
) else if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe" (
    set MSBUILD_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe
)

REM If not found, try using MSBuild from PATH
if "%MSBUILD_PATH%"=="" (
    where msbuild >nul 2>&1
    if %errorlevel%==0 (
        set MSBUILD_PATH=msbuild
    ) else (
        echo ERROR: MSBuild not found!
        echo.
        echo Please install Visual Studio or run this from a Developer Command Prompt.
        echo.
        pause
        exit /b 1
    )
)

echo Using MSBuild: %MSBUILD_PATH%
echo.

REM Build the project
cd GTagSpeedMod
"%MSBUILD_PATH%" GTagSpeedMod.csproj /p:Configuration=Release /v:minimal

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Build failed!
    echo Check the errors above for details.
    echo.
    cd ..
    pause
    exit /b 1
)

cd ..

echo.
echo ========================================
echo Build Successful!
echo ========================================
echo.

REM Check if DLL was created
if not exist "GTagSpeedMod\bin\Release\GTagSpeedMod.dll" (
    echo ERROR: GTagSpeedMod.dll was not created!
    echo Build may have failed silently.
    echo.
    pause
    exit /b 1
)

echo Step 2: Deploying to BepInEx plugins folder...
echo.

REM Copy the DLL
copy /Y "GTagSpeedMod\bin\Release\GTagSpeedMod.dll" "%GAME_PATH%\BepInEx\plugins\"

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Failed to copy DLL to plugins folder!
    echo You may need administrator privileges.
    echo.
    echo Try running this script as Administrator.
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo Deployment Complete!
echo ========================================
echo.
echo Mod deployed to: %GAME_PATH%\BepInEx\plugins\GTagSpeedMod.dll
echo.
echo Next steps:
echo 1. Launch Gorilla Tag
echo 2. Watch for BepInEx console window
echo 3. Check BepInEx\LogOutput.log for mod loading messages
echo 4. In-game, press F1 or Y to toggle menu
echo.
echo For troubleshooting, run: diagnose-bepinex.ps1
echo.
pause
