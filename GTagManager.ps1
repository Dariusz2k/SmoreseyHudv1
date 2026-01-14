# GTag Mod Manager - Complete Setup Tool
# Handles BepInEx installation, DLL setup, and mod building

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem

$projectPath = "D:\ProgrammingStuff\GTagMenu"
$libsPath = "$projectPath\libs"
$tempPath = "$projectPath\temp"

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'GTag Mod Manager'
$form.Size = New-Object System.Drawing.Size(700,550)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(240,240,240)

# Title Label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Location = New-Object System.Drawing.Point(10,10)
$titleLabel.Size = New-Object System.Drawing.Size(660,35)
$titleLabel.Text = 'GTag Mod Manager'
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI",16,[System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(50,50,50)
$form.Controls.Add($titleLabel)

# Subtitle
$subtitleLabel = New-Object System.Windows.Forms.Label
$subtitleLabel.Location = New-Object System.Drawing.Point(10,45)
$subtitleLabel.Size = New-Object System.Drawing.Size(660,20)
$subtitleLabel.Text = 'Setup BepInEx, manage DLLs, and build your mod'
$subtitleLabel.Font = New-Object System.Drawing.Font("Segoe UI",9)
$subtitleLabel.ForeColor = [System.Drawing.Color]::FromArgb(100,100,100)
$form.Controls.Add($subtitleLabel)

# Separator line
$separator1 = New-Object System.Windows.Forms.Label
$separator1.Location = New-Object System.Drawing.Point(10,70)
$separator1.Size = New-Object System.Drawing.Size(660,2)
$separator1.BorderStyle = 'Fixed3D'
$form.Controls.Add($separator1)

# === STEP 1: Gorilla Tag Path ===
$step1Label = New-Object System.Windows.Forms.Label
$step1Label.Location = New-Object System.Drawing.Point(10,85)
$step1Label.Size = New-Object System.Drawing.Size(660,25)
$step1Label.Text = 'Step 1: Locate Gorilla Tag Installation'
$step1Label.Font = New-Object System.Drawing.Font("Segoe UI",11,[System.Drawing.FontStyle]::Bold)
$form.Controls.Add($step1Label)

$gtagTextBox = New-Object System.Windows.Forms.TextBox
$gtagTextBox.Location = New-Object System.Drawing.Point(10,115)
$gtagTextBox.Size = New-Object System.Drawing.Size(560,25)
$gtagTextBox.Font = New-Object System.Drawing.Font("Consolas",9)
$gtagTextBox.Text = "C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag"
$form.Controls.Add($gtagTextBox)

$browseGtagButton = New-Object System.Windows.Forms.Button
$browseGtagButton.Location = New-Object System.Drawing.Point(580,113)
$browseGtagButton.Size = New-Object System.Drawing.Size(90,27)
$browseGtagButton.Text = 'Browse...'
$browseGtagButton.Font = New-Object System.Drawing.Font("Segoe UI",9)
$browseGtagButton.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select your Gorilla Tag installation folder (contains GorillaTag.exe)"
    $folderBrowser.SelectedPath = $gtagTextBox.Text
    
    if ($folderBrowser.ShowDialog() -eq 'OK') {
        $gtagTextBox.Text = $folderBrowser.SelectedPath
        CheckBepInExStatus
    }
})
$form.Controls.Add($browseGtagButton)

# BepInEx Status Label
$bepinexStatusLabel = New-Object System.Windows.Forms.Label
$bepinexStatusLabel.Location = New-Object System.Drawing.Point(10,145)
$bepinexStatusLabel.Size = New-Object System.Drawing.Size(660,20)
$bepinexStatusLabel.Text = 'BepInEx Status: Not Checked'
$bepinexStatusLabel.Font = New-Object System.Drawing.Font("Segoe UI",9)
$bepinexStatusLabel.ForeColor = [System.Drawing.Color]::Gray
$form.Controls.Add($bepinexStatusLabel)

