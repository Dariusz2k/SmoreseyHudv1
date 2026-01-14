# GTag Mod Manager - ULTIMATE Edition
# Handles BepInEx installation, DLL setup, and mod management with STYLE!

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem

$projectPath = $PSScriptRoot
if (-not $projectPath) { $projectPath = "D:\ProgrammingStuff\GTagMenu" }
$libsPath = Join-Path $projectPath "libs"
$tempPath = Join-Path $projectPath "temp"
$modDllPath = Join-Path $projectPath "GTagSpeedMod\bin\Release\GTagSpeedMod.dll"
$modName = "GTagSpeedMod.dll"

# Create the main form with STYLE
$form = New-Object System.Windows.Forms.Form
$form.Text = '*** GTag Mod Manager ULTIMATE ***'
$form.Size = New-Object System.Drawing.Size(750,700)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(20,20,30)

# ===============================================
# EPIC TITLE BANNER
# ===============================================
$bannerPanel = New-Object System.Windows.Forms.Panel
$bannerPanel.Location = New-Object System.Drawing.Point(0,0)
$bannerPanel.Size = New-Object System.Drawing.Size(750,100)
$bannerPanel.BackColor = [System.Drawing.Color]::FromArgb(138,43,226)  # Purple
$form.Controls.Add($bannerPanel)

# Title with gradient effect
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Location = New-Object System.Drawing.Point(10,15)
$titleLabel.Size = New-Object System.Drawing.Size(720,40)
$titleLabel.Text = '*** GTAG MOD MANAGER ULTIMATE ***'
$titleLabel.Font = New-Object System.Drawing.Font("Impact",24,[System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::White
$titleLabel.TextAlign = 'MiddleCenter'
$bannerPanel.Controls.Add($titleLabel)

# Subtitle
$subtitleLabel = New-Object System.Windows.Forms.Label
$subtitleLabel.Location = New-Object System.Drawing.Point(10,58)
$subtitleLabel.Size = New-Object System.Drawing.Size(720,30)
$subtitleLabel.Text = '>> Setup - Build - Deploy - Dominate <<'
$subtitleLabel.Font = New-Object System.Drawing.Font("Segoe UI",12,[System.Drawing.FontStyle]::Bold)
$subtitleLabel.ForeColor = [System.Drawing.Color]::FromArgb(255,215,0)  # Gold
$subtitleLabel.TextAlign = 'MiddleCenter'
$bannerPanel.Controls.Add($subtitleLabel)

# ===============================================
# STEP 1: Gorilla Tag Path
# ===============================================
$step1Panel = New-Object System.Windows.Forms.Panel
$step1Panel.Location = New-Object System.Drawing.Point(10,110)
$step1Panel.Size = New-Object System.Drawing.Size(715,100)
$step1Panel.BackColor = [System.Drawing.Color]::FromArgb(30,30,45)
$step1Panel.BorderStyle = 'FixedSingle'
$form.Controls.Add($step1Panel)

$step1Label = New-Object System.Windows.Forms.Label
$step1Label.Location = New-Object System.Drawing.Point(10,5)
$step1Label.Size = New-Object System.Drawing.Size(690,30)
$step1Label.Text = '☐ [STEP 1] Locate Gorilla Tag'
$step1Label.Font = New-Object System.Drawing.Font("Segoe UI",12,[System.Drawing.FontStyle]::Bold)
$step1Label.ForeColor = [System.Drawing.Color]::FromArgb(0,255,255)  # Cyan
$step1Panel.Controls.Add($step1Label)

$gtagTextBox = New-Object System.Windows.Forms.TextBox
$gtagTextBox.Location = New-Object System.Drawing.Point(10,40)
$gtagTextBox.Size = New-Object System.Drawing.Size(590,25)
$gtagTextBox.Font = New-Object System.Drawing.Font("Consolas",9)
$gtagTextBox.BackColor = [System.Drawing.Color]::FromArgb(50,50,70)
$gtagTextBox.ForeColor = [System.Drawing.Color]::White
$gtagTextBox.Text = "C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag"
$step1Panel.Controls.Add($gtagTextBox)

$browseGtagButton = New-Object System.Windows.Forms.Button
$browseGtagButton.Location = New-Object System.Drawing.Point(610,38)
$browseGtagButton.Size = New-Object System.Drawing.Size(90,28)
$browseGtagButton.Text = ' Browse'
$browseGtagButton.Font = New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)
$browseGtagButton.BackColor = [System.Drawing.Color]::FromArgb(70,130,180)
$browseGtagButton.ForeColor = [System.Drawing.Color]::White
$browseGtagButton.FlatStyle = 'Flat'
$browseGtagButton.Cursor = 'Hand'
$browseGtagButton.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select your Gorilla Tag installation folder"
    $folderBrowser.SelectedPath = $gtagTextBox.Text
    if ($folderBrowser.ShowDialog() -eq 'OK') {
        $gtagTextBox.Text = $folderBrowser.SelectedPath
        CheckAllStatus
    }
})
$step1Panel.Controls.Add($browseGtagButton)

