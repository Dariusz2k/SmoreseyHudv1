# BepInEx Not Loading - Diagnostic Checklist

## The Problem

Your game logs show **NO BepInEx messages**, which means BepInEx is not running at all.

A properly working BepInEx installation should show logs like:
```
[Info   :   BepInEx] BepInEx 5.4.22 - Gorilla Tag
[Info   :   BepInEx] Loading [GTag Mod Menu 1.1.0]
```

Your logs just show Unity/game initialization - BepInEx never loaded.

---

## Step-by-Step Diagnostic

### Step 1: Verify BepInEx Files Exist

Open your Gorilla Tag installation folder:
```
C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag\
```

**Check these files/folders exist:**

- [ ] `winhttp.dll` file in root folder ← **CRITICAL**
- [ ] `BepInEx/` folder
- [ ] `BepInEx/core/` folder with DLL files
- [ ] `BepInEx/plugins/` folder
- [ ] `doorstop_libs/` folder
- [ ] `doorstop_config.ini` file

**If ANY of these are missing:**
- BepInEx is NOT properly installed
- Download BepInEx 5.4.22 x64 from: https://github.com/BepInEx/BepInEx/releases
- Extract it DIRECTLY to your Gorilla Tag folder (not a subfolder)

---

### Step 2: Check BepInEx Configuration

Open `BepInEx/config/BepInEx.cfg` and verify:

```ini
[Logging.Console]
## Enables showing a console for log output.
# Setting type: Boolean
# Default value: false
Enabled = true    ← Should be "true"
```

**If this file doesn't exist:**
- BepInEx has never run
- Launch the game once to generate configs
- Close the game after it loads
- Then check again

---

### Step 3: Check for BepInEx Log File

Look for the BepInEx log in these locations:

**BepInEx 5.x:**
```
Gorilla Tag/BepInEx/LogOutput.log
```

**BepInEx 6.x:**
```
Gorilla Tag/BepInEx/logs/LogOutput.log
```

**If this file doesn't exist:**
- BepInEx never ran
- This confirms the problem
- Continue to Step 4

**If this file exists:**
- Open it and check if it says "BepInEx" anywhere
- If yes: BepInEx IS working (see "Mod Not Loading" section)
- If no or empty: BepInEx crashed during startup

---

### Step 4: Verify Game Executable

Make sure you're running the RIGHT executable:

**Correct:**
```
Gorilla Tag/Gorilla Tag.exe  (or GorillaTaggerVR.exe)
```

**From Steam:**
- Right-click Gorilla Tag in Steam
- Click "Play"
- Make sure it's launching the main executable, not through SteamVR

**Wrong:**
- Running through Oculus/Meta launcher directly
- Running a shortcut that bypasses Steam

---

### Step 5: Check Antivirus

Some antivirus software blocks BepInEx's `winhttp.dll`:

1. Open Windows Security → Virus & threat protection
2. Check "Protection history"
3. Look for any blocked files related to `winhttp.dll`
4. If found, add exclusion:
   - Settings → Virus & threat protection → Exclusions
   - Add folder: `C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag`

---

## Building & Installing Your Mod

Once BepInEx is confirmed working, build and install your mod:

### Step 1: Build the Mod

Open a Developer Command Prompt (or regular cmd with Visual Studio) and run:

```batch
cd /path/to/SmoreseyHudv1/GTagSpeedMod
msbuild GTagSpeedMod.csproj /p:Configuration=Release
```

**Expected output:**
```
Build succeeded.
    0 Warning(s)
    0 Error(s)
```

**Output location:**
```
SmoreseyHudv1/GTagSpeedMod/bin/Release/GTagSpeedMod.dll
```

### Step 2: Deploy the Mod

Copy the DLL to BepInEx plugins:

```batch
copy "SmoreseyHudv1\GTagSpeedMod\bin\Release\GTagSpeedMod.dll" "C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag\BepInEx\plugins\"
```

**Or use the provided deployment script:**
```batch
.\Deploy.ps1
```

### Step 3: Verify Installation

Your plugins folder should look like:
```
Gorilla Tag/BepInEx/plugins/
└── GTagSpeedMod.dll  ← Your mod
```

---

## Testing

### Test 1: BepInEx Loads

1. Launch Gorilla Tag
2. You should see a **black console window** flash briefly (this is BepInEx)
3. Let the game fully load
4. Close the game
5. Check `BepInEx/LogOutput.log` exists
6. Open it and search for "BepInEx" - you should see:
   ```
   [Info   :   BepInEx] BepInEx 5.4.22 - Gorilla Tag
   ```

**If you don't see this:** BepInEx is still not loading. Go back to Step 1.

