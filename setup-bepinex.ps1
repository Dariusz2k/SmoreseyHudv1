# BepInEx Setup Script for Windows
# Installs BepInEx plugin templates for mod development

$ErrorActionPreference = "Stop"

$TemplateSource = "https://nuget.bepinex.dev/v3/index.json"
$TemplatePackage = "BepInEx.Templates::2.0.0-be.4"

Write-Host "=========================================" -ForegroundColor Green
Write-Host "BepInEx Template Setup" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Installing BepInEx plugin templates..." -ForegroundColor Yellow
Write-Host "Command: dotnet new install $TemplatePackage --nuget-source $TemplateSource" -ForegroundColor Gray
Write-Host ""
dotnet new install $TemplatePackage --nuget-source $TemplateSource

Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
