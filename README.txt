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
