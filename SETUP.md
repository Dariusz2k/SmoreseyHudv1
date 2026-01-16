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
These are automatically downloaded by the setup script (BepInEx 5.x):
- `BepInEx.dll` - Core BepInEx loader (contains `BaseUnityPlugin` class)
- `0Harmony.dll` - Harmony patching library
- Additional support DLLs (Mono.Cecil, MonoMod, etc.)

### Unity Assemblies
These must be extracted from your Gorilla Tag installation:
- `UnityEngine.dll`
- `UnityEngine.CoreModule.dll`
- `UnityEngine.IMGUIModule.dll` (optional, for UI)

### Gorilla Tag Assemblies
Required for accessing game-specific code and Photon networking:
- `Assembly-CSharp.dll` - Contains Gorilla Tag game code
- `PhotonRealtime.dll` - Photon networking library
- `Photon3Unity3D.dll` - Photon Unity integration
- `PhotonUnityNetworking.dll` - Photon PUN framework
- `PhotonVoice.dll` - Photon voice chat library
- `ExitGames.Client.Photon.dll` - ExitGames networking library
- `PhotonChat.dll` - Photon chat functionality

**Note**: These DLLs are located in your Gorilla Tag installation at:
`[Steam]\steamapps\common\Gorilla Tag\Gorilla Tag_Data\Managed\`

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
   - BepInEx.dll (contains BaseUnityPlugin for BepInEx 5.x)
   - 0Harmony.dll
   - Other support DLLs as needed

4. Copy Unity DLLs from your Gorilla Tag installation:
   - Usually located at: `[Steam]\steamapps\common\Gorilla Tag\Gorilla Tag_Data\Managed\`
   - Copy the required DLLs to the `libs/` folder

## Troubleshooting

### Build Error: "BaseUnityPlugin could not be found"
- **Cause**: Missing BepInEx.dll or incorrect reference
- **Solution**: Run option 4 from the build menu to install BepInEx dependencies
- **Note**: In BepInEx 5.x, BaseUnityPlugin is in BepInEx.dll (not BepInEx.Core.dll which is only in 6.x)

### Build Error: "UnityEngine could not be found"
- **Cause**: Missing Unity DLLs
- **Solution**: Use option 3 (GTag Manager) to extract Unity DLLs from Gorilla Tag

### Build Error: "Unable to find package PhotonRealtime" or "Unable to find package PhotonVoice"
- **Cause**: Photon DLLs are not available as NuGet packages
- **Solution**:
  1. Use the GTagManager GUI: Click "Copy Dev Libraries" button in Step 2
  2. OR manually navigate to: `[Steam]\steamapps\common\Gorilla Tag\Gorilla Tag_Data\Managed\`
  3. Copy these DLLs to the `libs/` folder:
     - PhotonRealtime.dll
     - Photon3Unity3D.dll
     - PhotonUnityNetworking.dll
     - PhotonVoice.dll
     - ExitGames.Client.Photon.dll
     - PhotonChat.dll
  4. The project will now compile successfully

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
