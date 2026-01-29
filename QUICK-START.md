# Quick Start - Get Your Mod Running Now

## Step 1: Build and Deploy (10 seconds)

**Double-click this file:**
```
REBUILD-NOW.bat
```

It will automatically:
- ✓ Find MSBuild
- ✓ Compile the mod
- ✓ Copy to BepInEx plugins folder

**If it says "game path not found":**
1. Right-click `REBUILD-NOW.bat` → Edit
2. Change line 6 to your actual Gorilla Tag path
3. Save and run again

---

## Step 2: Launch Gorilla Tag

1. Start Gorilla Tag from Steam
2. Wait for it to fully load (main menu or in-game)
3. You should see a BepInEx console window flash briefly

---

## Step 3: Test the Menu

### Try F1 Key First:
1. Press **F1** on your keyboard
2. Look at **top-left corner** of screen
3. Pink menu should appear with "Shmoresy Menu" title

### If F1 Works:
✓ Your mod is working!
✓ Input detection works!
✓ Only the hand anchor isn't found yet (that's fine)

### If F1 Doesn't Work:
Try controller buttons:
- Press **Y** on right controller
- Press **B** on right controller
- Press **X** or **A** on left controller

---

## Step 4: Check the Logs

Open this file:
```
C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag\BepInEx\LogOutput.log
```

### Search for these messages:

**Good signs (mod is working):**
```
[Info   :GTag Mod Menu] GTag Mod Menu v1.1.0 Loading...
[Info   :GTag Mod Menu] [Update] Update() is being called
[Info   :GTag Mod Menu] [OnGUI] First OnGUI call
[Info   :GTag Mod Menu] [Input] === Input Debug ===
```

**When you press a button:**
```
[Info   :GTag Mod Menu] [Input] Menu toggle detected: F1 key
[Info   :GTag Mod Menu] Menu toggled: True
```

---

## Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| Build fails | Run from "Developer Command Prompt for VS" |
| "BepInEx not found" | Install BepInEx 5.4.22 first (see BEPINEX_SETUP.md) |
| Menu doesn't appear | Check BepInEx\LogOutput.log for errors |
| F1 does nothing | See INPUT_TROUBLESHOOTING.md |
| Hand anchor not found | Normal! Menu appears in corner instead |

---

## Expected Result

When working correctly:

**On Screen:**
- Pink menu in top-left corner (or on hand if anchor found)
- Title: "Shmoresy Menu"
- List of mod options with [ON]/[OFF] toggles
- Slider for speed multiplier
- "Close" button at bottom

**In Logs (every 5 seconds):**
```
[Info   :GTag Mod Menu] [Input] === Input Debug ===
[Info   :GTag Mod Menu] [Input] F1 key: False
[Info   :GTag Mod Menu] [Input] Y key: False
[Info   :GTag Mod Menu] [Input] Joystick buttons detected: 2 controllers
[Info   :GTag Mod Menu] [Input] InputPoller found: ControllerInputPoller
[Info   :GTag Mod Menu] [Input] Current menu state: HIDDEN
```

---

## That's It!

1. **Run:** `REBUILD-NOW.bat`
2. **Launch:** Gorilla Tag
3. **Press:** F1 key
4. **See:** Pink menu appear

If it doesn't work, check the logs and see INPUT_TROUBLESHOOTING.md for detailed diagnosis.