# BepInEx Status
$bepinexStatusLabel = New-Object System.Windows.Forms.Label
$bepinexStatusLabel.Location = New-Object System.Drawing.Point(10,70)
$bepinexStatusLabel.Size = New-Object System.Drawing.Size(690,22)
$bepinexStatusLabel.Text = '[ ] BepInEx: Not Checked'
$bepinexStatusLabel.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
$bepinexStatusLabel.ForeColor = [System.Drawing.Color]::Gray
$step1Panel.Controls.Add($bepinexStatusLabel)

# ===============================================
# STEP 2: BepInEx Management
# ===============================================
$step2Panel = New-Object System.Windows.Forms.Panel
$step2Panel.Location = New-Object System.Drawing.Point(10,220)
$step2Panel.Size = New-Object System.Drawing.Size(715,110)
$step2Panel.BackColor = [System.Drawing.Color]::FromArgb(30,30,45)
$step2Panel.BorderStyle = 'FixedSingle'
$form.Controls.Add($step2Panel)

$step2Label = New-Object System.Windows.Forms.Label
$step2Label.Location = New-Object System.Drawing.Point(10,5)
$step2Label.Size = New-Object System.Drawing.Size(690,30)
$step2Label.Text = '☐ [STEP 2] BepInEx Setup'
$step2Label.Font = New-Object System.Drawing.Font("Segoe UI",12,[System.Drawing.FontStyle]::Bold)
$step2Label.ForeColor = [System.Drawing.Color]::FromArgb(255,165,0)  # Orange
$step2Panel.Controls.Add($step2Label)

$bepinexInfoLabel = New-Object System.Windows.Forms.Label
$bepinexInfoLabel.Location = New-Object System.Drawing.Point(10,35)
$bepinexInfoLabel.Size = New-Object System.Drawing.Size(690,25)
$bepinexInfoLabel.Text = 'BepInEx is the mod loader required for Gorilla Tag mods'
$bepinexInfoLabel.Font = New-Object System.Drawing.Font("Segoe UI",9)
$bepinexInfoLabel.ForeColor = [System.Drawing.Color]::LightGray
$step2Panel.Controls.Add($bepinexInfoLabel)

$downloadBepInExButton = New-Object System.Windows.Forms.Button
$downloadBepInExButton.Location = New-Object System.Drawing.Point(10,65)
$downloadBepInExButton.Size = New-Object System.Drawing.Size(160,35)
$downloadBepInExButton.Text = 'Download BepInEx'
$downloadBepInExButton.Font = New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)
$downloadBepInExButton.BackColor = [System.Drawing.Color]::FromArgb(34,139,34)  # Forest Green
$downloadBepInExButton.ForeColor = [System.Drawing.Color]::White
$downloadBepInExButton.FlatStyle = 'Flat'
$downloadBepInExButton.Cursor = 'Hand'
$downloadBepInExButton.Add_Click({ DownloadBepInEx })
$step2Panel.Controls.Add($downloadBepInExButton)

$checkBepInExButton = New-Object System.Windows.Forms.Button
$checkBepInExButton.Location = New-Object System.Drawing.Point(180,65)
$checkBepInExButton.Size = New-Object System.Drawing.Size(130,35)
$checkBepInExButton.Text = 'Check Status'
$checkBepInExButton.Font = New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)
$checkBepInExButton.BackColor = [System.Drawing.Color]::FromArgb(70,130,180)
$checkBepInExButton.ForeColor = [System.Drawing.Color]::White
$checkBepInExButton.FlatStyle = 'Flat'
$checkBepInExButton.Cursor = 'Hand'
$checkBepInExButton.Add_Click({ CheckAllStatus })
$step2Panel.Controls.Add($checkBepInExButton)

