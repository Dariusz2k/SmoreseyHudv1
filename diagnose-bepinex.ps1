# BepInEx Installation Diagnostic Script
# Run this to check if BepInEx is properly installed

param(
    [string]$GamePath = "C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "BepInEx Installation Diagnostic" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Colors for output
$pass = "Green"
$fail = "Red"
$warn = "Yellow"
$info = "Cyan"

$errors = 0
$warnings = 0

# Function to check file/folder
function Test-Item {
    param(
        [string]$Path,
        [string]$Name,
        [string]$Type = "File"
    )

    Write-Host "Checking $Name..." -NoNewline

    if (Test-Path $Path) {
        Write-Host " [OK]" -ForegroundColor $pass
        return $true
    } else {
        Write-Host " [MISSING]" -ForegroundColor $fail
        Write-Host "  Expected at: $Path" -ForegroundColor $warn
        return $false
    }
}

# Check game folder exists
Write-Host "Game Folder: $GamePath" -ForegroundColor $info
Write-Host ""

if (-not (Test-Path $GamePath)) {
    Write-Host "ERROR: Gorilla Tag folder not found!" -ForegroundColor $fail
    Write-Host "Please specify the correct path with -GamePath parameter" -ForegroundColor $warn
    Write-Host "Example: .\diagnose-bepinex.ps1 -GamePath 'D:\Steam\steamapps\common\Gorilla Tag'" -ForegroundColor $warn
    exit 1
}

# Check critical BepInEx files
Write-Host "Checking BepInEx Installation..." -ForegroundColor $info
Write-Host ""

$checks = @{
    "winhttp.dll (BepInEx Loader)" = "$GamePath\winhttp.dll"
    "doorstop_config.ini" = "$GamePath\doorstop_config.ini"
    "BepInEx folder" = "$GamePath\BepInEx"
    "BepInEx/core folder" = "$GamePath\BepInEx\core"
    "BepInEx/plugins folder" = "$GamePath\BepInEx\plugins"
    "BepInEx/config folder" = "$GamePath\BepInEx\config"
}

foreach ($item in $checks.GetEnumerator()) {
    if (-not (Test-Item -Path $item.Value -Name $item.Key)) {
        $errors++
    }
}

Write-Host ""

# Check for BepInEx config
$configPath = "$GamePath\BepInEx\config\BepInEx.cfg"
Write-Host "Checking BepInEx Configuration..." -ForegroundColor $info
Write-Host ""

if (Test-Path $configPath) {
    Write-Host "BepInEx.cfg found [OK]" -ForegroundColor $pass

    $config = Get-Content $configPath -Raw
    if ($config -match '\[Logging\.Console\][\s\S]*?Enabled\s*=\s*true') {
        Write-Host "  Console logging enabled [OK]" -ForegroundColor $pass
    } elseif ($config -match '\[Logging\.Console\][\s\S]*?Enabled\s*=\s*false') {
        Write-Host "  Console logging disabled [WARNING]" -ForegroundColor $warn
        Write-Host "  You won't see the BepInEx console window" -ForegroundColor $warn
        $warnings++
    }
} else {
    Write-Host "BepInEx.cfg not found [INFO]" -ForegroundColor $warn
    Write-Host "  This is normal if you haven't run the game with BepInEx yet" -ForegroundColor $warn
    Write-Host "  Launch the game once to generate config files" -ForegroundColor $warn
    $warnings++
}

Write-Host ""

# Check for BepInEx log
Write-Host "Checking BepInEx Logs..." -ForegroundColor $info
Write-Host ""

$logPaths = @(
    "$GamePath\BepInEx\LogOutput.log",
    "$GamePath\BepInEx\logs\LogOutput.log"
)

$logFound = $false
foreach ($logPath in $logPaths) {
    if (Test-Path $logPath) {
        $logFound = $true
        Write-Host "Log file found: $logPath [OK]" -ForegroundColor $pass

        # Check log content
        $logContent = Get-Content $logPath -Raw

        if ($logContent -match "BepInEx \d+\.\d+") {
            Write-Host "  BepInEx initialized successfully [OK]" -ForegroundColor $pass

            if ($logContent -match "Loading \[GTag Mod Menu") {
                Write-Host "  GTag Mod Menu loaded [OK]" -ForegroundColor $pass
            } else {
                Write-Host "  GTag Mod Menu NOT found in log [WARNING]" -ForegroundColor $warn
                Write-Host "  Your mod may not be installed in plugins folder" -ForegroundColor $warn
                $warnings++
            }
        } else {
            Write-Host "  No BepInEx initialization found [ERROR]" -ForegroundColor $fail
            Write-Host "  BepInEx may have crashed or not loaded" -ForegroundColor $fail
            $errors++
        }

        # Show last few lines
        Write-Host ""
        Write-Host "  Last 10 lines of log:" -ForegroundColor $info
        $lastLines = Get-Content $logPath -Tail 10
        foreach ($line in $lastLines) {
            Write-Host "    $line" -ForegroundColor Gray
        }

        break
    }
}

if (-not $logFound) {
    Write-Host "No log files found [INFO]" -ForegroundColor $warn
    Write-Host "  This means BepInEx has never run" -ForegroundColor $warn
    Write-Host "  Launch the game once to generate logs" -ForegroundColor $warn
    $warnings++
}

Write-Host ""

# Check for your mod
Write-Host "Checking Your Mod..." -ForegroundColor $info
Write-Host ""

$modPath = "$GamePath\BepInEx\plugins\GTagSpeedMod.dll"
if (Test-Path $modPath) {
    Write-Host "GTagSpeedMod.dll found [OK]" -ForegroundColor $pass

    $modFile = Get-Item $modPath
    Write-Host "  Size: $($modFile.Length) bytes" -ForegroundColor $info
    Write-Host "  Modified: $($modFile.LastWriteTime)" -ForegroundColor $info
} else {
    Write-Host "GTagSpeedMod.dll not found [WARNING]" -ForegroundColor $warn
    Write-Host "  Expected at: $modPath" -ForegroundColor $warn
    Write-Host "  You need to build and copy your mod to this location" -ForegroundColor $warn
    $warnings++
}

Write-Host ""

# Check for other mods
Write-Host "Checking Other Mods..." -ForegroundColor $info
Write-Host ""

$pluginsPath = "$GamePath\BepInEx\plugins"
if (Test-Path $pluginsPath) {
    $otherMods = Get-ChildItem $pluginsPath -Filter "*.dll" | Where-Object { $_.Name -ne "GTagSpeedMod.dll" }

    if ($otherMods.Count -gt 0) {
        Write-Host "Found $($otherMods.Count) other mod(s):" -ForegroundColor $info
        foreach ($mod in $otherMods) {
            Write-Host "  - $($mod.Name)" -ForegroundColor Gray
        }
    } else {
        Write-Host "No other mods found" -ForegroundColor $info
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($errors -eq 0 -and $warnings -eq 0) {
    Write-Host "All checks passed! BepInEx should be working." -ForegroundColor $pass
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor $info
    Write-Host "1. Launch Gorilla Tag" -ForegroundColor $info
    Write-Host "2. Watch for the BepInEx console window" -ForegroundColor $info
    Write-Host "3. Check the log file after the game loads" -ForegroundColor $info
    Write-Host "4. Press F1 or Y in-game to toggle the menu" -ForegroundColor $info
} elseif ($errors -eq 0) {
    Write-Host "BepInEx appears installed but there are warnings:" -ForegroundColor $warn
    Write-Host "Errors: $errors" -ForegroundColor $fail
    Write-Host "Warnings: $warnings" -ForegroundColor $warn
    Write-Host ""
    Write-Host "Review the warnings above and try launching the game." -ForegroundColor $info
} else {
    Write-Host "Installation has problems:" -ForegroundColor $fail
    Write-Host "Errors: $errors" -ForegroundColor $fail
    Write-Host "Warnings: $warnings" -ForegroundColor $warn
    Write-Host ""
    Write-Host "REQUIRED ACTIONS:" -ForegroundColor $fail
    Write-Host ""

    if (-not (Test-Path "$GamePath\winhttp.dll")) {
        Write-Host "1. BepInEx is NOT installed!" -ForegroundColor $fail
        Write-Host "   Download BepInEx 5.4.22 x64 from:" -ForegroundColor $warn
        Write-Host "   https://github.com/BepInEx/BepInEx/releases" -ForegroundColor $warn
        Write-Host "   Extract to: $GamePath" -ForegroundColor $warn
        Write-Host ""
    }

    if (-not (Test-Path $modPath)) {
        Write-Host "2. Your mod needs to be built and deployed" -ForegroundColor $fail
        Write-Host "   Build command: msbuild GTagSpeedMod.csproj /p:Configuration=Release" -ForegroundColor $warn
        Write-Host "   Then copy GTagSpeedMod.dll to: $GamePath\BepInEx\plugins\" -ForegroundColor $warn
        Write-Host ""
    }
}

Write-Host ""
Write-Host "For detailed troubleshooting, see:" -ForegroundColor $info
Write-Host "  - BEPINEX_DIAGNOSTIC.md" -ForegroundColor $info
Write-Host "  - BEPINEX_SETUP.md" -ForegroundColor $info
Write-Host ""