# === STEP 2: BepInEx Installation ===
$step2Label = New-Object System.Windows.Forms.Label
$step2Label.Location = New-Object System.Drawing.Point(10,175)
$step2Label.Size = New-Object System.Drawing.Size(660,25)
$step2Label.Text = 'Step 2: Install BepInEx'
$step2Label.Font = New-Object System.Drawing.Font("Segoe UI",11,[System.Drawing.FontStyle]::Bold)
$form.Controls.Add($step2Label)

$bepinexInfoLabel = New-Object System.Windows.Forms.Label
$bepinexInfoLabel.Location = New-Object System.Drawing.Point(10,205)
$bepinexInfoLabel.Size = New-Object System.Drawing.Size(660,40)
$bepinexInfoLabel.Text = "BepInEx is required to run mods in Gorilla Tag. If it's not installed, you can download and install it automatically."
$bepinexInfoLabel.Font = New-Object System.Drawing.Font("Segoe UI",9)
$form.Controls.Add($bepinexInfoLabel)

# BepInEx buttons panel
$bepinexPanel = New-Object System.Windows.Forms.Panel
$bepinexPanel.Location = New-Object System.Drawing.Point(10,245)
$bepinexPanel.Size = New-Object System.Drawing.Size(660,35)
$form.Controls.Add($bepinexPanel)

$downloadBepInExButton = New-Object System.Windows.Forms.Button
$downloadBepInExButton.Location = New-Object System.Drawing.Point(0,0)
$downloadBepInExButton.Size = New-Object System.Drawing.Size(150,30)
$downloadBepInExButton.Text = 'Download BepInEx'
$downloadBepInExButton.Font = New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)
$downloadBepInExButton.BackColor = [System.Drawing.Color]::FromArgb(70,130,180)
$downloadBepInExButton.ForeColor = [System.Drawing.Color]::White
$downloadBepInExButton.FlatStyle = 'Flat'
$downloadBepInExButton.Add_Click({
    DownloadBepInEx
})
$bepinexPanel.Controls.Add($downloadBepInExButton)

$openBepInExPageButton = New-Object System.Windows.Forms.Button
$openBepInExPageButton.Location = New-Object System.Drawing.Point(160,0)
$openBepInExPageButton.Size = New-Object System.Drawing.Size(150,30)
$openBepInExPageButton.Text = 'Open Download Page'
$openBepInExPageButton.Font = New-Object System.Drawing.Font("Segoe UI",9)
$openBepInExPageButton.Add_Click({
    Start-Process "https://builds.bepinex.dev/projects/bepinex_be"
})
$bepinexPanel.Controls.Add($openBepInExPageButton)

$checkBepInExButton = New-Object System.Windows.Forms.Button
$checkBepInExButton.Location = New-Object System.Drawing.Point(320,0)
$checkBepInExButton.Size = New-Object System.Drawing.Size(120,30)
$checkBepInExButton.Text = 'Check Status'
$checkBepInExButton.Font = New-Object System.Drawing.Font("Segoe UI",9)
$checkBepInExButton.Add_Click({
    CheckBepInExStatus
})
$bepinexPanel.Controls.Add($checkBepInExButton)

$helpButton = New-Object System.Windows.Forms.Button
$helpButton.Location = New-Object System.Drawing.Point(450,0)
$helpButton.Size = New-Object System.Drawing.Size(100,30)
$helpButton.Text = 'Help'
$helpButton.Font = New-Object System.Drawing.Font("Segoe UI",9)
$helpButton.Add_Click({
    ShowManualInstructions
})
$bepinexPanel.Controls.Add($helpButton)

# === STEP 3: Copy DLLs ===
$step3Label = New-Object System.Windows.Forms.Label
$step3Label.Location = New-Object System.Drawing.Point(10,290)
$step3Label.Size = New-Object System.Drawing.Size(660,25)
$step3Label.Text = 'Step 3: Setup Development Libraries'
$step3Label.Font = New-Object System.Drawing.Font("Segoe UI",11,[System.Drawing.FontStyle]::Bold)
$form.Controls.Add($step3Label)