$copyDllsButton = New-Object System.Windows.Forms.Button
$copyDllsButton.Location = New-Object System.Drawing.Point(320,65)
$copyDllsButton.Size = New-Object System.Drawing.Size(180,35)
$copyDllsButton.Text = 'Copy Dev Libraries'
$copyDllsButton.Font = New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)
$copyDllsButton.BackColor = [System.Drawing.Color]::FromArgb(255,140,0)  # Dark Orange
$copyDllsButton.ForeColor = [System.Drawing.Color]::White
$copyDllsButton.FlatStyle = 'Flat'
$copyDllsButton.Cursor = 'Hand'
$copyDllsButton.Add_Click({ CopyDllFiles })
$step2Panel.Controls.Add($copyDllsButton)

$helpButton = New-Object System.Windows.Forms.Button
$helpButton.Location = New-Object System.Drawing.Point(510,65)
$helpButton.Size = New-Object System.Drawing.Size(100,35)
$helpButton.Text = 'Help'
$helpButton.Font = New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)
$helpButton.BackColor = [System.Drawing.Color]::FromArgb(128,0,128)  # Purple
$helpButton.ForeColor = [System.Drawing.Color]::White
$helpButton.FlatStyle = 'Flat'
$helpButton.Cursor = 'Hand'
$helpButton.Add_Click({ ShowManualInstructions })
$step2Panel.Controls.Add($helpButton)

# ===============================================
# STEP 3: MOD MANAGEMENT (NEW!)
# ===============================================
$step3Panel = New-Object System.Windows.Forms.Panel
$step3Panel.Location = New-Object System.Drawing.Point(10,340)
$step3Panel.Size = New-Object System.Drawing.Size(715,130)
$step3Panel.BackColor = [System.Drawing.Color]::FromArgb(30,30,45)
$step3Panel.BorderStyle = 'FixedSingle'
$form.Controls.Add($step3Panel)

$step3Label = New-Object System.Windows.Forms.Label
$step3Label.Location = New-Object System.Drawing.Point(10,5)
$step3Label.Size = New-Object System.Drawing.Size(690,30)
$step3Label.Text = '☐ [STEP 3] Mod Deployment'
$step3Label.Font = New-Object System.Drawing.Font("Segoe UI",12,[System.Drawing.FontStyle]::Bold)
$step3Label.ForeColor = [System.Drawing.Color]::FromArgb(50,205,50)  # Lime Green
$step3Panel.Controls.Add($step3Label)

# Mod Status Display
$modStatusLabel = New-Object System.Windows.Forms.Label
$modStatusLabel.Location = New-Object System.Drawing.Point(10,40)
$modStatusLabel.Size = New-Object System.Drawing.Size(690,30)
$modStatusLabel.Text = '[ ] Mod Status: Not Built Yet'
$modStatusLabel.Font = New-Object System.Drawing.Font("Segoe UI",11,[System.Drawing.FontStyle]::Bold)
$modStatusLabel.ForeColor = [System.Drawing.Color]::Gray
$step3Panel.Controls.Add($modStatusLabel)

$modLocationLabel = New-Object System.Windows.Forms.Label
$modLocationLabel.Location = New-Object System.Drawing.Point(10,68)
$modLocationLabel.Size = New-Object System.Drawing.Size(690,18)
$modLocationLabel.Text = 'Build your mod first using build.bat'
$modLocationLabel.Font = New-Object System.Drawing.Font("Consolas",8)
$modLocationLabel.ForeColor = [System.Drawing.Color]::LightGray
$step3Panel.Controls.Add($modLocationLabel)

# Mod Management Buttons
$loadModButton = New-Object System.Windows.Forms.Button
$loadModButton.Location = New-Object System.Drawing.Point(10,90)
$loadModButton.Size = New-Object System.Drawing.Size(220,35)
$loadModButton.Text = '>> INSTALL MOD TO GAME'
$loadModButton.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
$loadModButton.BackColor = [System.Drawing.Color]::FromArgb(220,20,60)  # Crimson
$loadModButton.ForeColor = [System.Drawing.Color]::White
$loadModButton.FlatStyle = 'Flat'
$loadModButton.Cursor = 'Hand'
$loadModButton.Enabled = $false
$loadModButton.Add_Click({ InstallMod })
$step3Panel.Controls.Add($loadModButton)

$unloadModButton = New-Object System.Windows.Forms.Button
$unloadModButton.Location = New-Object System.Drawing.Point(240,90)
$unloadModButton.Size = New-Object System.Drawing.Size(220,35)
$unloadModButton.Text = '[X] UNINSTALL MOD'
$unloadModButton.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
$unloadModButton.BackColor = [System.Drawing.Color]::FromArgb(178,34,34)  # Firebrick
$unloadModButton.ForeColor = [System.Drawing.Color]::White
$unloadModButton.FlatStyle = 'Flat'
$unloadModButton.Cursor = 'Hand'
$unloadModButton.Enabled = $false
$unloadModButton.Add_Click({ UninstallMod })
$step3Panel.Controls.Add($unloadModButton)

