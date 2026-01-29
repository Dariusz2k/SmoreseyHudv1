# Input Detection Troubleshooting

## Problem
BepInEx is loading and your mod is loading, but pressing Y/B doesn't show the menu.

## What I Changed

I've added **extensive debug logging** to track exactly what's happening:

### New Debug Features:

1. **Update() Confirmation**
   - Logs once when Update() starts running
   - Confirms the mod is actively processing input

2. **Input State Debug (Every 5 seconds)**
   - Shows which keys/buttons are currently pressed
   - Shows if ControllerInputPoller is found
   - Shows current menu state
   - Logs: `[Input] === Input Debug ===`

3. **Detailed Input Detection**
   - Logs EXACTLY which button triggered the menu
   - Examples:
     - `[Input] Menu toggle detected: F1 key`
     - `[Input] Menu toggle detected: Right Controller Primary Button (Y)`
     - `[Input] Menu toggle detected: JoystickButton3`

## How to Test

### Step 1: Rebuild the Mod

**On Windows (Developer Command Prompt):**
```batch
cd SmoreseyHudv1
build-and-deploy.bat
```

**Manual build:**
```batch
cd SmoreseyHudv1\GTagSpeedMod
msbuild GTagSpeedMod.csproj /p:Configuration=Release
copy bin\Release\GTagSpeedMod.dll "C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag\BepInEx\plugins\"
```

### Step 2: Launch Gorilla Tag

1. Start Gorilla Tag
2. Let it fully load into the main menu or a room
3. Wait for the BepInEx console to disappear

### Step 3: Check the Logs

Open `BepInEx/LogOutput.log` and look for these messages:

#### Expected Startup Logs:
```
[Info   :GTag Mod Menu] GTag Mod Menu v1.1.0 Loading...
[Info   :GTag Mod Menu] [Update] Update() is being called - mod is active
[Info   :GTag Mod Menu] [OnGUI] First OnGUI call - rendering system is active
```

**If you see these three lines:** The mod core is working!

#### Input Debug Logs (every 5 seconds):
```
[Info   :GTag Mod Menu] [Input] === Input Debug ===
[Info   :GTag Mod Menu] [Input] F1 key: False
[Info   :GTag Mod Menu] [Input] Y key: False
[Info   :GTag Mod Menu] [Input] B key: False
[Info   :GTag Mod Menu] [Input] Joystick buttons detected: 2 controllers
[Info   :GTag Mod Menu] [Input] InputPoller found: ControllerInputPoller
[Info   :GTag Mod Menu] [Input]   rightControllerPrimaryButton: False
[Info   :GTag Mod Menu] [Input]   rightControllerSecondaryButton: False
[Info   :GTag Mod Menu] [Input]   leftControllerPrimaryButton: False
[Info   :GTag Mod Menu] [Input]   leftControllerSecondaryButton: False
[Info   :GTag Mod Menu] [Input] Current menu state: HIDDEN
[Info   :GTag Mod Menu] [Input] === Press Y/B button on controller or F1 on keyboard to toggle ===
```

### Step 4: Test Input Detection

While the game is running:

**Test 1: Try F1 key on keyboard**
- Press F1
- Check log for: `[Input] Menu toggle detected: F1 key`
- Then: `Menu toggled: True`

**Test 2: Try Y button on RIGHT controller**
- Press Y on your right controller
- Check log for: `[Input] Menu toggle detected: Right Controller Primary Button (Y)`
- Then: `Menu toggled: True`

**Test 3: Try B button on RIGHT controller**
- Press B on your right controller
- Check log for: `[Input] Menu toggle detected: Right Controller Secondary Button (B)`
- Then: `Menu toggled: True`

**Test 4: Try any controller button**
- Press any button on either controller
- Check if ANY joystick button logs appear

## Diagnosis Guide

### Scenario 1: NO Update() Log
**Symptoms:**
- No `[Update] Update() is being called` message

**Meaning:**
- BepInEx loaded the plugin but Unity isn't calling Update()
- The mod isn't actually running

**Solutions:**
- Check if the mod DLL is in the correct location
- Verify BepInEx loaded the plugin (look for `Loading [GTag Mod Menu 1.1.0]`)
- Check for errors in the log

---

### Scenario 2: NO OnGUI() Log
**Symptoms:**
- `[Update]` logs appear
- No `[OnGUI] First OnGUI call` message

**Meaning:**
- The mod is running but Unity isn't calling OnGUI
- The rendering system isn't active

**Solutions:**
- Wait longer (OnGUI might be delayed)
- Make sure you're in-game (not on loading screen)
- Check for errors related to rendering

---

### Scenario 3: Update() and OnGUI() Work, But NO Input Detection
**Symptoms:**
- Both `[Update]` and `[OnGUI]` logs appear
- Input debug logs show every 5 seconds
- But pressing buttons does nothing

**Check the input debug logs:**

**If `InputPoller NOT found`:**
```
[Input] InputPoller NOT found - will search for ControllerInputPoller
```
- Gorilla Tag's input system isn't loaded yet
- Wait for the game to fully load
- Try pressing F1 on keyboard as fallback

**If `Joystick buttons detected: 0 controllers`:**
```
[Input] Joystick buttons detected: 0 controllers
```
- Your VR controllers aren't recognized by Unity Input
- This is NORMAL for some VR setups
- The mod will use ControllerInputPoller instead

