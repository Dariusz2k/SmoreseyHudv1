# BepInEx Setup Script for Windows
# Installs required BepInEx development assemblies for mod development

$ErrorActionPreference = "Stop"

$LibsDir = ".\libs"
$FixScript = ".\fix-bepinex-dev-dlls.ps1"

Write-Host "=========================================" -ForegroundColor Green
Write-Host "BepInEx Dependency Setup" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

if (-not (Test-Path $FixScript)) {
    Write-Host "ERROR: fix-bepinex-dev-dlls.ps1 not found." -ForegroundColor Red
    Write-Host "Please run it manually from the repository root." -ForegroundColor Yellow
    exit 1
}

Write-Host "Running development DLL installer..." -ForegroundColor Yellow
& $FixScript

Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