$copyDllsButton = New-Object System.Windows.Forms.Button
$copyDllsButton.Location = New-Object System.Drawing.Point(10,320)
$copyDllsButton.Size = New-Object System.Drawing.Size(200,35)
$copyDllsButton.Text = 'Copy DLL Files'
$copyDllsButton.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
$copyDllsButton.BackColor = [System.Drawing.Color]::FromArgb(60,179,113)
$copyDllsButton.ForeColor = [System.Drawing.Color]::White
$copyDllsButton.FlatStyle = 'Flat'
$copyDllsButton.Add_Click({
    CopyDllFiles
})
$form.Controls.Add($copyDllsButton)

# Status TextBox
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(10,365)
$statusLabel.Size = New-Object System.Drawing.Size(660,20)
$statusLabel.Text = 'Status Log:'
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
$form.Controls.Add($statusLabel)

$statusTextBox = New-Object System.Windows.Forms.TextBox
$statusTextBox.Location = New-Object System.Drawing.Point(10,390)
$statusTextBox.Size = New-Object System.Drawing.Size(660,100)
$statusTextBox.Multiline = $true
$statusTextBox.ScrollBars = 'Vertical'
$statusTextBox.ReadOnly = $true
$statusTextBox.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)
$statusTextBox.ForeColor = [System.Drawing.Color]::FromArgb(0,255,0)
$statusTextBox.Font = New-Object System.Drawing.Font("Consolas",9)
$form.Controls.Add($statusTextBox)

# Progress Bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(10,495)
$progressBar.Size = New-Object System.Drawing.Size(660,20)
$progressBar.Style = 'Continuous'
$form.Controls.Add($progressBar)

# === FUNCTIONS ===

function WriteStatus {
    param([string]$message)
    
    $statusTextBox.AppendText("$message`r`n")
    $statusTextBox.SelectionStart = $statusTextBox.Text.Length
    $statusTextBox.ScrollToCaret()
    $form.Refresh()
}

function CheckBepInExStatus {
    $gtagPath = $gtagTextBox.Text
    
    if (-not (Test-Path $gtagPath)) {
        $bepinexStatusLabel.Text = "BepInEx Status: Invalid Gorilla Tag path"
        $bepinexStatusLabel.ForeColor = [System.Drawing.Color]::Red
        return $false
    }
    
    $bepinexPath = Join-Path $gtagPath "BepInEx"
    $winHttpPath = Join-Path $gtagPath "winhttp.dll"
    
    if ((Test-Path $bepinexPath) -and (Test-Path $winHttpPath)) {
        $bepinexStatusLabel.Text = "BepInEx Status: Installed and Ready"
        $bepinexStatusLabel.ForeColor = [System.Drawing.Color]::Green
        WriteStatus "BepInEx detected in Gorilla Tag folder"
        return $true
    }
    elseif (Test-Path $bepinexPath) {
        $bepinexStatusLabel.Text = "BepInEx Status: Partially Installed"
        $bepinexStatusLabel.ForeColor = [System.Drawing.Color]::Orange
        return $false
    }
    else {
        $bepinexStatusLabel.Text = "BepInEx Status: Not Installed"
        $bepinexStatusLabel.ForeColor = [System.Drawing.Color]::Red
        return $false
    }
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
        WriteStatus "Created doorstop_config.ini"
        return $true
    }
    catch {
        WriteStatus "Warning: Could not create doorstop_config.ini"
        return $false
    }
}