**If all buttons show `False`:**
```
[Input]   rightControllerPrimaryButton: False
[Input]   rightControllerSecondaryButton: False
```
- You're not pressing buttons when debug runs (it only logs every 5 seconds)
- Try pressing buttons repeatedly or holding them
- Try the keyboard F1 key instead

---

### Scenario 4: Input Detected But Menu Doesn't Show
**Symptoms:**
- Logs show: `[Input] Menu toggle detected: F1 key`
- Logs show: `Menu toggled: True`
- But you don't see anything on screen

**This means:**
- Input detection WORKS ✓
- Menu state toggled ✓
- BUT rendering failed ✗

**Check for:**
1. Hand anchor issues:
   ```
   [HandAnchor] No hand anchor found after searching all methods
   ```
   This is OK - menu should appear in TOP-LEFT corner as fallback

2. OnGUI issues - look for errors after the toggle

3. Try pressing F1 twice (toggle off then on again)

4. Look at the TOP-LEFT corner of your screen (fallback mode)

---

### Scenario 5: Menu Shows in Top-Left Corner
**Symptoms:**
- Menu appears but in corner, not on hand

**This is NORMAL and means:**
- Everything works! ✓
- Hand anchor not found yet
- Menu is in fallback mode

**This is fine!** You can use the menu. Eventually the hand anchor will be found and it will attach to your hand.

---

## Expected Working State

When everything works correctly, you'll see:

**In BepInEx/LogOutput.log:**
```
[Info   :   BepInEx] BepInEx 5.4.23.4 - Gorilla Tag
[Info   :   BepInEx] Loading [GTag Mod Menu 1.1.0]
[Info   :GTag Mod Menu] GTag Mod Menu v1.1.0 Loading...
[Info   :GTag Mod Menu] [Update] Update() is being called - mod is active
[Info   :GTag Mod Menu] [OnGUI] First OnGUI call - rendering system is active

--- every 5 seconds ---
[Info   :GTag Mod Menu] [Input] === Input Debug ===
[Info   :GTag Mod Menu] [Input] InputPoller found: ControllerInputPoller
[Info   :GTag Mod Menu] [Input] Current menu state: HIDDEN

--- when you press Y ---
[Info   :GTag Mod Menu] [Input] Menu toggle detected: Right Controller Primary Button (Y)
[Info   :GTag Mod Menu] Menu toggled: True
[Info   :GTag Mod Menu] [Debug] ========== Menu toggle pressed ==========
[Info   :GTag Mod Menu] [Debug] Menu Visible: True
```

**On Screen:**
- Pink menu appears (either on hand or top-left corner)
- Shows "Shmoresy Menu" title
- List of mod options
- "Close" button at bottom

---

## Quick Test: Force Menu to Show

If you want to verify OnGUI is working without dealing with input:

1. Edit `SpeedModPlugin.cs`
2. Find the `Awake()` method
3. After `LogDebugState("Initial startup");` add:
   ```csharp
   showMenu = true; // Force menu visible for testing
   Logger.LogInfo("[TEST] Menu forced to visible for testing");
   ```
4. Rebuild and deploy
5. Launch game
6. Menu should appear immediately (top-left corner)

If this works:
- ✓ OnGUI is working
- ✓ Rendering is working
- ✗ Only input detection is the issue

---

## Alternative Input Methods

If controller input doesn't work, you can modify the input detection:

### Option 1: Keyboard-Only Mode

Change `IsMenuTogglePressed()` to only check keyboard:
```csharp
private bool IsMenuTogglePressed()
{
    if (Input.GetKeyDown(KeyCode.F1))
    {
        Logger.LogInfo("[Input] Menu toggle detected: F1 key");
        return true;
    }
    return false;
}
```

Use F1 key exclusively.

### Option 2: Always-On Menu

Set menu to always visible:
```csharp
void Awake()
{
    // ... existing code ...
    showMenu = true; // Menu always visible
}
```

Remove the toggle entirely.

---

## What to Report

If none of this helps, provide:

1. **Full BepInEx/LogOutput.log** (especially startup and first 30 seconds)

2. **Screenshots** of:
   - Your screen when you press Y
   - BepInEx plugins folder showing GTagSpeedMod.dll

3. **Specific answers:**
   - Do you see `[Update] Update() is being called`? (Yes/No)
   - Do you see `[OnGUI] First OnGUI call`? (Yes/No)
   - Do you see `[Input] === Input Debug ===` every 5 seconds? (Yes/No)
   - When you press F1, do you see `Menu toggle detected`? (Yes/No)
   - What does the input debug show for `InputPoller found`?

4. **Your setup:**
   - VR headset model
   - Playing through Steam or Oculus?
   - Keyboard connected?

---

## Summary

The new logging will tell us EXACTLY where the problem is:

| Log Present? | Meaning |
|--------------|---------|
| `[Update]` ✓ | Mod is running |
| `[OnGUI]` ✓ | Rendering is active |
| `[Input] ===` ✓ | Input system is checking |
| `InputPoller found` ✓ | VR controller input available |
| `Menu toggle detected` ✓ | Button press detected |
| `Menu toggled: True` ✓ | Menu state changed |
| Menu appears ✓ | EVERYTHING WORKS! |

Work through this checklist and you'll find the issue!