$openPluginsFolderButton = New-Object System.Windows.Forms.Button
$openPluginsFolderButton.Location = New-Object System.Drawing.Point(470,90)
$openPluginsFolderButton.Size = New-Object System.Drawing.Size(230,35)
$openPluginsFolderButton.Text = 'Open Plugins Folder'
$openPluginsFolderButton.Font = New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)
$openPluginsFolderButton.BackColor = [System.Drawing.Color]::FromArgb(70,130,180)
$openPluginsFolderButton.ForeColor = [System.Drawing.Color]::White
$openPluginsFolderButton.FlatStyle = 'Flat'
$openPluginsFolderButton.Cursor = 'Hand'
$openPluginsFolderButton.Add_Click({ OpenPluginsFolder })
$step3Panel.Controls.Add($openPluginsFolderButton)

# ===============================================
# STATUS LOG
# ===============================================
$statusLogLabel = New-Object System.Windows.Forms.Label
$statusLogLabel.Location = New-Object System.Drawing.Point(10,480)
$statusLogLabel.Size = New-Object System.Drawing.Size(720,25)
$statusLogLabel.Text = '=== Activity Log ==='
$statusLogLabel.Font = New-Object System.Drawing.Font("Segoe UI",11,[System.Drawing.FontStyle]::Bold)
$statusLogLabel.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($statusLogLabel)

$statusTextBox = New-Object System.Windows.Forms.TextBox
$statusTextBox.Location = New-Object System.Drawing.Point(10,510)
$statusTextBox.Size = New-Object System.Drawing.Size(715,110)
$statusTextBox.Multiline = $true
$statusTextBox.ScrollBars = 'Vertical'
$statusTextBox.ReadOnly = $true
$statusTextBox.BackColor = [System.Drawing.Color]::FromArgb(15,15,20)
$statusTextBox.ForeColor = [System.Drawing.Color]::FromArgb(0,255,127)  # Spring Green
$statusTextBox.Font = New-Object System.Drawing.Font("Consolas",9)
$form.Controls.Add($statusTextBox)

# Progress Bar with Style
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(10,625)
$progressBar.Size = New-Object System.Drawing.Size(715,25)
$progressBar.Style = 'Continuous'
$progressBar.ForeColor = [System.Drawing.Color]::FromArgb(50,205,50)
$form.Controls.Add($progressBar)

# ===============================================
# FUNCTIONS
# ===============================================

function WriteStatus {
    param([string]$message, [string]$color = "default")

    $timestamp = Get-Date -Format "HH:mm:ss"
    $statusTextBox.AppendText("[$timestamp] $message`r`n")
    $statusTextBox.SelectionStart = $statusTextBox.Text.Length
    $statusTextBox.ScrollToCaret()
    $form.Refresh()
}

function GetIsValidGtagPath {
    $gtagPath = $gtagTextBox.Text
    $gtagExePath = Join-Path $gtagPath "GorillaTag.exe"
    return (Test-Path $gtagPath) -and (Test-Path $gtagExePath)
}

function SetStepStatus {
    param(
        [System.Windows.Forms.Label]$label,
        [bool]$isComplete,
        [string]$stepText
    )

    if ($isComplete) {
        $label.Text = "✔ $stepText"
    } else {
        $label.Text = "☐ $stepText"
    }
}

