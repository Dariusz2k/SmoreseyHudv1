# Advantages System Implementation

## Overview

This implementation provides a simplified version of the Advantages tag system for Gorilla Tag, adapted to work with the existing BepInEx mod structure. The system avoids direct Physics dependencies (like `Physics.gravity`) that were causing compilation errors.

## What Was Added

### 1. **Mods/Advantages.cs**
The main advantages system that provides tag-related cheats/mods:

#### Core Features:
- **TagSelf()** - Tag yourself
- **UntagSelf()** - Remove tag from yourself
- **AntiTag()** - Prevent being tagged
- **TagAll()** - Tag all players in the room
- **TagGun()** - Tag players using a gun/pointer system
- **TagAura()** - Automatically tag nearby players
- **TagReach()** - Extend tag reach distance

#### Configuration:
- `instantTag` - Enable instant tagging (default: false)
- `tagAuraDistance` - Distance for tag aura (default: 1.666f)
- `tagReachDistance` - Extended reach distance (default: 0.3f)

#### Methods for Settings:
- `ChangeTagAuraRange(bool positive)` - Cycle through Short/Normal/Far/Maximum ranges
- `ChangeTagReachDistance(bool positive)` - Cycle through reach distances

### 2. **Managers/NotificationManager.cs**
Handles on-screen notifications for user feedback:

#### Features:
- Automatic color-coded notifications (SUCCESS=green, ERROR=red, WARNING=orange)
- Auto-expiring notifications (3 second duration)
- HTML-style color tag support: `<color=grey>[</color><color=green>SUCCESS</color><color=grey>]</color>`
- Renders in top-right corner of screen

#### Usage:
```csharp
NotificationManager.SendNotification("<color=grey>[</color><color=green>SUCCESS</color><color=grey>]</color> You have been tagged.");
```

### 3. **Utilities/GameUtilities.cs**
Reflection-based utilities for game interaction:

#### Features:
- Type discovery across assemblies
- Singleton instance retrieval
- Safe reflection operations (fields, properties, methods)
- Random generation helpers (Vector3, Quaternion)

#### Key Methods:
- `FindTypeByName(string)` - Find game types dynamically
- `GetInstanceFromType(Type)` - Get singleton instances
- `InvokeMethod()`, `GetFieldValue()`, `SetPropertyValue()` - Safe reflection operations

## How It Works

### Physics Dependency Avoidance

The original error was caused by trying to use `Physics.gravity`, which doesn't exist in the game context. This implementation:

1. **Uses UnityEngine.Physics.Raycast** - This is from `UnityEngine.PhysicsModule` and is available
2. **Avoids Physics.gravity** - Removed all references to the problematic `Physics.gravity` API
3. **Uses Reflection** - Accesses game types dynamically to avoid compile-time dependencies

### Integration with Existing Code

The notification system is integrated into `SpeedModPlugin.cs`:

```csharp
void OnGUI()
{
    // Always draw notifications, even when menu is hidden
    NotificationManager.DrawNotifications();

    // ... rest of menu rendering ...
}
```

### Reflection-Based Game Access

Since we can't directly reference Gorilla Tag game classes (they may not be available at compile time), the system uses reflection:

```csharp
// Find game types dynamically
gorillaTaggerType = FindType("GorillaTagger");
vrRigType = FindType("VRRig");
photonNetworkType = FindType("Photon.Pun.PhotonNetwork");

// Access instances via reflection
var taggerInstance = GetTaggerInstance();
SetField(gorillaTaggerType, taggerInstance, "maxTagDistance", float.MaxValue);
```

## Project Structure

```
GTagSpeedMod/
├── SpeedModPlugin.cs           (Modified - added NotificationManager)
├── Mods/
│   └── Advantages.cs           (New - tag advantage system)
├── Managers/
│   └── NotificationManager.cs  (New - notification display)
├── Utilities/
│   └── GameUtilities.cs        (New - reflection helpers)
└── GTagSpeedMod.csproj         (Modified - added new files)
```

## Compilation Notes

### DLL References Used:
- `BepInEx.dll` - BepInEx framework
- `UnityEngine.dll` - Core Unity engine
- `UnityEngine.CoreModule.dll` - Core Unity types
- `UnityEngine.IMGUIModule.dll` - GUI rendering
- `UnityEngine.InputLegacyModule.dll` - Input system (keyboard, mouse, controller)
- `UnityEngine.UI.dll` - UI system
- `Assembly-CSharp.dll` - Gorilla Tag game code

