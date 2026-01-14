# Unity DLL Extraction Script
# Extracts required Unity DLLs from Gorilla Tag installation

$ErrorActionPreference = "Stop"

$LibsDir = ".\libs"

Write-Host "=========================================" -ForegroundColor Green
Write-Host "Unity DLL Extraction Script" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

# Create libs directory if it doesn't exist
if (-not (Test-Path $LibsDir)) {
    Write-Host "Creating libs directory..."
    New-Item -ItemType Directory -Path $LibsDir -Force | Out-Null
}

# Common Steam library locations
$SteamPaths = @(
    "C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag",
    "C:\Program Files\Steam\steamapps\common\Gorilla Tag",
    "D:\SteamLibrary\steamapps\common\Gorilla Tag",
    "E:\SteamLibrary\steamapps\common\Gorilla Tag",
    "F:\SteamLibrary\steamapps\common\Gorilla Tag"
)

# Ask user for Gorilla Tag path
Write-Host "Searching for Gorilla Tag installation..." -ForegroundColor Yellow
Write-Host ""

$GorillaTagPath = $null

# Check common locations
foreach ($path in $SteamPaths) {
    if (Test-Path $path) {
        Write-Host "Found Gorilla Tag at: $path" -ForegroundColor Green
        $GorillaTagPath = $path
        break
    }
}

if (-not $GorillaTagPath) {
    Write-Host "Could not find Gorilla Tag in common locations." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please enter the path to your Gorilla Tag installation:"
    Write-Host "(Usually: C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag)"
    $GorillaTagPath = Read-Host "Path"

    if (-not (Test-Path $GorillaTagPath)) {
        Write-Host ""
        Write-Host "ERROR: Path does not exist: $GorillaTagPath" -ForegroundColor Red
        Write-Host ""
        pause
        exit 1
    }
}

# Find Managed folder
$ManagedPath = Join-Path $GorillaTagPath "Gorilla Tag_Data\Managed"

if (-not (Test-Path $ManagedPath)) {
    Write-Host ""
    Write-Host "ERROR: Could not find Managed folder at:" -ForegroundColor Red
    Write-Host $ManagedPath
    Write-Host ""
    Write-Host "Please verify your Gorilla Tag installation path." -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 1
}

Write-Host ""
Write-Host "Found Managed folder at: $ManagedPath" -ForegroundColor Green
Write-Host ""
Write-Host "Extracting Unity DLLs..." -ForegroundColor Yellow
Write-Host ""

# List of required Unity DLLs
$RequiredDlls = @(
    "UnityEngine.dll",
    "UnityEngine.CoreModule.dll",
    "UnityEngine.IMGUIModule.dll",
    "UnityEngine.InputLegacyModule.dll",
    "UnityEngine.UI.dll",
    "Assembly-CSharp.dll"
)

$CopiedCount = 0
$SkippedCount = 0
$MissingCount = 0

foreach ($dll in $RequiredDlls) {
    $sourcePath = Join-Path $ManagedPath $dll
    $destPath = Join-Path $LibsDir $dll

    if (Test-Path $sourcePath) {
        if (Test-Path $destPath) {
            Write-Host "  [SKIP] $dll (already exists)" -ForegroundColor Yellow
            $SkippedCount++
        } else {
            Copy-Item $sourcePath -Destination $destPath -Force
            Write-Host "  [OK] $dll" -ForegroundColor Green
            $CopiedCount++
        }
    } else {
        Write-Host "  [MISSING] $dll (not found in Gorilla Tag)" -ForegroundColor Red
        $MissingCount++
    }
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "Extraction Summary" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host "Copied: $CopiedCount" -ForegroundColor Green
Write-Host "Skipped (already exist): $SkippedCount" -ForegroundColor Yellow
Write-Host "Missing: $MissingCount" -ForegroundColor Red
Write-Host ""

if ($MissingCount -gt 0) {
    Write-Host "Note: Some DLLs were not found. This may be normal if your Unity version differs." -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "Unity DLLs are now in: $LibsDir" -ForegroundColor Green
Write-Host ""
Write-Host "You can now build your mod using Option 2 in build.bat!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