function CheckModStatus {
    $gtagPath = $gtagTextBox.Text
    $isInstalled = $false

    # Check if mod DLL exists in project
    $modExists = Test-Path $modDllPath

    if ($modExists) {
        $modFileInfo = Get-Item $modDllPath
        $modLocationLabel.Text = "Built: $($modFileInfo.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'))"
        $loadModButton.Enabled = $true
    } else {
        $modLocationLabel.Text = "Build your mod first using build.bat (Option 2)"
        $loadModButton.Enabled = $false
    }

    # Check if mod is installed in game
    if (-not (GetIsValidGtagPath)) {
        $modStatusLabel.Text = "[X] Mod Status: Invalid Game Path"
        $modStatusLabel.ForeColor = [System.Drawing.Color]::Gray
        $unloadModButton.Enabled = $false
        return $false
    }

    $pluginsPath = Join-Path $gtagPath "BepInEx\plugins"
    $installedModPath = Join-Path $pluginsPath $modName

    if (Test-Path $installedModPath) {
        $installedInfo = Get-Item $installedModPath
        $modStatusLabel.Text = "[OK] Mod Status: INSTALLED AND ACTIVE"
        $modStatusLabel.ForeColor = [System.Drawing.Color]::FromArgb(50,255,50)
        $modLocationLabel.Text = "Installed: $($installedInfo.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'))"
        $unloadModButton.Enabled = $true
        $isInstalled = $true

        # Check if installed version matches built version
        if ($modExists) {
            $builtHash = (Get-FileHash $modDllPath).Hash
            $installedHash = (Get-FileHash $installedModPath).Hash
            if ($builtHash -ne $installedHash) {
                $modStatusLabel.Text = "[!] Mod Status: INSTALLED (Update Available)"
                $modStatusLabel.ForeColor = [System.Drawing.Color]::FromArgb(255,215,0)
            }
        }
    } else {
        if ($modExists) {
            $modStatusLabel.Text = "[~] Mod Status: Built But Not Installed"
            $modStatusLabel.ForeColor = [System.Drawing.Color]::FromArgb(255,165,0)
        } else {
            $modStatusLabel.Text = "[ ] Mod Status: Not Built Yet"
            $modStatusLabel.ForeColor = [System.Drawing.Color]::Gray
        }
        $unloadModButton.Enabled = $false
    }

    return $isInstalled
}

function CheckBepInExStatus {
    $gtagPath = $gtagTextBox.Text

    if (-not (GetIsValidGtagPath)) {
        $bepinexStatusLabel.Text = "[X] BepInEx: Invalid Game Path"
        $bepinexStatusLabel.ForeColor = [System.Drawing.Color]::Red
        return $false
    }

    $bepinexPath = Join-Path $gtagPath "BepInEx"
    $winHttpPath = Join-Path $gtagPath "winhttp.dll"

    if ((Test-Path $bepinexPath) -and (Test-Path $winHttpPath)) {
        $bepinexStatusLabel.Text = "[OK] BepInEx: Installed and Ready"
        $bepinexStatusLabel.ForeColor = [System.Drawing.Color]::FromArgb(50,255,50)
        return $true
    } elseif (Test-Path $bepinexPath) {
        $bepinexStatusLabel.Text = "[!] BepInEx: Partially Installed"
        $bepinexStatusLabel.ForeColor = [System.Drawing.Color]::Orange
        return $false
    } else {
        $bepinexStatusLabel.Text = "[X] BepInEx: Not Installed"
        $bepinexStatusLabel.ForeColor = [System.Drawing.Color]::Red
        return $false
    }
}

function CheckAllStatus {
    WriteStatus "Checking all statuses..."
    $bepInExReady = CheckBepInExStatus
    $modInstalled = CheckModStatus
    $isValidPath = GetIsValidGtagPath

    SetStepStatus -label $step1Label -isComplete $isValidPath -stepText "[STEP 1] Locate Gorilla Tag"
    SetStepStatus -label $step2Label -isComplete $bepInExReady -stepText "[STEP 2] BepInEx Setup"
    SetStepStatus -label $step3Label -isComplete $modInstalled -stepText "[STEP 3] Mod Deployment"
    WriteStatus "Status check complete!"
}

function InstallMod {
    $gtagPath = $gtagTextBox.Text

    if (-not (Test-Path $modDllPath)) {
        WriteStatus "ERROR: Mod DLL not found! Build your mod first."
        [System.Windows.Forms.MessageBox]::Show(
            "Mod DLL not found!`n`nPlease build your mod first using build.bat (Option 2)",
            "Mod Not Found",
            'OK',
            'Error'
        )
        return
    }

    if (-not (CheckBepInExStatus)) {
        WriteStatus "ERROR: BepInEx is not installed!"
        [System.Windows.Forms.MessageBox]::Show(
            "BepInEx is not installed in Gorilla Tag!`n`nPlease install BepInEx first.",
            "BepInEx Required",
            'OK',
            'Error'
        )
        return
    }

    $pluginsPath = Join-Path $gtagPath "BepInEx\plugins"

    if (-not (Test-Path $pluginsPath)) {
        WriteStatus "Creating plugins folder..."
        New-Item -ItemType Directory -Path $pluginsPath -Force | Out-Null
    }

    $installedModPath = Join-Path $pluginsPath $modName

    try {
        WriteStatus "================================================"
        WriteStatus ">> INSTALLING MOD TO GAME..."
        WriteStatus "================================================"

        $progressBar.Value = 30
        Copy-Item $modDllPath -Destination $installedModPath -Force

        $progressBar.Value = 100
        WriteStatus "[OK] SUCCESS! Mod installed to game!"
        WriteStatus "Location: $installedModPath"
        WriteStatus "================================================"
        WriteStatus ""
        WriteStatus ">> READY TO PLAY! Launch Gorilla Tag and press F1 in-game"

        CheckModStatus

        [System.Windows.Forms.MessageBox]::Show(
            "*** MOD INSTALLED SUCCESSFULLY! ***`n`nYour mod is now active in Gorilla Tag!`n`nPress F1 in-game to open the mod menu.",
            "Installation Complete",
            'OK',
            'Information'
        )

        $progressBar.Value = 0
    }
    catch {
        WriteStatus "ERROR: Failed to install mod - $_"
        [System.Windows.Forms.MessageBox]::Show(
            "Failed to install mod!`n`n$_",
            "Installation Failed",
            'OK',
            'Error'
        )
        $progressBar.Value = 0
    }
}