### References NOT Required (removed to fix build):
- ~~`UnityEngine.PhysicsModule`~~ - Not available, gun system uses simplified targeting
- ~~`UnityEngine.TextRenderingModule`~~ - Not needed, IMGUI types used instead

### Added Namespaces:
- `GTagSpeedMod.Mods`
- `GTagSpeedMod.Managers`
- `GTagSpeedMod.Utilities`

### Build Fixes Applied:
1. **Removed PhysicsModule dependency** - Gun rendering uses simplified forward projection instead of raycasting
2. **Removed TextRenderingModule dependency** - NotificationManager uses basic GUIStyle without FontStyle/TextAnchor
3. **Simplified gun targeting** - GetGunTarget() returns nearest player instead of raycast hit

## Usage Example

To use the advantages in your mod:

```csharp
using GTagSpeedMod.Mods;
using GTagSpeedMod.Managers;

// Tag yourself
Advantages.TagSelf();

// Show notification
NotificationManager.SendNotification("<color=grey>[</color><color=green>SUCCESS</color><color=grey>]</color> Tagged!");

// Configure tag aura
Advantages.ChangeTagAuraRange(true); // Increase range

// Enable tag aura
Advantages.TagAura();
```

## Known Limitations

1. **Incomplete Implementation** - Some features are placeholders that need full game context:
   - `FindNearestTaggedPlayer()` - Needs VRRig enumeration
   - `GetPlayersInRange()` - Needs spatial queries
   - `InstantTagPlayer()` - Needs network serialization

2. **Reflection Overhead** - Using reflection is slower than direct references, but necessary for dynamic game access

3. **Game Dependencies** - Full functionality requires the actual Gorilla Tag game DLLs at runtime

## Differences from Original iiMenu

This implementation is simplified from the original iiMenu code:

### Removed Dependencies:
- `iiMenu.Extensions`
- `iiMenu.Menu.Main`
- `iiMenu.Patches.Menu`
- Complex networkin g patches

### Simplified Features:
- Removed SerializePatch integration
- Simplified networking (basic ReportTag)
- Removed complex RPC protection
- Simplified gun rendering

### Kept Core Functionality:
- Tag manipulation (self, others, all)
- Anti-tag mechanics
- Gun-based targeting
- Tag aura system
- Configurable distances

## Upgrading for Full Functionality

### To Enable Full Gun/Raycasting Features:

If you have access to the full Unity modules, add these DLLs to your `libs/` folder and update the `.csproj`:

```xml
<Reference Include="UnityEngine.PhysicsModule">
  <HintPath>$(LibsPath)\UnityEngine.PhysicsModule.dll</HintPath>
  <Private>False</Private>
</Reference>
```

Then update `Advantages.cs` to use real raycasting:

```csharp
// In RenderGun() - replace simplified version with:
Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
if (Physics.Raycast(ray, out RaycastHit hit, 100f))
{
    gunPointer.transform.position = hit.point;
}

// In GetGunTarget() - replace placeholder with:
Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
if (Physics.Raycast(ray, out RaycastHit hit, 100f))
{
    return hit.collider.GetComponentInParent(vrRigType);
}
```

### To Enable Advanced Text Styling:

Add `UnityEngine.TextRenderingModule.dll` and update `NotificationManager.cs`:

```csharp
notificationStyle.fontStyle = FontStyle.Bold;
notificationStyle.alignment = TextAnchor.MiddleLeft;
```

## Next Steps

To fully implement all features:

1. **Add Game DLL References** - Include actual Gorilla Tag assemblies for proper typing
2. **Implement Networking** - Add Photon RPC handling for multiplayer
3. **Complete Placeholders** - Fill in `FindNearestTaggedPlayer()` and other stubs
4. **Add Menu Integration** - Create buttons/options in main menu to trigger advantages
5. **Add Paintbrawl Support** - Implement paintbrawl-specific features if needed
6. **Add Physics/Text Modules** - For full gun raycasting and text styling (see above)

## License

This code is provided under the GNU General Public License v3.0, same as the original iiMenu code.
