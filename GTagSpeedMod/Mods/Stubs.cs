using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;

namespace GTagSpeedMod.Mods
{
    /// <summary>
    /// Stub classes and extension methods for missing ii'sMenu dependencies
    /// These are placeholders until full implementations are added
    /// </summary>

    // Stub for VirtualStumpAd
    public class VirtualStumpAd : MonoBehaviour
    {
        // Placeholder implementation
    }

    // Stub for ButtonInfo class
    public class ButtonInfo
    {
        public string buttonText;
        public Action method;
        public bool enabled;
        public bool isTogglable;
        public string overlapText;
        public string toolTip;

        public ButtonInfo(string text, Action methodAction, bool isToggle = false, string tooltip = "")
        {
            buttonText = text;
            method = methodAction;
            isTogglable = isToggle;
            toolTip = tooltip;
        }
    }

    // Helper class for various utility methods used in Fun.cs
    public static class FunHelpers
    {
        // Input helpers
        public static bool GetGunInput(bool isRightHand)
        {
            return false; // Stub: returns false
        }

        public static void RenderGun()
        {
            // Stub: no implementation
        }

        // Player/VRRig helpers
        public static Player GetPlayerFromVRRig(VRRig rig)
        {
            if (rig == null) return null;
            // Stub: try to find player by matching rig
            foreach (var player in PhotonNetwork.PlayerList)
            {
                if (player.TagObject != null && player.TagObject.Equals(rig))
                    return player;
            }
            return null;
        }

        public static VRRig GetVRRigFromPlayer(Player player)
        {
            if (player == null || player.TagObject == null) return null;
            return player.TagObject as VRRig;
        }

        // RPC Protection stub
        public static void RPCProtection()
        {
            // Stub: no implementation
        }

        // Text-to-speech stub
        public static void SpeakText(string text)
        {
            Debug.Log($"[TTS Stub] {text}");
        }

        // Account creation date stub
        public static string GetCreationDate(Player player)
        {
            return "Unknown"; // Stub
        }

        // Cosmetics helpers
        public static string ToTitleCase(string text)
        {
            if (string.IsNullOrEmpty(text)) return text;
            return System.Globalization.CultureInfo.CurrentCulture.TextInfo.ToTitleCase(text.ToLower());
        }

        // Cosmetic packing stub
        public static void RequestPatch()
        {
            // Stub: no implementation
        }

        // Type helper stub
        public static Type[] GetAllType(string typeName)
        {
            return new Type[0]; // Stub: returns empty array
        }
    }

    // Extension methods for VRRig
    public static class VRRigExtensions
    {
        public static bool IsLocal(this VRRig rig)
        {
            return rig == GorillaTagger.Instance.myVRRig;
        }

        public static bool IsTagged(this VRRig rig)
        {
            // Stub: returns false
            // In real implementation, would check if player is tagged in infection mode
            return false;
        }

        public static string rawCosmeticString(this VRRig rig)
        {
            // Stub: returns empty string
            return "";
        }
    }

    // Notification Manager stub
    public static class NotificationManager
    {
        public static void ShowNotification(string message)
        {
            Debug.Log($"[Notification] {message}");
        }
    }

    // Log Manager stub
    public static class LogManager
    {
        public static void Log(string message)
        {
            Debug.Log($"[LogManager] {message}");
        }
    }

    // Coroutine Manager stub
    public static class CoroutineManager
    {
        public static Coroutine StartCoroutine(IEnumerator coroutine)
        {
            // Stub: returns null
            Debug.Log("[CoroutineManager] StartCoroutine called (stub)");
            return null;
        }
    }

    // File Utilities stub
    public static class FileUtilities
    {
        public static void WriteToFile(string path, string content)
        {
            try
            {
                System.IO.File.WriteAllText(path, content);
            }
            catch (Exception ex)
            {
                Debug.LogError($"[FileUtilities] Error writing to file: {ex.Message}");
            }
        }
    }

    // Math helpers for .NET 4.7.2 compatibility
    public static class MathHelpers
    {
        public static int Clamp(int value, int min, int max)
        {
            if (value < min) return min;
            if (value > max) return max;
            return value;
        }

        public static float Clamp(float value, float min, float max)
        {
            if (value < min) return min;
            if (value > max) return max;
            return value;
        }

        public static double Clamp(double value, double min, double max)
        {
            if (value < min) return min;
            if (value > max) return max;
            return value;
        }
    }

    // Stub for CosmeticsController (in case it's not found in Assembly-CSharp)
    public class CosmeticsController : MonoBehaviour
    {
        public static CosmeticsController instance;
        public CosmeticSet currentWornSet;
        public CosmeticSet tryOnSet;
        public CosmeticCategory[] unlockedCosmetics;
        public CosmeticCategory[] unlockedHoldables;

        public class CosmeticSet
        {
            public string[] items;
            public CosmeticsController controller;

            public CosmeticSet(string[] itemNames, CosmeticsController ctrl)
            {
                items = itemNames;
                controller = ctrl;
            }
        }

        public class CosmeticItem
        {
            public string itemName;
            public string displayName;
            public bool isNullItem;
            public CosmeticCategory itemCategory;
        }

        public class CosmeticCategory
        {
            public string categoryName;
            public CosmeticItem[] items;
        }
    }

    // Stub for GorillaComputer (in case it's not found in Assembly-CSharp)
    public class GorillaComputer : MonoBehaviour
    {
        public static GorillaComputer instance;

        public string GetField(string key)
        {
            return "";
        }
    }

    // PlayFab stubs (these types usually come from PlayFab SDK)
    public class PlayFabClientAPI
    {
        public static void PurchaseItem(PurchaseItemRequest request, Action<object> onSuccess, Action<object> onError)
        {
            Debug.Log("[PlayFab Stub] PurchaseItem called");
            // Stub: do nothing
        }
    }

    public class PurchaseItemRequest
    {
        public string CatalogVersion { get; set; }
        public string ItemId { get; set; }
        public int Price { get; set; }
        public string VirtualCurrency { get; set; }
    }

    // Plugin info stub helpers
    public static class PluginInfoExtensions
    {
        public static string GetBaseDirectory()
        {
            return AppDomain.CurrentDomain.BaseDirectory;
        }
    }
}