function UninstallMod {
    $gtagPath = $gtagTextBox.Text
    $pluginsPath = Join-Path $gtagPath "BepInEx\plugins"
    $installedModPath = Join-Path $pluginsPath $modName

    if (-not (Test-Path $installedModPath)) {
        WriteStatus "Mod is not installed in game"
        [System.Windows.Forms.MessageBox]::Show(
            "Mod is not currently installed in the game.",
            "Not Installed",
            'OK',
            'Information'
        )
        return
    }

    $result = [System.Windows.Forms.MessageBox]::Show(
        "Are you sure you want to uninstall the mod from Gorilla Tag?",
        "Confirm Uninstall",
        'YesNo',
        'Question'
    )

    if ($result -ne 'Yes') { return }

    try {
        WriteStatus "================================================"
        WriteStatus "[X] UNINSTALLING MOD..."
        WriteStatus "================================================"

        $progressBar.Value = 50
        Remove-Item $installedModPath -Force

        $progressBar.Value = 100
        WriteStatus "[OK] Mod successfully uninstalled from game"
        WriteStatus "================================================"

        CheckModStatus

        [System.Windows.Forms.MessageBox]::Show(
            "Mod uninstalled successfully!`n`nYour mod has been removed from Gorilla Tag.",
            "Uninstall Complete",
            'OK',
            'Information'
        )

        $progressBar.Value = 0
    }
    catch {
        WriteStatus "ERROR: Failed to uninstall mod - $_"
        [System.Windows.Forms.MessageBox]::Show(
            "Failed to uninstall mod!`n`n$_",
            "Uninstall Failed",
            'OK',
            'Error'
        )
        $progressBar.Value = 0
    }
}

function OpenPluginsFolder {
    $gtagPath = $gtagTextBox.Text
    $pluginsPath = Join-Path $gtagPath "BepInEx\plugins"

    if (-not (Test-Path $pluginsPath)) {
        WriteStatus "Plugins folder doesn't exist yet"
        [System.Windows.Forms.MessageBox]::Show(
            "Plugins folder doesn't exist yet.`n`nInstall BepInEx first, then run Gorilla Tag once.",
            "Folder Not Found",
            'OK',
            'Warning'
        )
        return
    }

    WriteStatus "Opening plugins folder..."
    Start-Process "explorer.exe" -ArgumentList $pluginsPath
}

function CreateDoorstopConfig {
    param([string]$gtagPath)

    $doorstopConfig = @"
[UnityDoorstop]
enabled=true
targetAssembly=BepInEx\core\BepInEx.IL2CPP.dll
redirectOutputLog=false
"@

    $configPath = Join-Path $gtagPath "doorstop_config.ini"

    try {
        Set-Content -Path $configPath -Value $doorstopConfig -Force
        WriteStatus "[OK] Created doorstop_config.ini"
        return $true
    }
    catch {
        WriteStatus "[!] Warning: Could not create doorstop_config.ini"
        return $false
    }
}

function ShowManualInstructions {
    $helpText = @"
=== MANUAL BEPINEX INSTALLATION GUIDE ===

If automatic download doesn't work:

[1] Visit: https://builds.bepinex.dev/projects/bepinex_be

[2] Download LATEST 'BepInEx-IL2CPP-x64' build
    (Look for: BepInEx-IL2CPP-x64-6.0.0-be.XXX.zip)

[3] Extract the ZIP file to a temporary folder

[4] Copy EVERYTHING from inside the extracted folder
    into your Gorilla Tag folder (where GorillaTag.exe is)

[5] Run Gorilla Tag once
    - Takes longer to start (NORMAL)
    - Console window appears (NORMAL)
    - BepInEx creates folders automatically

[6] Come back and click 'Copy Dev Libraries'

=== TROUBLESHOOTING ===
- Game won't start: Disable antivirus
- Console appears: This is NORMAL with BepInEx
- Crashes on launch: Check BepInEx\LogOutput.log
- Still issues: Run as Administrator

TIP: Add Gorilla Tag folder to antivirus exceptions!
"@

    [System.Windows.Forms.MessageBox]::Show($helpText, "Manual Installation Guide", 'OK', 'Information')
}

