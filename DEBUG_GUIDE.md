# Debug Guide for GTag Mod Menu

## Where to Find Logs

BepInEx automatically creates log files when your mod runs. The logs are located at:

```
<GameFolder>/BepInEx/LogOutput.log
```

For Gorilla Tag, this is typically:
```
C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag\BepInEx\LogOutput.log
```

## How to View Logs

### Option 1: Real-Time Monitoring (Recommended)
Open a command prompt and run:
```bash
tail -f "C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag\BepInEx\LogOutput.log"
```

Or on Windows PowerShell:
```powershell
Get-Content "C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag\BepInEx\LogOutput.log" -Wait -Tail 50
```

### Option 2: Open in Text Editor
Just open the `LogOutput.log` file in Notepad, Notepad++, or VS Code and refresh periodically.

## What to Look For

### Startup Logs
When the mod loads, you should see:
```
[Info   :   GTag Mod Menu] ========================================
[Info   :   GTag Mod Menu] GTag Mod Menu v1.1.0 Loading...
[Info   :   GTag Mod Menu] ========================================
[Info   :   GTag Mod Menu] Searching for hand anchor...
```

### Hand Anchor Detection
The mod will try multiple methods to find your hand:
```
[Info   :   GTag Mod Menu] [HandAnchor] Attempting to find hand anchor...
[Info   :   GTag Mod Menu] [HandAnchor] Found via GorillaTagger reflection
```

If it fails, you'll see:
```
[Warning:   GTag Mod Menu] [HandAnchor] No hand anchor found after searching all methods
[Warning:   GTag Mod Menu] [WARNING] Hand anchor not found - will retry every 2 seconds
```

### Menu Toggle
When you press F1/Y/B to toggle the menu:
```
[Info   :   GTag Mod Menu] Menu toggled: True
[Debug  :   GTag Mod Menu] [Debug] ========== Menu toggle pressed ==========
[Debug  :   GTag Mod Menu] [Debug] Menu Visible: True
[Debug  :   GTag Mod Menu] [Debug] HandAnchor: RightHandTransform
[Debug  :   GTag Mod Menu] [Debug] Camera: Main Camera
```

### OnGUI Rendering
When the rendering system starts:
```
[Info   :   GTag Mod Menu] [OnGUI] First OnGUI call - rendering system is active
```

If hand menu is being rendered:
```
[Info   :   GTag Mod Menu] [OnGUI] Rendering hand menu at screen position: (x:100, y:200, width:360, height:420)
```

## Common Issues & Solutions

### Issue 1: Mod Not Loading
**Symptoms:** No log entries from "GTag Mod Menu"

**Solutions:**
1. Check that `GTagSpeedMod.dll` is in `BepInEx/plugins/`
2. Make sure BepInEx is installed correctly
3. Look for errors earlier in the log file

### Issue 2: Hand Menu Not Showing
**Symptoms:** Menu toggles but nothing appears, or logs show:
```
[HandAnchor] No hand anchor found
```

**Solutions:**
1. The hand anchor search will retry every 2 seconds automatically
2. Try toggling the menu (F1/Y/B) - it should appear in the top-left corner as fallback
3. Make sure you're in-game (not in the main menu)
4. Check if GorillaTagger is loaded:
   ```
   [Debug] HandAnchor: None
   ```
   This means the game objects aren't loaded yet

### Issue 3: Menu Visible But Not on Hand
**Symptoms:** Menu appears in top-left corner instead of on hand

**Solutions:**
- This is the fallback mode when hand anchor isn't found
- It's still fully functional, just not anchored to your hand
- Wait for hand anchor to be detected (logs will show when found)
- The menu will automatically switch to hand mode once detected

### Issue 4: Can't Toggle Menu
**Symptoms:** Pressing F1/Y/B doesn't show anything in logs

**Solutions:**
1. Check input detection in logs - look for:
   ```
   [Debug] InputPoller: <ClassName>
   ```
2. Try different keys: F1, Y, B, or any joystick button
3. Make sure the game window has focus

## Debug Dump

To trigger a manual debug dump at any time, the mod automatically logs detailed state information when you toggle the menu. Look for:

```
[Debug] ========== Menu toggle pressed ==========
[Debug] Menu Visible: True
[Debug] HandAnchor: <name or None>
[Debug] Camera: <name or None>
[Debug] InputPoller: <name or None>
[Debug] OnGUI Called: True
[Debug] Hand Menu Attempted: True
[Debug] Hand Position: (x, y, z)
[Debug] Camera Position: (x, y, z)
```

## Getting Help

If the menu still doesn't work, please provide:

1. **Full log output** from startup through toggling the menu
2. **Your setup:**
   - Game version
   - BepInEx version
   - VR headset or desktop mode?
3. **What you see:**
   - Screenshot if possible
   - Any error messages

Post this information in the GitHub issues for assistance.

## Log Levels

The mod uses different log levels:

- **[Info]** - Normal operation (startup, menu toggle, features found)
- **[Warning]** - Something didn't work but isn't critical (hand anchor not found, will retry)
- **[Error]** - Something went wrong (shouldn't see these in normal operation)
- **[Debug]** - Detailed state information for troubleshooting

## Performance Notes

Debug logging has minimal performance impact:
- Startup logs: Only during mod initialization
- Toggle logs: Only when you press the menu button
- OnGUI logs: Only once when rendering starts
- Hand anchor search: Only every 2 seconds if not found

The mod is designed to be lightweight and not spam the logs during normal operation.
