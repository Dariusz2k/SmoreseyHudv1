@echo off
echo ========================================
echo GTag Mod Menu - Quick Rebuild
echo ========================================
echo.

REM Default game path - EDIT THIS if your path is different
set GAME_PATH=C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag

echo Cleaning old build...
if exist "GTagSpeedMod\bin\Release\GTagSpeedMod.dll" del "GTagSpeedMod\bin\Release\GTagSpeedMod.dll"

echo.
echo Building mod with MSBuild...
echo.

REM Try to find MSBuild automatically
set MSBUILD=
for %%i in (
    "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
    "C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe"
    "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe"
    "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe"
    "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe"
) do (
    if exist %%i (
        set MSBUILD=%%i
        goto :found_msbuild
    )
)

REM Try using msbuild from PATH
where msbuild >nul 2>&1
if %errorlevel%==0 (
    set MSBUILD=msbuild
    goto :found_msbuild
)

echo ERROR: Could not find MSBuild!
echo.
echo Please run this from a "Developer Command Prompt for VS"
echo Or install Visual Studio with C# support.
echo.
pause
exit /b 1

:found_msbuild
echo Found MSBuild: %MSBUILD%
echo.

cd GTagSpeedMod
"%MSBUILD%" GTagSpeedMod.csproj /p:Configuration=Release /v:minimal /nologo

if %errorlevel% neq 0 (
    echo.
    echo *** BUILD FAILED ***
    echo Check errors above.
    cd ..
    pause
    exit /b 1
)

cd ..

echo.
echo ========================================
echo BUILD SUCCESS!
echo ========================================
echo.

if not exist "GTagSpeedMod\bin\Release\GTagSpeedMod.dll" (
    echo ERROR: DLL not found after build!
    pause
    exit /b 1
)

echo DLL Location: GTagSpeedMod\bin\Release\GTagSpeedMod.dll
echo.

REM Check if game exists
if not exist "%GAME_PATH%" (
    echo WARNING: Game path not found: %GAME_PATH%
    echo.
    echo Please edit REBUILD-NOW.bat and set the correct path.
    echo Or manually copy the DLL to:
    echo   YourGamePath\BepInEx\plugins\GTagSpeedMod.dll
    echo.
    pause
    exit /b 1
)

if not exist "%GAME_PATH%\BepInEx\plugins" (
    echo ERROR: BepInEx\plugins folder not found!
    echo Make sure BepInEx is installed in: %GAME_PATH%
    echo.
    pause
    exit /b 1
)

echo Deploying to: %GAME_PATH%\BepInEx\plugins\
echo.

copy /Y "GTagSpeedMod\bin\Release\GTagSpeedMod.dll" "%GAME_PATH%\BepInEx\plugins\" >nul

if %errorlevel% neq 0 (
    echo ERROR: Copy failed! Try running as Administrator.
    pause
    exit /b 1
)

echo.
echo ========================================
echo DEPLOYMENT COMPLETE!
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
echo Look for these messages in the log:
echo   [Info] [Update] Update() is being called
echo   [Info] [OnGUI] First OnGUI call
echo   [Info] [Input] === Input Debug === (every 5 seconds)
echo.
echo If menu doesn't show, check INPUT_TROUBLESHOOTING.md
echo.
pause