function DownloadBepInEx {
    $gtagPath = $gtagTextBox.Text

    if (-not (Test-Path $gtagPath)) {
        [System.Windows.Forms.MessageBox]::Show(
            "Please select a valid Gorilla Tag installation folder first!",
            "Invalid Path",
            'OK',
            'Error'
        )
        return
    }

    if (-not (Test-Path (Join-Path $gtagPath "GorillaTag.exe"))) {
        [System.Windows.Forms.MessageBox]::Show(
            "GorillaTag.exe not found! Please select the correct folder.",
            "Invalid Folder",
            'OK',
            'Error'
        )
        return
    }

    $result = [System.Windows.Forms.MessageBox]::Show(
        "This will download and install BepInEx IL2CPP (Bleeding Edge).`n`nThis is the recommended version for Gorilla Tag.`n`nProceed?",
        "Confirm Installation",
        'YesNo',
        'Question'
    )

    if ($result -ne 'Yes') { return }

    WriteStatus "================================================"
    WriteStatus " Starting BepInEx Download..."
    WriteStatus "================================================"

    if (-not (Test-Path $tempPath)) {
        New-Item -ItemType Directory -Path $tempPath -Force | Out-Null
    }

    $bepinexUrl = "https://builds.bepinex.dev/projects/bepinex_be/667/BepInEx-IL2CPP-x64-6.0.0-be.667%2B42a6727.zip"
    $zipPath = Join-Path $tempPath "BepInEx.zip"

    try {
        $progressBar.Value = 10
        WriteStatus "[>>] Downloading BepInEx Bleeding Edge..."
        WriteStatus "[...] This may take a minute..."

        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($bepinexUrl, $zipPath)

        $progressBar.Value = 50
        WriteStatus "[OK] Download complete!"
        WriteStatus "[>>] Extracting files..."

        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $gtagPath)

        $progressBar.Value = 80
        WriteStatus "[OK] Files extracted!"

        CreateDoorstopConfig -gtagPath $gtagPath

        Remove-Item $zipPath -Force -ErrorAction SilentlyContinue

        $progressBar.Value = 100
        WriteStatus "================================================"
        WriteStatus "[OK] BepInEx Installation Complete!"
        WriteStatus "================================================"
        WriteStatus ""
        WriteStatus "=== NEXT STEPS ==="
        WriteStatus "1. Run Gorilla Tag ONCE (takes longer first time)"
        WriteStatus "2. Console window is NORMAL"
        WriteStatus "3. Click 'Copy Dev Libraries' after game runs"

        CheckAllStatus

        [System.Windows.Forms.MessageBox]::Show(
            "*** BepInEx installed successfully! ***`n`nNEXT STEPS:`n1. Run Gorilla Tag once (takes longer to start)`n2. Console window is NORMAL`n3. Come back and click 'Copy Dev Libraries'",
            "Installation Complete",
            'OK',
            'Information'
        )

        $progressBar.Value = 0
    }
    catch {
        $progressBar.Value = 0
        WriteStatus "[X] ERROR: $_"

        $retryResult = [System.Windows.Forms.MessageBox]::Show(
            "Automatic download failed!`n`nWould you like to see manual installation instructions?",
            "Download Failed",
            'YesNo',
            'Error'
        )

        if ($retryResult -eq 'Yes') {
            ShowManualInstructions
        }
    }
}

