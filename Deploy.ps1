# GorillaTag Mod Menu Project Generator
# This script creates a complete BepInEx mod project structure

$projectPath = "D:\ProgrammingStuff\GTagMenu"
$projectName = "GTagSpeedMod"
$namespace = "GTagSpeedMod"

Write-Host "Creating Gorilla Tag Mod Menu Project..." -ForegroundColor Cyan

# Create directory structure
$directories = @(
    "$projectPath",
    "$projectPath\$projectName",
    "$projectPath\$projectName\Properties",
    "$projectPath\libs"
)

foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "Created directory: $dir" -ForegroundColor Green
    }
}

# Create AssemblyInfo.cs
$assemblyInfo = @'
using System.Reflection;
using System.Runtime.InteropServices;

[assembly: AssemblyTitle("GTagSpeedMod")]
[assembly: AssemblyDescription("A simple speed boost mod for Gorilla Tag")]
[assembly: AssemblyCompany("")]
[assembly: AssemblyProduct("GTagSpeedMod")]
[assembly: AssemblyCopyright("Copyright © 2026")]
[assembly: ComVisible(false)]
[assembly: Guid("12345678-1234-1234-1234-123456789012")]
[assembly: AssemblyVersion("1.0.0.0")]
[assembly: AssemblyFileVersion("1.0.0.0")]
'@

Set-Content -Path "$projectPath\$projectName\Properties\AssemblyInfo.cs" -Value $assemblyInfo
Write-Host "Created AssemblyInfo.cs" -ForegroundColor Green

# Create main plugin file
$pluginCode = @'
using BepInEx;
using UnityEngine;
using System;

namespace GTagSpeedMod
{
    // This attribute tells BepInEx about your mod
    [BepInPlugin("com.yourname.gtagspeedmod", "GTag Speed Mod", "1.0.0")]
    public class SpeedModPlugin : BaseUnityPlugin
    {
        // These are our mod settings
        private bool modMenuEnabled = false;
        private bool speedBoostEnabled = false;
        private float speedMultiplier = 2.0f;
        
        // UI positioning
        private Rect menuRect = new Rect(20, 20, 250, 200);
        private bool showMenu = false;
        
        // This runs when your mod loads
        void Awake()
        {
            Logger.LogInfo("GTag Speed Mod has loaded!");
        }
        
        // This runs every frame
        void Update()
        {
            // Press F1 to toggle the menu
            if (Input.GetKeyDown(KeyCode.F1))
            {
                showMenu = !showMenu;
                Logger.LogInfo($"Menu toggled: {showMenu}");
            }
            
            // Apply speed boost if enabled
            if (speedBoostEnabled)
            {
                ApplySpeedBoost();
            }
        }
        
        // This draws the UI on screen
        void OnGUI()
        {
            if (showMenu)
            {
                // Create a window for our menu
                menuRect = GUI.Window(0, menuRect, DrawMenu, "Speed Mod Menu");
            }
        }
        
        // This function draws what's inside the menu
        void DrawMenu(int windowID)
        {
            // Make the window draggable
            GUI.DragWindow(new Rect(0, 0, 250, 20));
            
            GUILayout.Space(10);
            
            // Toggle for speed boost
            speedBoostEnabled = GUILayout.Toggle(speedBoostEnabled, "Speed Boost Enabled");
            
            GUILayout.Space(10);
            
            // Slider to control speed
            GUILayout.Label($"Speed Multiplier: {speedMultiplier:F1}x");
            speedMultiplier = GUILayout.HorizontalSlider(speedMultiplier, 1.0f, 5.0f);
            
            GUILayout.Space(10);
            
            // Info text
            GUILayout.Label("Press F1 to toggle menu");
            
            GUILayout.Space(10);
            
            if (GUILayout.Button("Close"))
            {
                showMenu = false;
            }
        }
        
        // This function applies the speed boost
        // NOTE: You'll need to modify this based on how Gorilla Tag actually works!
        void ApplySpeedBoost()
        {
            // TODO: This is a placeholder!
            // You need to find the actual player controller in Gorilla Tag
            // and modify the correct speed variables
            
            // Example approach (won't work without proper references):
            // GameObject player = GameObject.Find("Player");
            // if (player != null)
            // {
            //     // Get the movement component and modify speed
            //     var movement = player.GetComponent<SomeMovementComponent>();
            //     if (movement != null)
            //     {
            //         movement.speed *= speedMultiplier;
            //     }
            // }
            
            Logger.LogWarning("Speed boost logic needs to be implemented!");
        }
    }
}
'@

