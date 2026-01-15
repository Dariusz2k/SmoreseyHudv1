# BepInEx Setup Script for Windows
# Installs required BepInEx development assemblies for mod development

$ErrorActionPreference = "Stop"

$LibsDir = ".\libs"
$FixScript = ".\fix-bepinex-dev-dlls.ps1"
$TemplateSource = "https://nuget.bepinex.dev/v3/index.json"
$TemplatePackage = "BepInEx.Templates::2.0.0-be.4"

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

Write-Host ""
Write-Host "Install BepInEx plugin templates? (dotnet new install)" -ForegroundColor Yellow
Write-Host "This is required for creating new plugin projects." -ForegroundColor Yellow
Write-Host ""
set /p INSTALL_TEMPLATES="Install templates now? (Y/N): "
if /i "$INSTALL_TEMPLATES" -eq "Y" {
    Write-Host ""
    Write-Host "Installing templates..." -ForegroundColor Yellow
    dotnet new install $TemplatePackage --nuget-source $TemplateSource
}

Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