### Test 2: Your Mod Loads

1. Open `BepInEx/LogOutput.log`
2. Search for "GTag Mod Menu"
3. You should see:
   ```
   [Info   :   BepInEx] Loading [GTag Mod Menu 1.1.0]
   [Info   :   GTag Mod Menu] ========================================
   [Info   :   GTag Mod Menu] GTag Mod Menu v1.1.0 Loading...
   [Info   :   GTag Mod Menu] ========================================
   ```

**If you see this:** Your mod loaded successfully!

**If you don't see this:**
- Check that `GTagSpeedMod.dll` is in `BepInEx/plugins/`
- Look for error messages in the log
- Check if there are any "Could not load" errors

### Test 3: Menu Works

1. Launch the game and join a room
2. Press `F1` or `Y` on your controller
3. Check the log for:
   ```
   [Info   :   GTag Mod Menu] Menu toggled: True
   ```
4. You should see the menu appear (either on your hand or top-left corner)

---

## Common Issues

### Issue: No Console Window Appears

**Cause:** `BepInEx.cfg` has console disabled

**Fix:**
1. Edit `BepInEx/config/BepInEx.cfg`
2. Change `Enabled = false` to `Enabled = true` under `[Logging.Console]`
3. Save and relaunch

### Issue: "winhttp.dll not found" or game won't start

**Cause:** Antivirus blocked or deleted `winhttp.dll`

**Fix:**
1. Restore from quarantine
2. Add Gorilla Tag folder to antivirus exclusions
3. Re-extract BepInEx

### Issue: BepInEx log shows "Could not load plugin"

**Cause:** Mod has missing dependencies

**Fix:**
1. Check the log for specific missing DLL names
2. Make sure all required Unity/Gorilla Tag DLLs are in your `libs/` folder
3. Rebuild the mod

### Issue: Log shows mod loaded but menu doesn't appear

**Cause:** Input or rendering issue (separate from BepInEx)

**Fix:**
- See `DEBUG_GUIDE.md` for detailed troubleshooting
- Check that OnGUI is being called
- Try pressing different buttons (F1, Y, B, all joystick buttons)

---

## Quick Test: Install Another Mod

To verify BepInEx works at all:

1. Download a known-working mod (like "Computer Interface")
2. Put it in `BepInEx/plugins/`
3. Launch the game
4. If that mod works: BepInEx is fine, problem is with your mod
5. If that mod doesn't work: BepInEx isn't set up correctly

---

## What to Report

If none of this works, report the following:

### Required Information:

1. **Screenshot of your Gorilla Tag folder** showing:
   - Root folder contents (winhttp.dll visible?)
   - BepInEx folder structure
   - BepInEx/plugins/ contents

2. **Full contents of `BepInEx/LogOutput.log`** (if it exists)
   - Or state "LogOutput.log does not exist"

3. **Your setup:**
   - Windows version
   - Gorilla Tag installed from Steam or Oculus?
   - Any antivirus software running?
   - Have you modified any game files?

4. **What you tried:**
   - List the steps you followed
   - What error messages you saw

---

## Expected Final State

When everything is working, you should see:

**Game Launch:**
```
- Black console window flashes (BepInEx loading)
- Game launches normally
- No error messages
```

**BepInEx/LogOutput.log:**
```
[Message:   BepInEx] BepInEx 5.4.22.0 - Gorilla Tag (11/29/2023 6:25:13 PM)
[Info   :   BepInEx] Running under Unity v6000.2.9.0
[Info   :   BepInEx] CLR runtime version: 4.0.30319.42000
[Info   :   BepInEx] Startup directory: C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag
[Message:   BepInEx] Preloader started
[Info   :   BepInEx] Loading [GTag Mod Menu 1.1.0]
[Info   :   GTag Mod Menu] ========================================
[Info   :   GTag Mod Menu] GTag Mod Menu v1.1.0 Loading...
[Info   :   GTag Mod Menu] ========================================
```

**In-Game:**
```
- Press F1 or Y button
- Menu appears (hand-anchored or top-left corner)
- Can interact with menu options
```

---

## Success Checklist

- [ ] `winhttp.dll` exists in Gorilla Tag folder
- [ ] BepInEx folders and files exist
- [ ] Console window appears briefly when launching game
- [ ] `BepInEx/LogOutput.log` is created
- [ ] Log shows "BepInEx 5.4.x" messages
- [ ] Log shows "Loading [GTag Mod Menu 1.1.0]"
- [ ] Log shows mod startup messages
- [ ] Pressing F1/Y shows "Menu toggled: True" in log
- [ ] Menu appears in-game

---

Good luck! Follow this checklist step by step, and you'll find where the problem is.