Set-Content -Path "$projectPath\$projectName\SpeedModPlugin.cs" -Value $pluginCode
Write-Host "Created SpeedModPlugin.cs" -ForegroundColor Green

# Create .csproj file
$csprojContent = @'
<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="15.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <Import Project="$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props" Condition="Exists('$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props')" />
  <PropertyGroup>
    <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
    <Platform Condition=" '$(Platform)' == '' ">AnyCPU</Platform>
    <ProjectGuid>{12345678-1234-1234-1234-123456789012}</ProjectGuid>
    <OutputType>Library</OutputType>
    <AppDesignerFolder>Properties</AppDesignerFolder>
    <RootNamespace>GTagSpeedMod</RootNamespace>
    <AssemblyName>GTagSpeedMod</AssemblyName>
    <TargetFrameworkVersion>v4.7.2</TargetFrameworkVersion>
    <FileAlignment>512</FileAlignment>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
    <DebugSymbols>true</DebugSymbols>
    <DebugType>full</DebugType>
    <Optimize>false</Optimize>
    <OutputPath>bin\Debug\</OutputPath>
    <DefineConstants>DEBUG;TRACE</DefineConstants>
    <ErrorReport>prompt</ErrorReport>
    <WarningLevel>4</WarningLevel>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
    <DebugType>pdbonly</DebugType>
    <Optimize>true</Optimize>
    <OutputPath>bin\Release\</OutputPath>
    <DefineConstants>TRACE</DefineConstants>
    <ErrorReport>prompt</ErrorReport>
    <WarningLevel>4</WarningLevel>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="System" />
    <Reference Include="System.Core" />
    <!-- BepInEx Reference -->
    <Reference Include="BepInEx">
      <HintPath>..\libs\BepInEx.dll</HintPath>
      <Private>False</Private>
    </Reference>
    <!-- Unity References -->
    <Reference Include="UnityEngine">
      <HintPath>..\libs\UnityEngine.dll</HintPath>
      <Private>False</Private>
    </Reference>
    <Reference Include="UnityEngine.CoreModule">
      <HintPath>..\libs\UnityEngine.CoreModule.dll</HintPath>
      <Private>False</Private>
    </Reference>
    <!-- Add more Unity/Gorilla Tag DLLs here as needed -->
  </ItemGroup>
  <ItemGroup>
    <Compile Include="SpeedModPlugin.cs" />
    <Compile Include="Properties\AssemblyInfo.cs" />
  </ItemGroup>
  <Import Project="$(MSBuildToolsPath)\Microsoft.CSharp.targets" />
</Project>
'@

Set-Content -Path "$projectPath\$projectName\$projectName.csproj" -Value $csprojContent
Write-Host "Created $projectName.csproj" -ForegroundColor Green

# Create build.bat
$buildBat = @'
@echo off
echo ========================================
echo Building GTag Speed Mod
echo ========================================
echo.

REM Check if MSBuild exists
where msbuild >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: MSBuild not found!
    echo Please make sure Visual Studio 2022 is installed with .NET desktop development workload
    echo.
    echo You may need to run this from "Developer Command Prompt for VS 2022"
    pause
    exit /b 1
)

REM Build the project
echo Building project...
msbuild GTagSpeedMod\GTagSpeedMod.csproj /p:Configuration=Release /v:minimal

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo BUILD SUCCESSFUL!
    echo ========================================
    echo.
    echo Your mod DLL is located at:
    echo GTagSpeedMod\bin\Release\GTagSpeedMod.dll
    echo.
    echo Copy this file to:
    echo [Gorilla Tag Folder]\BepInEx\plugins\
    echo.
) else (
    echo.
    echo ========================================
    echo BUILD FAILED!
    echo ========================================
    echo Check the error messages above
    echo.
)

pause
'@

Set-Content -Path "$projectPath\build.bat" -Value $buildBat
Write-Host "Created build.bat" -ForegroundColor Green

# Create README with instructions
$readme = @'
# GTag Speed Mod - Setup Instructions

## What You Have
This project is a basic BepInEx mod for Gorilla Tag with a speed boost feature.
It includes a simple menu you can toggle with F1.

## Before You Can Build

### 1. Install BepInEx in Gorilla Tag
- Download BepInEx 5.x IL2CPP version from: https://github.com/BepInEx/BepInEx/releases
- Extract it into your Gorilla Tag game folder (where GorillaTag.exe is)
- Run Gorilla Tag once to generate BepInEx folders

### 2. Copy Required DLL Files
You need to copy these DLL files into the `libs` folder:

**From Gorilla Tag\BepInEx\core:**
- BepInEx.dll

