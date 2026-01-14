# GTag Speed Mod - Setup Guide

This guide will help you set up your development environment for building GTag mods.

## Quick Start

1. **Run the build menu**:
   ```batch
   build.bat
   ```

2. **Install BepInEx dependencies** (Option 4 from the menu)
   - This will automatically download and install required BepInEx assemblies
   - Includes: BepInEx.dll, BepInEx.Core.dll, 0Harmony.dll, etc.

3. **Extract Unity DLLs** (Option 3 from the menu - GTag Manager)
   - Use the GTag Manager to locate and extract Unity DLLs from Gorilla Tag

4. **Build your mod** (Option 2 from the menu)
   - This will compile your mod into a DLL file

## Required Dependencies

### BepInEx Assemblies
These are automatically downloaded by the setup script:
- `BepInEx.dll` - Core BepInEx loader
- `BepInEx.Core.dll` - Contains `BaseUnityPlugin` class
- `0Harmony.dll` - Harmony patching library

### Unity Assemblies
These must be extracted from your Gorilla Tag installation:
- `UnityEngine.dll`
- `UnityEngine.CoreModule.dll`
- `UnityEngine.IMGUIModule.dll` (optional, for UI)

### Gorilla Tag Assemblies
Optional, but useful for accessing game-specific code:
- `Assembly-CSharp.dll` - Contains Gorilla Tag game code

## Manual Setup

If you prefer to set up dependencies manually:

### Option 1: Use the automated script
```powershell
powershell -ExecutionPolicy Bypass -File setup-bepinex.ps1
```

### Option 2: Manual download
1. Download BepInEx from [GitHub Releases](https://github.com/BepInEx/BepInEx/releases)
2. Extract the archive
3. Copy these files from `BepInEx/core/` to the `libs/` folder:
   - BepInEx.dll
   - BepInEx.Core.dll
   - 0Harmony.dll

4. Copy Unity DLLs from your Gorilla Tag installation:
   - Usually located at: `[Steam]\steamapps\common\Gorilla Tag\Gorilla Tag_Data\Managed\`
   - Copy the required DLLs to the `libs/` folder

## Troubleshooting

### Build Error: "BaseUnityPlugin could not be found"
- **Cause**: Missing BepInEx.Core.dll
- **Solution**: Run option 4 from the build menu to install BepInEx dependencies

### Build Error: "UnityEngine could not be found"
- **Cause**: Missing Unity DLLs
- **Solution**: Use option 3 (GTag Manager) to extract Unity DLLs from Gorilla Tag

### BepInEx download fails
- **Cause**: Network issues or GitHub rate limiting
- **Solution**:
  1. Download manually from [BepInEx Releases](https://github.com/BepInEx/BepInEx/releases/latest)
  2. Extract and copy DLLs to `libs/` folder as described above

## Project Structure

```
SmoreseyHudv1/
├── build.bat                 # Interactive build menu
├── setup-bepinex.ps1        # BepInEx dependency installer
├── GTagManager.ps1          # GUI tool for game setup
├── libs/                    # Dependencies folder
│   ├── BepInEx.dll
│   ├── BepInEx.Core.dll
│   ├── 0Harmony.dll
│   ├── UnityEngine.dll
│   └── UnityEngine.CoreModule.dll
└── GTagSpeedMod/            # Your mod source code
    ├── GTagSpeedMod.csproj
    └── SpeedModPlugin.cs
```

## Building Your Mod

Once all dependencies are installed:

1. Open `build.bat` and select option 2
2. The build process will:
   - Check for all required dependencies
   - Compile your mod
   - Output the DLL to `GTagSpeedMod\bin\Release\GTagSpeedMod.dll`

3. Copy the output DLL to:
   ```
   [Gorilla Tag Installation]\BepInEx\plugins\GTagSpeedMod.dll
   ```

## Next Steps

- Edit `SpeedModPlugin.cs` to implement your mod features
- Test your mod in Gorilla Tag
- Commit and push your changes

## Support

For issues or questions:
- Check the build.log file for detailed error information
- Ensure all dependencies are present in the libs folder
- Verify your Gorilla Tag installation path in GTag Manager
