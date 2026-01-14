# BepInEx Setup Script for Windows
# Downloads and extracts required BepInEx assemblies for mod development

$ErrorActionPreference = "Stop"

$LibsDir = ".\libs"
$BepInExVersion = "5.4.23.2"
$BepInExUrl = "https://github.com/BepInEx/BepInEx/releases/download/v$BepInExVersion/BepInEx_win_x64_$BepInExVersion.zip"
$TempDir = ".\temp_bepinex"
$TempZip = "$TempDir\bepinex.zip"

Write-Host "=========================================" -ForegroundColor Green
Write-Host "BepInEx Dependency Setup" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

# Create libs directory if it doesn't exist
if (-not (Test-Path $LibsDir)) {
    Write-Host "Creating libs directory..."
    New-Item -ItemType Directory -Path $LibsDir -Force | Out-Null
}

# Create temp directory
Write-Host "Creating temporary directory..."
if (Test-Path $TempDir) {
    Remove-Item -Path $TempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

try {
    # Download BepInEx
    Write-Host "Downloading BepInEx v$BepInExVersion..."
    Write-Host "URL: $BepInExUrl"

    # Use TLS 1.2 for GitHub
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("User-Agent", "PowerShell Script")
    $webClient.DownloadFile($BepInExUrl, $TempZip)

    Write-Host "Download completed: $('{0:N2}' -f ((Get-Item $TempZip).Length / 1MB)) MB"

    # Extract BepInEx
    Write-Host "Extracting BepInEx..."
    Expand-Archive -Path $TempZip -DestinationPath $TempDir -Force

    # Copy required DLLs
    Write-Host "Copying required assemblies to libs folder..."

    $copied = 0

    # Core BepInEx files from BepInEx\core folder
    # Note: BepInEx.Core.dll only exists in BepInEx 6.x, not in 5.x
    # In BepInEx 5.x, BaseUnityPlugin is in BepInEx.dll
    $coreFiles = @(
        "BepInEx\core\BepInEx.dll",
        "BepInEx\core\0Harmony.dll",
        "BepInEx\core\Mono.Cecil.dll",
        "BepInEx\core\MonoMod.RuntimeDetour.dll",
        "BepInEx\core\MonoMod.Utils.dll"
    )

    foreach ($file in $coreFiles) {
        $sourcePath = Join-Path $TempDir $file
        if (Test-Path $sourcePath) {
            $fileName = Split-Path $file -Leaf
            Copy-Item $sourcePath -Destination $LibsDir -Force
            Write-Host "  OK $fileName" -ForegroundColor Green
            $copied++
        }
    }

    if ($copied -eq 0) {
        Write-Host "ERROR: No BepInEx DLLs found in the expected locations!" -ForegroundColor Red
        Write-Host "Archive structure may have changed. Contents of temp folder:" -ForegroundColor Yellow
        Get-ChildItem -Path $TempDir -Recurse -Filter "*.dll" | ForEach-Object {
            Write-Host "  Found: $($_.FullName.Replace($TempDir, ''))" -ForegroundColor Yellow
        }
        throw "BepInEx DLLs not found"
    }

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "BepInEx setup completed successfully!" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "The following assemblies are now in $LibsDir :"
    Get-ChildItem -Path $LibsDir -Filter "*.dll" | ForEach-Object {
        Write-Host "  - $($_.Name)"
    }
    Write-Host ""
    Write-Host "Note: Unity DLLs should be extracted from your Gorilla Tag installation." -ForegroundColor Yellow
    Write-Host "You can use GTag Manager (option 3 in build.bat) for this." -ForegroundColor Yellow
    Write-Host ""
}
catch {
    Write-Host ""
    Write-Host "ERROR: Setup failed!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    exit 1
}
finally {
    # Clean up
    Write-Host "Cleaning up temporary files..."
    if (Test-Path $TempDir) {
        Remove-Item -Path $TempDir -Recurse -Force
    }
}

Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