function ShowManualInstructions {
    $helpText = @"
MANUAL BEPINEX INSTALLATION FOR GORILLA TAG

If automatic download doesn't work, follow these steps:

1. Go to: https://builds.bepinex.dev/projects/bepinex_be

2. Download the LATEST 'BepInEx-IL2CPP-x64' build
   Look for: BepInEx-IL2CPP-x64-6.0.0-be.XXX.zip

3. Extract the ZIP file to a temporary folder

4. Copy EVERYTHING from inside the extracted folder
   into your Gorilla Tag folder (where GorillaTag.exe is)

5. Run Gorilla Tag once
   - It will take longer to start (this is normal)
   - A console window may appear (this is normal)
   - BepInEx will create folders and config files

6. If the game crashes:
   - Check your antivirus (add Gorilla Tag to exceptions)
   - Look at BepInEx\LogOutput.log for error messages
   - Try running Steam/Gorilla Tag as administrator

7. Once the game runs, come back and click 'Copy DLL Files'

TROUBLESHOOTING:
- Game won't start: Disable antivirus temporarily
- Console appears: This is normal with BepInEx
- Crashes on launch: Check BepInEx\LogOutput.log
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
        "This will download and install BepInEx IL2CPP (Bleeding Edge build).`n`nThis is the recommended version for Gorilla Tag.`n`nProceed?",
        "Confirm Installation",
        'YesNo',
        'Question'
    )
    
    if ($result -ne 'Yes') { return }
    
    WriteStatus "================================================"
    WriteStatus "Starting BepInEx Download..."
    WriteStatus "================================================"
    
    if (-not (Test-Path $tempPath)) {
        New-Item -ItemType Directory -Path $tempPath -Force | Out-Null
    }
    
    # Use bleeding edge build (recommended for Gorilla Tag)
    $bepinexUrl = "https://builds.bepinex.dev/projects/bepinex_be/667/BepInEx-IL2CPP-x64-6.0.0-be.667%2B42a6727.zip"
    $zipPath = Join-Path $tempPath "BepInEx.zip"
    
    try {
        $progressBar.Value = 10
        WriteStatus "Downloading BepInEx Bleeding Edge build..."
        WriteStatus "This may take a minute..."
        
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($bepinexUrl, $zipPath)
        
        $progressBar.Value = 50
        WriteStatus "Download complete!"
        WriteStatus "Extracting files..."
        
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $gtagPath)
        
        $progressBar.Value = 80
        WriteStatus "Files extracted!"
        
        # Create doorstop config
        CreateDoorstopConfig -gtagPath $gtagPath
        
        # Cleanup
        Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
        
        $progressBar.Value = 100
        WriteStatus "================================================"
        WriteStatus "BepInEx Installation Complete!"
        WriteStatus "================================================"
        WriteStatus ""
        WriteStatus "NEXT STEPS:"
        WriteStatus "1. Run Gorilla Tag ONCE (it will take longer)"
        WriteStatus "2. A console window may appear (this is normal)"
        WriteStatus "3. After the game runs, click 'Copy DLL Files'"
        
        CheckBepInExStatus
        
        [System.Windows.Forms.MessageBox]::Show(
            "BepInEx installed successfully!`n`nNEXT STEPS:`n1. Run Gorilla Tag once (takes longer to start)`n2. Console window is normal`n3. Come back and click 'Copy DLL Files'",
            "Installation Complete",
            'OK',
            'Information'
        )
        
        $progressBar.Value = 0
    }
    catch {
        $progressBar.Value = 0
        WriteStatus "ERROR: $_"
        
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
    WriteStatus "Copying DLL Files..."
    WriteStatus "================================================"
    WriteStatus "Searching for DLL files..."
    
    $progressBar.Value = 0
    
    if (-not (Test-Path $libsPath)) {
        New-Item -ItemType Directory -Path $libsPath -Force | Out-Null
        WriteStatus "Created libs folder"
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
            WriteStatus "Found BepInEx DLL: $(Split-Path $path -Leaf)"
            break
        }
    }
    
    if (-not $bepinexDllPath) {
        WriteStatus "Searching entire BepInEx folder for DLL..."
        $foundDlls = Get-ChildItem -Path (Join-Path $gtagPath "BepInEx") -Filter "*.dll" -Recurse | Where-Object { $_.Name -like "*BepInEx*" }
        if ($foundDlls) {
            $bepinexDllPath = $foundDlls[0].FullName
            WriteStatus "Found: $($foundDlls[0].Name)"
        }
    }
    
    # Check for both possible folder names (with and without space)
    $managedPaths = @(
        (Join-Path $gtagPath "Gorilla Tag_Data\Managed"),  # WITH SPACE
        (Join-Path $gtagPath "GorillaTag_Data\Managed")     # WITHOUT SPACE
    )
    
    $actualManagedPath = $null
    foreach ($path in $managedPaths) {
        if (Test-Path $path) {
            $actualManagedPath = $path
            WriteStatus "Found Managed folder: $path"
            break
        }
    }
    
    # If we still can't find it, search for it
    if (-not $actualManagedPath) {
        WriteStatus "Searching for Unity DLLs..."
        $foundUnity = Get-ChildItem -Path $gtagPath -Filter "UnityEngine.dll" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($foundUnity) {
            $actualManagedPath = $foundUnity.DirectoryName
            WriteStatus "Found Unity DLLs at: $actualManagedPath"
        }
    }
    
    # Build file list
    $filesToCopy = @()
    
    # Add BepInEx DLL
    if ($bepinexDllPath) {
        $filesToCopy += @{
            Source = $bepinexDllPath
            Dest = "BepInEx.dll"
            Name = "BepInEx.dll"
        }
    }
    
    # Add Unity DLLs
    if ($actualManagedPath) {
        $unityDllNames = @(
            "UnityEngine.dll",
            "UnityEngine.CoreModule.dll",
            "Assembly-CSharp.dll",
            "UnityEngine.UI.dll",
            "UnityEngine.IMGUIModule.dll"
        )
        
        foreach ($dllName in $unityDllNames) {
            $fullPath = Join-Path $actualManagedPath $dllName
            $filesToCopy += @{
                Source = $fullPath
                Dest = $dllName
                Name = $dllName
            }
        }
    } else {
        WriteStatus "ERROR: Could not locate Managed folder!"
    }
    
    # Copy files
    $successCount = 0
    $failCount = 0
    $totalFiles = $filesToCopy.Count
    
    WriteStatus ""
    WriteStatus "Copying $totalFiles files..."
    
    for ($i = 0; $i -lt $filesToCopy.Count; $i++) {
        $file = $filesToCopy[$i]
        $progressBar.Value = [int](($i / $totalFiles) * 100)
        
        if ($file.Source -and (Test-Path $file.Source)) {
            try {
                Copy-Item $file.Source -Destination (Join-Path $libsPath $file.Dest) -Force
                WriteStatus "[OK] Copied: $($file.Name)"
                $successCount++
            }
            catch {
                WriteStatus "[FAIL] Failed: $($file.Name) - $_"
                $failCount++
            }
        }
        else {
            WriteStatus "[MISSING] Not found: $($file.Name)"
            if ($file.Source) {
                WriteStatus "          Expected at: $($file.Source)"
            }
            $failCount++
        }
    }
    
    $progressBar.Value = 100
    
    WriteStatus ""
    WriteStatus "================================================"
    
    if ($failCount -eq 0) {
        WriteStatus "SUCCESS! All $successCount files copied!"
        WriteStatus "================================================"
        WriteStatus ""
        WriteStatus "Next step: Run build.bat to compile your mod"
        
        [System.Windows.Forms.MessageBox]::Show(
            "All DLL files copied successfully!`n`n$successCount files copied`n`nYou can now run build.bat to compile your mod.",
            "Setup Complete",
            'OK',
            'Information'
        )
    }
    else {
        WriteStatus "RESULTS: $successCount succeeded, $failCount failed"
        WriteStatus "================================================"
        
        if ($successCount -ge 2) {
            WriteStatus ""
            WriteStatus "You have some files - you may be able to build"
        }
        
        [System.Windows.Forms.MessageBox]::Show(
            "Some files could not be found.`n`n$successCount succeeded`n$failCount failed`n`nCheck the status log for details.",
            "Setup Incomplete",
            'OK',
            'Warning'
        )
    }
    
    $progressBar.Value = 0
}
# Initial status
WriteStatus "GTag Mod Manager Ready"
WriteStatus "Select your Gorilla Tag folder to begin"

$form.Add_Shown({
    $form.Activate()
    CheckBepInExStatus
})

[void]$form.ShowDialog()

if (Test-Path $tempPath) {
    Remove-Item $tempPath -Recurse -Force -ErrorAction SilentlyContinue
}