# BepInEx Installation & Troubleshooting Guide

## Quick Diagnosis: Is BepInEx Even Running?

### Step 1: Check Your Gorilla Tag Folder

Navigate to your Gorilla Tag installation folder:
```
C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag\
```

**You should see these folders:**
```
Gorilla Tag/
├── BepInEx/
│   ├── cache/
│   ├── config/
│   ├── core/
│   ├── plugins/           ← Your mod goes here
│   └── LogOutput.log      ← Log file (BepInEx 5.x)
├── doorstop_libs/
├── winhttp.dll            ← Important! BepInEx loader
└── GorillaTaggerVR.exe    ← The game
```

**If you DON'T see `BepInEx/` folder or `winhttp.dll`:**
→ BepInEx is NOT installed! See "Installing BepInEx" below.

### Step 2: Check the Correct Log Location

The log location depends on BepInEx version:

**BepInEx 5.x (most common):**
```
Gorilla Tag/BepInEx/LogOutput.log
```

**BepInEx 6.x:**
```
Gorilla Tag/BepInEx/logs/LogOutput.log
```

**Also check:**
```
%APPDATA%/../LocalLow/Another Axiom/Gorilla Tag/
```

### Step 3: Verify BepInEx Loaded

After launching the game once:

1. **Check if `LogOutput.log` exists** (in either location above)
   - If NO: BepInEx didn't run at all
   - If YES: BepInEx is working, but your mod might not be

2. **Open the log and search for "BepInEx"**
   ```
   [Info   :   BepInEx] BepInEx 5.4.22 - Gorilla Tag
   ```
   - If you see this: BepInEx loaded successfully
   - If not: BepInEx failed to load

3. **Search for "GTag Mod Menu"**
   ```
   [Info   :   GTag Mod Menu] GTag Mod Menu v1.1.0 Loading...
   ```
   - If you see this: Your mod loaded!
   - If not: Your mod didn't load (see "Mod Not Loading" below)

---

## Installing BepInEx (If Not Installed)

### Download BepInEx

1. Go to: https://github.com/BepInEx/BepInEx/releases
2. Download: **BepInEx_x64_5.4.22.0.zip** (or latest 5.4.x version)
   - ⚠️ Make sure it's the **x64** version!
   - ⚠️ For Gorilla Tag, use BepInEx **5.x**, NOT 6.x

### Install BepInEx

1. **Extract the ZIP** to your Gorilla Tag folder
   ```
   C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag\
   ```

2. **After extraction, you should have:**
   ```
   Gorilla Tag/
   ├── BepInEx/
   │   ├── config/
   │   ├── core/
   │   ├── patchers/
   │   └── plugins/        ← Empty folder (your mod will go here)
   ├── doorstop_libs/
   ├── winhttp.dll         ← This is the BepInEx loader
   ├── doorstop_config.ini
   └── changelog.txt
   ```

3. **Run the game once**
   - This generates the config files and log
   - You should see a console window flash (this is normal)
   - Close the game after it loads

4. **Verify BepInEx is working:**
   - Check that `BepInEx/LogOutput.log` was created
   - Open it and look for "BepInEx" in the first few lines

---

## Installing Your Mod

Once BepInEx is confirmed working:

1. **Build your mod** (if not already done):
   ```bash
   cd GTagSpeedMod
   msbuild GTagSpeedMod.csproj /p:Configuration=Release
   ```

2. **Copy the DLL** to BepInEx plugins folder:
   ```
   Copy from: GTagSpeedMod/bin/Release/GTagSpeedMod.dll
   Copy to: C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag\BepInEx\plugins\
   ```

3. **Folder structure should be:**
   ```
   Gorilla Tag/BepInEx/plugins/
   └── GTagSpeedMod.dll      ← Your mod
   ```

4. **Launch the game again**

5. **Check the log** (`BepInEx/LogOutput.log`):
   ```
   [Info   :   BepInEx] Loading [GTag Mod Menu 1.1.0]
   [Info   :   GTag Mod Menu] ========================================
   [Info   :   GTag Mod Menu] GTag Mod Menu v1.1.0 Loading...
   ```

---

## Common Issues

### Issue: "winhttp.dll is missing"

**Symptoms:** No BepInEx folder appears after extraction

