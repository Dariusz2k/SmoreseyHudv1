# GTag Speed Mod - Setup Guide

This guide will help you set up your development environment for building GTag mods.

## Quick Start

1. **Run the build menu**:
   ```batch
   build.bat
   ```

2. **Restore NuGet packages**
   - BepInEx is restored via NuGet using the `NuGet.config` source.
   - `build.bat` runs MSBuild with restore automatically.

3. **Extract Unity DLLs** (GTag Manager)
   - Use the GTag Manager to locate and extract Unity DLLs from Gorilla Tag

4. **Build your mod** (Option 2 from the menu)
   - This will compile your mod into a DLL file

## Required Dependencies

### BepInEx Assemblies (NuGet)
These are restored via NuGet (BepInEx dev feed):
- `BepInEx.Core` `6.0.0-be.1` - dev build from the BepInEx feed
- `0Harmony` - Harmony patching library (nuget.org)

### Unity Assemblies
These must be extracted from your Gorilla Tag installation:
- `UnityEngine.dll`
- `UnityEngine.CoreModule.dll`
- `UnityEngine.IMGUIModule.dll` (optional, for UI)

### Gorilla Tag Assemblies
Optional, but useful for accessing game-specific code:
- `Assembly-CSharp.dll` - Contains Gorilla Tag game code

## Manual Setup

If you prefer to restore packages manually:

```powershell
dotnet restore GTagSpeedMod\GTagSpeedMod.csproj
```

## Troubleshooting

### Build Error: "BaseUnityPlugin could not be found"
- **Cause**: NuGet packages were not restored or the dev feed is unavailable.
- **Solution**: Run `dotnet restore GTagSpeedMod\GTagSpeedMod.csproj`, then rebuild.

### Build Error: "UnityEngine could not be found"
- **Cause**: Missing Unity DLLs
- **Solution**: Use GTag Manager to extract Unity DLLs from Gorilla Tag

### BepInEx download fails
- **Cause**: Network issues or NuGet source access
- **Solution**:
  1. Ensure `NuGet.config` includes `https://nuget.bepinex.dev/v3/index.json`
  2. Re-run `dotnet restore`

## Installing and Configuring BepInEx (Game Runtime)

1. Install BepInEx in your Gorilla Tag install (see `BEPINEX_SETUP.md`).
2. Run the game with BepInEx at least once to generate configuration files.
3. Enable the BepInEx console for easier debugging:

```
[Logging.Console]
Enabled = true
```

You can set this in `BepInEx/config/BepInEx.cfg`.

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
├── setup-bepinex.ps1        # BepInEx template installer
├── GTagManager.ps1          # GUI tool for game setup
├── libs/                    # Dependencies folder
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
