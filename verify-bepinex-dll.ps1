# BepInEx DLL Verification Script
# Checks if BepInEx.dll contains the required types

$libsPath = "libs"
$bepinexDll = Join-Path $libsPath "BepInEx.dll"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "BepInEx DLL Verification Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if DLL exists
if (-not (Test-Path $bepinexDll)) {
    Write-Host "ERROR: BepInEx.dll not found at: $bepinexDll" -ForegroundColor Red
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host "Found: $bepinexDll" -ForegroundColor Green
Write-Host ""

# Get file info
$fileInfo = Get-Item $bepinexDll
Write-Host "File Size: $($fileInfo.Length) bytes"
Write-Host "Last Modified: $($fileInfo.LastWriteTime)"
Write-Host ""

# Load the assembly
Write-Host "Loading assembly..." -ForegroundColor Yellow
try {
    $assembly = [System.Reflection.Assembly]::LoadFrom((Resolve-Path $bepinexDll).Path)
    Write-Host "Assembly loaded successfully!" -ForegroundColor Green
    Write-Host ""

    # Get assembly version
    $version = $assembly.GetName().Version
    Write-Host "Assembly Version: $version" -ForegroundColor Cyan
    Write-Host ""

    # Check for BaseUnityPlugin
    Write-Host "Searching for BaseUnityPlugin..." -ForegroundColor Yellow
    $baseUnityPlugin = $assembly.GetTypes() | Where-Object { $_.Name -eq "BaseUnityPlugin" }

    if ($baseUnityPlugin) {
        Write-Host "SUCCESS: Found BaseUnityPlugin!" -ForegroundColor Green
        Write-Host "Full Name: $($baseUnityPlugin.FullName)" -ForegroundColor Cyan
        Write-Host "Namespace: $($baseUnityPlugin.Namespace)" -ForegroundColor Cyan
        Write-Host ""
    } else {
        Write-Host "ERROR: BaseUnityPlugin NOT FOUND!" -ForegroundColor Red
        Write-Host ""
        Write-Host "This DLL does not contain the required BepInEx.BaseUnityPlugin type." -ForegroundColor Red
        Write-Host "You may have the wrong version of BepInEx.dll" -ForegroundColor Yellow
        Write-Host ""
    }

    # List all public types
    Write-Host "Available Types in Assembly:" -ForegroundColor Cyan
    Write-Host "----------------------------" -ForegroundColor Cyan
    $publicTypes = $assembly.GetTypes() | Where-Object { $_.IsPublic } | Select-Object -First 20
    foreach ($type in $publicTypes) {
        Write-Host "  - $($type.FullName)" -ForegroundColor Gray
    }

    if ($assembly.GetTypes().Count -gt 20) {
        Write-Host "  ... and $($assembly.GetTypes().Count - 20) more types" -ForegroundColor Gray
    }

} catch {
    Write-Host "ERROR: Failed to load assembly!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "This could mean:" -ForegroundColor Yellow
    Write-Host "  1. The DLL is corrupted" -ForegroundColor Yellow
    Write-Host "  2. The DLL is missing dependencies" -ForegroundColor Yellow
    Write-Host "  3. The DLL is not a valid .NET assembly" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Verification Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Recommended Action:" -ForegroundColor Yellow
Write-Host "If BaseUnityPlugin was NOT found, download BepInEx 5.4.x from:" -ForegroundColor Yellow
Write-Host "https://github.com/BepInEx/BepInEx/releases" -ForegroundColor Cyan
Write-Host ""
Write-Host "Extract BepInEx.dll from:" -ForegroundColor Yellow
Write-Host "  BepInEx_x64_5.4.x.x\BepInEx\core\BepInEx.dll" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
