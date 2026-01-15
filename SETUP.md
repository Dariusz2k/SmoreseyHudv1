# GTag Speed Mod - Setup Guide

This guide will help you set up your development environment for building GTag mods.

## Quick Start

1. **Run the build menu**:
   ```batch
   build.bat
   ```

2. **Install BepInEx development dependencies** (Option 4 from the menu)
   - This will automatically download and install required BepInEx 5.x *development* assemblies
   - Includes: BepInEx.dll, 0Harmony.dll, Mono.Cecil.dll, MonoMod.RuntimeDetour.dll, MonoMod.Utils.dll

3. **Extract Unity DLLs** (Option 3 from the menu - GTag Manager)
   - Use the GTag Manager to locate and extract Unity DLLs from Gorilla Tag

4. **Build your mod** (Option 2 from the menu)
   - This will compile your mod into a DLL file

## Required Dependencies

### BepInEx Assemblies (Dev DLLs)
These are automatically downloaded by the setup script (BepInEx 5.x dev build):
- `BepInEx.dll` - Development assembly (contains `BepInEx.BaseUnityPlugin`)
- `0Harmony.dll` - Harmony patching library
- Additional support DLLs (Mono.Cecil, MonoMod, etc.)

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
1. Download the **DEV** BepInEx 5.x zip from [GitHub Releases](https://github.com/BepInEx/BepInEx/releases)
2. Extract the archive
3. Copy these files from `BepInEx/core/` to the `libs/` folder:
   - BepInEx.dll (contains BaseUnityPlugin for BepInEx 5.x dev builds)
   - 0Harmony.dll
   - Other support DLLs as needed

4. Copy Unity DLLs from your Gorilla Tag installation:
   - Usually located at: `[Steam]\steamapps\common\Gorilla Tag\Gorilla Tag_Data\Managed\`
   - Copy the required DLLs to the `libs/` folder

## Troubleshooting

### Build Error: "BaseUnityPlugin could not be found"
- **Cause**: The `libs/BepInEx.dll` is from a runtime/source build instead of the **dev** build.
- **Solution**: Run option 4 from the build menu to install the BepInEx 5.x development DLLs.
- **Note**: In BepInEx 5.x, `BaseUnityPlugin` lives in `BepInEx.dll` (BepInEx.Core.dll is a 6.x assembly).

### Build Error: "UnityEngine could not be found"
- **Cause**: Missing Unity DLLs
- **Solution**: Use option 3 (GTag Manager) to extract Unity DLLs from Gorilla Tag

### BepInEx download fails
- **Cause**: Network issues or GitHub rate limiting
- **Solution**:
  1. Download the **DEV** zip manually from [BepInEx Releases](https://github.com/BepInEx/BepInEx/releases/latest)
  2. Extract and copy DLLs to `libs/` folder as described above

## Installing BepInEx Plugin Templates (Optional)

If you want to scaffold new plugins with `dotnet new`, install the BepInEx templates:

```bash
dotnet new install BepInEx.Templates::2.0.0-be.4 --nuget-source https://nuget.bepinex.dev/v3/index.json
```

You should then see templates such as:
- **BepInEx 5 Plugin** (`bepinex5plugin`)
- **BepInEx 6 .NET Core Plugin** (`bep6plugin_coreclr`)
- **BepInEx 6 .NET Framework Plugin** (`bep6plugin_netfx`)
- **BepInEx 6 Unity Il2Cpp Plugin** (`bep6plugin_unity_il2cpp`)
- **BepInEx 6 Unity Mono Plugin** (`bep6plugin_unity_mono`)

## Project Structure

```
SmoreseyHudv1/
├── build.bat                 # Interactive build menu
├── setup-bepinex.ps1        # BepInEx dependency installer
├── GTagManager.ps1          # GUI tool for game setup
├── libs/                    # Dependencies folder
│   ├── BepInEx.dll
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
