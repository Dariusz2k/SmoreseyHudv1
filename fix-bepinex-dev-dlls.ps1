# Fix BepInEx Development DLLs
# Downloads the correct BepInEx 5.4.x development DLLs for compilation

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "BepInEx Development DLL Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$libsPath = "libs"
$tempPath = "temp_bepinex"
$bepinexVersion = "5.4.23.2"
$releaseTag = "v$bepinexVersion"
$downloadUrl = $null

function Get-BepInExAssetInfo {
    param (
        [Parameter(Mandatory)]
        [string]$Tag
    )

    $releaseApiUrl = "https://api.github.com/repos/BepInEx/BepInEx/releases/tags/$Tag"
    try {
        $release = Invoke-RestMethod -Uri $releaseApiUrl -Headers @{ "User-Agent" = "SmoreseyHudv1"; "Accept" = "application/vnd.github+json" }
    } catch {
        return $null
    }

    $version = $Tag.TrimStart("v")
    $expectedAsset = "BepInEx_x64_$version.zip"
    $asset = $release.assets | Where-Object { $_.name -eq $expectedAsset } | Select-Object -First 1
    if (-not $asset) {
        return $null
    }

    return @{
        Version = $version
        Url = $asset.browser_download_url
    }
}

function Get-LatestBepInEx54AssetInfo {
    $releasesApiUrl = "https://api.github.com/repos/BepInEx/BepInEx/releases"
    try {
        $releases = Invoke-RestMethod -Uri $releasesApiUrl -Headers @{ "User-Agent" = "SmoreseyHudv1"; "Accept" = "application/vnd.github+json" }
    } catch {
        return $null
    }

    $release = $releases |
        Where-Object { $_.tag_name -match "^v5\.4\." } |
        Sort-Object -Property published_at -Descending |
        Select-Object -First 1

    if (-not $release) {
        return $null
    }

    $version = $release.tag_name.TrimStart("v")
    $expectedAsset = "BepInEx_x64_$version.zip"
    $asset = $release.assets | Where-Object { $_.name -eq $expectedAsset } | Select-Object -First 1
    if (-not $asset) {
        return $null
    }

    return @{
        Version = $version
        Url = $asset.browser_download_url
    }
}

$assetInfo = Get-BepInExAssetInfo -Tag $releaseTag
if (-not $assetInfo) {
    Write-Host "Preferred release $releaseTag not found. Searching for latest 5.4.x release..." -ForegroundColor Yellow
    $assetInfo = Get-LatestBepInEx54AssetInfo
}

if (-not $assetInfo) {
    Write-Host "ERROR: Could not locate a valid BepInEx 5.4.x release asset." -ForegroundColor Red
    Write-Host "Please download manually from the BepInEx releases page:" -ForegroundColor Yellow
    Write-Host "https://github.com/BepInEx/BepInEx/releases" -ForegroundColor Cyan
    Write-Host ""
    pause
    exit 1
}

$bepinexVersion = $assetInfo.Version
$downloadUrl = $assetInfo.Url

# Create libs folder if it doesn't exist
if (-not (Test-Path $libsPath)) {
    Write-Host "Creating libs folder..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $libsPath | Out-Null
}

# Create temp folder
if (Test-Path $tempPath) {
    Write-Host "Cleaning temp folder..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $tempPath
}
New-Item -ItemType Directory -Path $tempPath | Out-Null

Write-Host "Downloading BepInEx $bepinexVersion..." -ForegroundColor Yellow
Write-Host "URL: $downloadUrl" -ForegroundColor Gray
Write-Host ""

$zipPath = Join-Path $tempPath "BepInEx.zip"

try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -Headers @{ "User-Agent" = "SmoreseyHudv1" }
    Write-Host "Download complete!" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "ERROR: Failed to download BepInEx!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please download manually from:" -ForegroundColor Yellow
    Write-Host $downloadUrl -ForegroundColor Cyan
    Write-Host ""
    pause
    exit 1
}

Write-Host "Extracting BepInEx..." -ForegroundColor Yellow
try {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $tempPath)
    Write-Host "Extraction complete!" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "ERROR: Failed to extract BepInEx!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    pause
    exit 1
}

# Copy required DLLs from BepInEx\core
$corePath = Join-Path $tempPath "BepInEx\core"
if (-not (Test-Path $corePath)) {
    Write-Host "ERROR: BepInEx\core folder not found in extracted files!" -ForegroundColor Red
    Write-Host ""
    pause
    exit 1
}

Write-Host "Installing development DLLs to libs folder..." -ForegroundColor Yellow
Write-Host ""

$dlls = @(
    "BepInEx.dll",
    "0Harmony.dll",
    "Mono.Cecil.dll",
    "MonoMod.RuntimeDetour.dll",
    "MonoMod.Utils.dll"
)

$successCount = 0
foreach ($dll in $dlls) {
    $sourcePath = Join-Path $corePath $dll
    $destPath = Join-Path $libsPath $dll

    if (Test-Path $sourcePath) {
        Copy-Item -Path $sourcePath -Destination $destPath -Force
        Write-Host "[INSTALLED] $dll" -ForegroundColor Green

        # Verify the DLL
        $fileInfo = Get-Item $destPath
        Write-Host "  Size: $($fileInfo.Length) bytes" -ForegroundColor Gray
        Write-Host "  Modified: $($fileInfo.LastWriteTime)" -ForegroundColor Gray

        # For BepInEx.dll, verify it contains BaseUnityPlugin
        if ($dll -eq "BepInEx.dll") {
            try {
                $assembly = [System.Reflection.Assembly]::LoadFrom((Resolve-Path $destPath).Path)
                $baseUnityPlugin = $assembly.GetType("BepInEx.BaseUnityPlugin")
                if ($baseUnityPlugin) {
                    Write-Host "  [VERIFIED] Contains BepInEx.BaseUnityPlugin" -ForegroundColor Green
                } else {
                    Write-Host "  [WARNING] BaseUnityPlugin type not found!" -ForegroundColor Yellow
                }
            } catch {
                Write-Host "  [WARNING] Could not verify: $($_.Exception.Message)" -ForegroundColor Yellow
            }
        }
        Write-Host ""
        $successCount++
    } else {
        Write-Host "[MISSING] $dll (not found in source)" -ForegroundColor Red
        Write-Host ""
    }
}

# Clean up temp folder
Write-Host "Cleaning up temporary files..." -ForegroundColor Yellow
Remove-Item -Recurse -Force $tempPath
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installation Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Installed $successCount of $($dlls.Count) DLLs" -ForegroundColor Green
Write-Host ""
Write-Host "You can now build your project!" -ForegroundColor Yellow
Write-Host "Run build.bat and select Option 2 to build." -ForegroundColor Yellow
Write-Host ""
Write-Host "Note: These are DEVELOPMENT DLLs for compilation only." -ForegroundColor Cyan
Write-Host "You still need Unity DLLs from your Gorilla Tag installation." -ForegroundColor Cyan
Write-Host ""
pause