**Solution:**
- Re-download BepInEx from official releases
- Make sure you downloaded **x64** version, not x86
- Extract directly to Gorilla Tag folder (not a subfolder)
- Disable antivirus temporarily (it might block winhttp.dll)

### Issue: Console window flashes but game crashes

**Symptoms:** Black console window appears then game closes

**Solution:**
- This usually means a mod is broken
- Remove all mods from `BepInEx/plugins/`
- Run the game with only BepInEx (no mods)
- If it works, add mods back one at a time

### Issue: LogOutput.log shows "Could not load GTagSpeedMod.dll"

**Symptoms:** Log shows errors about your mod

**Solution:**
- Check that all DLL dependencies are in the `libs/` folder when building
- Make sure you built for the correct .NET Framework version (4.7.2)
- Check for missing references in the build output

### Issue: No console window appears at all

**Symptoms:** Game runs normally, no BepInEx console

**Solution:**
1. Check `BepInEx/config/BepInEx.cfg`
2. Find this section:
   ```ini
   [Logging.Console]
   Enabled = true
   ```
3. Make sure `Enabled = true`
4. Save and restart the game

### Issue: Steam VR or Oculus gets in the way

**Symptoms:** Game won't launch or BepInEx doesn't load in VR

**Solution:**
- BepInEx works fine with VR
- Make sure you're launching the actual game executable, not through VR dashboard
- The menu should appear in-game, visible in VR headset
- Press controller buttons (Y/B) to toggle menu

---

## Verifying Everything Works

### Checklist:

- [ ] `winhttp.dll` exists in Gorilla Tag folder
- [ ] `BepInEx/` folder exists
- [ ] `BepInEx/plugins/` folder exists
- [ ] `GTagSpeedMod.dll` is in the plugins folder
- [ ] Game launches without crashing
- [ ] `BepInEx/LogOutput.log` is created after launching game
- [ ] Log contains "BepInEx 5.4.x - Gorilla Tag"
- [ ] Log contains "Loading [GTag Mod Menu 1.1.0]"
- [ ] Log contains "GTag Mod Menu v1.1.0 Loading..."
- [ ] Pressing F1/Y/B in-game shows something in the log

---

## Finding Your Gorilla Tag Folder

If you're not sure where Gorilla Tag is installed:

### Method 1: Steam
1. Open Steam
2. Right-click "Gorilla Tag"
3. Properties → Local Files → "Browse..."
4. This opens your Gorilla Tag folder

### Method 2: Default Path
Usually it's:
```
C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag\
```

### Method 3: Custom Steam Library
If you have multiple Steam libraries:
```
<Your Steam Library>\steamapps\common\Gorilla Tag\
```

---

## Getting Help

If you've followed all steps and it still doesn't work, please provide:

1. **Screenshot of your Gorilla Tag folder** showing:
   - BepInEx folder (if it exists)
   - winhttp.dll (if it exists)
   - GorillaTaggerVR.exe

2. **Contents of BepInEx/plugins/** folder

3. **First 100 lines of LogOutput.log** (if it exists)

4. **Build output** from compiling your mod

5. **Error messages** if any appear

Post this info and we can help diagnose the issue!

---

## Quick Reference

| You See... | Meaning | Next Step |
|------------|---------|-----------|
| No `BepInEx/` folder | BepInEx not installed | Install BepInEx (see above) |
| No `winhttp.dll` | BepInEx not installed | Install BepInEx (see above) |
| No `LogOutput.log` | BepInEx didn't run | Check config, re-install |
| Log exists but empty | BepInEx crashed | Remove all mods, try again |
| Log shows BepInEx but not your mod | Mod didn't load | Check DLL is in plugins/ |
| Log shows "Could not load" error | Build issue | Check dependencies |
| Everything in log but no menu | Input/rendering issue | See DEBUG_GUIDE.md |

---

## Alternative: Test BepInEx with Another Mod

To verify BepInEx is working, try installing a known-working mod:

1. Download "Computer Interface" or "Gorilla Cosmetics"
2. Put the DLL in `BepInEx/plugins/`
3. Launch game and check if that mod works
4. If it does, the problem is with your mod specifically
5. If it doesn't, BepInEx isn't set up correctly