function CopyDllFiles {
    $gtagPath = $gtagTextBox.Text

    if (-not (Test-Path $gtagPath)) {
        WriteStatus "ERROR: Gorilla Tag folder not found!"
        [System.Windows.Forms.MessageBox]::Show(
            "Gorilla Tag folder not found!",
            "Error",
            'OK',
            'Error'
        )
        return
    }

    if (-not (CheckBepInExStatus)) {
        $result = [System.Windows.Forms.MessageBox]::Show(
            "BepInEx is not installed. Install it now?",
            "BepInEx Required",
            'YesNo',
            'Warning'
        )

        if ($result -eq 'Yes') {
            DownloadBepInEx
        }
        return
    }

    WriteStatus "================================================"
    WriteStatus "[>>] Copying DLL Files for Development..."
    WriteStatus "================================================"

    $progressBar.Value = 0

    if (-not (Test-Path $libsPath)) {
        New-Item -ItemType Directory -Path $libsPath -Force | Out-Null
        WriteStatus "[OK] Created libs folder"
    }

    # Find BepInEx DLL
    $bepinexDllPath = $null
    $possibleBepInExPaths = @(
        (Join-Path $gtagPath "BepInEx\core\BepInEx.Core.dll"),
        (Join-Path $gtagPath "BepInEx\core\BepInEx.dll"),
        (Join-Path $gtagPath "BepInEx\core\BepInEx.IL2CPP.dll")
    )

    foreach ($path in $possibleBepInExPaths) {
        if (Test-Path $path) {
            $bepinexDllPath = $path
            WriteStatus "[OK] Found BepInEx DLL: $(Split-Path $path -Leaf)"
            break
        }
    }

    # Find Managed folder
    $managedPaths = @(
        (Join-Path $gtagPath "Gorilla Tag_Data\Managed"),
        (Join-Path $gtagPath "GorillaTag_Data\Managed")
    )

    $actualManagedPath = $null
    foreach ($path in $managedPaths) {
        if (Test-Path $path) {
            $actualManagedPath = $path
            WriteStatus "[OK] Found Managed folder"
            break
        }
    }

    # Build file list
    $filesToCopy = @()

    if ($bepinexDllPath) {
        $filesToCopy += @{
            Source = $bepinexDllPath
            Dest = "BepInEx.dll"
            Name = "BepInEx.dll"
        }
    }

    if ($actualManagedPath) {
        $unityDllNames = @(
            "UnityEngine.dll",
            "UnityEngine.CoreModule.dll",
            "UnityEngine.InputLegacyModule.dll",
            "UnityEngine.IMGUIModule.dll",
            "Assembly-CSharp.dll",
            "UnityEngine.UI.dll"
        )

        foreach ($dllName in $unityDllNames) {
            $fullPath = Join-Path $actualManagedPath $dllName
            $filesToCopy += @{
                Source = $fullPath
                Dest = $dllName
                Name = $dllName
            }
        }
    }

    # Copy files
    $successCount = 0
    $failCount = 0
    $totalFiles = $filesToCopy.Count

    WriteStatus ""
    WriteStatus "[>>] Copying $totalFiles files..."

    for ($i = 0; $i -lt $filesToCopy.Count; $i++) {
        $file = $filesToCopy[$i]
        $progressBar.Value = [int](($i / $totalFiles) * 100)

        if ($file.Source -and (Test-Path $file.Source)) {
            try {
                Copy-Item $file.Source -Destination (Join-Path $libsPath $file.Dest) -Force
                WriteStatus "   $($file.Name)"
                $successCount++
            }
            catch {
                WriteStatus "   $($file.Name) - $_"
                $failCount++
            }
        }
        else {
            WriteStatus "   $($file.Name) - Not Found"
            $failCount++
        }
    }

    $progressBar.Value = 100

    WriteStatus ""
    WriteStatus "================================================"

    if ($failCount -eq 0) {
        WriteStatus "[OK] SUCCESS! All $successCount files copied!"
        WriteStatus "================================================"
        WriteStatus ""
        WriteStatus ">> Next: Run build.bat to compile your mod!"

        [System.Windows.Forms.MessageBox]::Show(
            " All DLL files copied successfully! `n`n$successCount files copied`n`nYou can now run build.bat to compile your mod!",
            "Setup Complete",
            'OK',
            'Information'
        )
    }
    else {
        WriteStatus "[!] RESULTS: $successCount succeeded, $failCount failed"
        WriteStatus "================================================"

        [System.Windows.Forms.MessageBox]::Show(
            "Some files could not be found.`n`n$successCount succeeded`n$failCount failed`n`nCheck the log for details.",
            "Setup Incomplete",
            'OK',
            'Warning'
        )
    }

    $progressBar.Value = 0
}

# ===============================================
# INITIALIZATION
# ===============================================
WriteStatus "================================================"
WriteStatus "*** GTag Mod Manager ULTIMATE - Ready! ***"
WriteStatus "================================================"
WriteStatus ""
WriteStatus "Select your Gorilla Tag folder to begin..."

$form.Add_Shown({
    $form.Activate()
    CheckAllStatus
})

[void]$form.ShowDialog()

if (Test-Path $tempPath) {
    Remove-Item $tempPath -Recurse -Force -ErrorAction SilentlyContinue
}