**From Gorilla Tag\GorillaTag_Data\Managed:**
- UnityEngine.dll
- UnityEngine.CoreModule.dll
- Assembly-CSharp.dll (this contains Gorilla Tag's code)

Just copy these files into: D:\ProgrammingStuff\GTagMenu\libs\

### 3. Build the Mod
- Double-click `build.bat`
- OR open "Developer Command Prompt for VS 2022" and run `build.bat`
- OR open the .csproj file in Visual Studio and build there

### 4. Install Your Mod
After building successfully:
- Copy `GTagSpeedMod\bin\Release\GTagSpeedMod.dll`
- Paste it into `[Gorilla Tag Folder]\BepInEx\plugins\`
- Run Gorilla Tag

### 5. Use Your Mod
- Press F1 to open the menu
- Toggle speed boost on/off
- Adjust the speed multiplier

## Important Notes

### The Speed Boost Doesn't Work Yet!
The `ApplySpeedBoost()` function is a placeholder. You need to:
1. Find how Gorilla Tag's movement system works
2. Locate the player speed variables
3. Modify them correctly

This requires understanding Unity and the game's code structure.

### Learning Resources
- BepInEx documentation: https://docs.bepinex.dev/
- Unity scripting: https://docs.unity3d.com/ScriptReference/
- Gorilla Tag modding communities (Discord servers)

### Troubleshooting
**"MSBuild not found"**
- Run build.bat from "Developer Command Prompt for VS 2022"
- OR add MSBuild to your PATH

**"Reference not found" errors**
- Make sure you copied all DLL files to the libs folder
- Check that the file names match exactly

**Mod doesn't load in game**
- Check BepInEx\LogOutput.log for errors
- Make sure BepInEx is installed correctly
- Verify your mod DLL is in the plugins folder

## Next Steps for Learning
1. Study how the menu code works
2. Look at other Gorilla Tag mods to see how they modify movement
3. Experiment with adding new features
4. Join modding communities to learn from others

Remember: Modding is a great way to learn programming, but it takes time and practice!
'@

Set-Content -Path "$projectPath\README.txt" -Value $readme
Write-Host "Created README.txt" -ForegroundColor Green

# Create a quick reference guide
$quickRef = @'
QUICK REFERENCE - Understanding the Code

=== SpeedModPlugin.cs ===

ATTRIBUTES:
[BepInPlugin(...)] - Tells BepInEx about your mod (ID, name, version)

VARIABLES:
- bool modMenuEnabled: Turns the whole mod on/off
- bool speedBoostEnabled: Turns just the speed boost on/off  
- float speedMultiplier: How much faster you go (2.0 = twice as fast)
- Rect menuRect: Position and size of the menu window
- bool showMenu: Whether the menu is visible or not

FUNCTIONS:
- Awake(): Runs once when your mod loads (like a constructor)
- Update(): Runs every frame (60+ times per second)
- OnGUI(): Draws UI elements on the screen
- DrawMenu(): What goes inside the menu window
- ApplySpeedBoost(): Your custom code to make the player faster

UNITY INPUT:
Input.GetKeyDown(KeyCode.F1) - Checks if F1 was just pressed

UNITY GUI:
- GUI.Window() - Creates a draggable window
- GUILayout.Toggle() - Creates a checkbox
- GUILayout.Label() - Creates text
- GUILayout.HorizontalSlider() - Creates a slider
- GUILayout.Button() - Creates a button

=== What You Need to Learn ===

1. How to find the player object in Gorilla Tag
2. What component controls movement
3. Which variables control speed
4. How to modify them safely

Example pattern (pseudocode):
GameObject player = [find the player somehow];
MovementComponent movement = player.GetComponent<MovementComponent>();
movement.speed = baseSpeed * speedMultiplier;

=== Helpful Tips ===

- Use Logger.LogInfo("message") to debug
- Check BepInEx\LogOutput.log to see your messages
- Start small - get ONE thing working before adding more
- Read other people's mod source code to learn
- Ask in modding communities when stuck

'@

Set-Content -Path "$projectPath\QUICK_REFERENCE.txt" -Value $quickRef
Write-Host "Created QUICK_REFERENCE.txt" -ForegroundColor Green

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "PROJECT CREATED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nLocation: $projectPath" -ForegroundColor Yellow
Write-Host "`nNEXT STEPS:" -ForegroundColor Cyan
Write-Host "1. Read README.txt for full instructions" -ForegroundColor White
Write-Host "2. Copy required DLL files to the 'libs' folder" -ForegroundColor White
Write-Host "3. Run build.bat to compile" -ForegroundColor White
Write-Host "4. Copy the compiled DLL to BepInEx\plugins" -ForegroundColor White
Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")