using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
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

    // GunData class for gun rendering
    public class GunData
    {
        public GameObject NewPointer { get; set; }
        public RaycastHit Ray { get; set; }
    }

    // Helper class for various utility methods used in Fun.cs
    public static class FunHelpers
    {
        // Input helpers
        public static bool GetGunInput(bool isRightHand)
        {
            return false; // Stub: returns false
        }

        public static GunData RenderGun()
        {
            // Stub: returns empty gun data
            return new GunData
            {
                NewPointer = new GameObject("GunPointer"),
                Ray = new RaycastHit()
            };
        }

        // GameObject finder
        public static GameObject GetObject(string path)
        {
            return GameObject.Find(path);
        }

        // Random vector/quaternion helpers
        public static Vector3 RandomVector3(float range = 1f)
        {
            return new Vector3(
                UnityEngine.Random.Range(-range, range),
                UnityEngine.Random.Range(-range, range),
                UnityEngine.Random.Range(-range, range)
            );
        }

        public static Vector3 RandomVector3()
        {
            return RandomVector3(1f);
        }

        public static Quaternion RandomQuaternion()
        {
            return Quaternion.Euler(
                UnityEngine.Random.Range(0f, 360f),
                UnityEngine.Random.Range(0f, 360f),
                UnityEngine.Random.Range(0f, 360f)
            );
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

        public static VRRig GetRandomVRRig(bool includeLocal = false)
        {
            if (GorillaParent.instance == null || GorillaParent.instance.vrrigs == null)
                return null;

            List<VRRig> validRigs = new List<VRRig>();
            foreach (VRRig rig in GorillaParent.instance.vrrigs)
            {
                if (rig != null && (includeLocal || !rig.IsLocal()))
                {
                    validRigs.Add(rig);
                }
            }

            if (validRigs.Count == 0)
                return null;

            return validRigs[UnityEngine.Random.Range(0, validRigs.Count)];
        }

        public static Player NetPlayerToPlayer(NetPlayer netPlayer)
        {
            // Convert NetPlayer to Player (Photon Realtime Player)
            if (netPlayer == null) return null;

            // NetPlayer typically has ActorID or equivalent
            // Search for matching player in PhotonNetwork
            foreach (var player in PhotonNetwork.PlayerList)
            {
                if (player.ActorNumber == netPlayer.ActorNumber)
                    return player;
            }

            return null;
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

        // Account creation date stub (overload for 1 parameter)
        public static string GetCreationDate(Player player)
        {
            return "Unknown"; // Stub
        }

        // Account creation date stub (overload for 2 parameters)
        public static string GetCreationDate(Player player, string format)
        {
            return "Unknown"; // Stub
        }

        // Name changers
        public static void ChangeName(string name)
        {
            // Stub: no implementation
            Debug.Log($"[ChangeName Stub] {name}");
        }

        public static void ChangeColor(Color color)
        {
            // Stub: no implementation
            Debug.Log($"[ChangeColor Stub] {color}");
        }

        // Random generators
        public static string RandomString(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var random = new System.Random();
            return new string(Enumerable.Repeat(chars, length)
                .Select(s => s[random.Next(s.Length)]).ToArray());
        }

        public static Color RandomColor()
        {
            return new Color(
                UnityEngine.Random.Range(0f, 1f),
                UnityEngine.Random.Range(0f, 1f),
                UnityEngine.Random.Range(0f, 1f)
            );
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

        // Type helper stub (non-generic version)
        public static Type[] GetAllType(string typeName)
        {
            return new Type[0]; // Stub: returns empty array
        }

        // Generic type helper for finding all types of T
        public static T[] GetAllType<T>() where T : UnityEngine.Object
        {
            return UnityEngine.Object.FindObjectsOfType<T>();
        }

        // GetIndex helper (stub with multiple overloads)
        public static int GetIndex(string item)
        {
            return 0; // Stub
        }

        public static int GetIndex(string item, string[] array)
        {
            return Array.IndexOf(array, item);
        }
    }

    // Extension methods for List<ButtonInfo>
    public static class ButtonInfoListExtensions
    {
        public static ButtonInfo GetIndex(this List<ButtonInfo> list, string buttonText)
        {
            foreach (var button in list)
            {
                if (button.buttonText == buttonText)
                    return button;
            }
            // Return a default ButtonInfo if not found
            return new ButtonInfo(buttonText, null);
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

        public static Player GetPlayer(this VRRig rig)
        {
            // Find the Player associated with this VRRig
            if (rig == null) return null;

            // Try to find via creator (works for remote players)
            if (rig.creator != null)
                return rig.creator;

            // Local player case
            if (rig.IsLocal())
                return PhotonNetwork.LocalPlayer;

            // Search through all players
            foreach (var player in PhotonNetwork.PlayerList)
            {
                if (player.TagObject != null && player.TagObject.Equals(rig))
                    return player;
            }

            return null;
        }
    }

    // Notification Manager stub
    public static class NotificationManager
    {
        public static void ShowNotification(string message)
        {
            Debug.Log($"[Notification] {message}");
        }

        public static void SendNotification(string message)
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

    // Coroutine Manager stub (MonoBehaviour with singleton pattern)
    public class CoroutineManager : MonoBehaviour
    {
        private static CoroutineManager _instance;

        public static CoroutineManager instance
        {
            get
            {
                if (_instance == null)
                {
                    GameObject go = new GameObject("CoroutineManager");
                    _instance = go.AddComponent<CoroutineManager>();
                    DontDestroyOnLoad(go);
                }
                return _instance;
            }
        }

        public void StopCoroutine(Coroutine coroutine)
        {
            if (coroutine != null)
            {
                base.StopCoroutine(coroutine);
            }
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

        public static string GetGamePath()
        {
            return Application.dataPath.Replace("/Gorilla Tag_Data", "");
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

    // Plugin info stub helpers
    public static class PluginInfoExtensions
    {
        public static string GetBaseDirectory()
        {
            return AppDomain.CurrentDomain.BaseDirectory;
        }
    }

    // Stub for CosmeticsController (in case it's not found in Assembly-CSharp)
    public class CosmeticsController : MonoBehaviour
    {
        public static CosmeticsController instance;
        public CosmeticSet currentWornSet;
        public CosmeticSet tryOnSet;
        public List<CosmeticItem> currentCart = new List<CosmeticItem>();
        public List<CosmeticItem> allCosmetics = new List<CosmeticItem>();
        public string concatStringCosmeticsAllowed = "";
        public string currencyName = "SR";
        public string catalog = "GorillaTag";
        public int CurrencyBalance => 10000;
        public int currencyBalance = 10000;

        public class CosmeticSet
        {
            public CosmeticItem[] items;
            public CosmeticsController controller;

            public CosmeticSet(string[] itemNames, CosmeticsController ctrl)
            {
                items = new CosmeticItem[0];
                controller = ctrl;
            }

            public string[] ToPackedIDArray()
            {
                return new string[0];
            }
        }

        public class CosmeticItem
        {
            public string itemName;
            public string displayName;
            public bool isNullItem;
            public CosmeticCategory itemCategory;
            public int cost;
        }

        public enum CosmeticCategory
        {
            Hat,
            Face,
            Badge,
            Holdable
        }

        public CosmeticItem GetItemFromDict(string itemName)
        {
            return new CosmeticItem { itemName = itemName, displayName = itemName, cost = 0 };
        }

        public void ApplyCosmeticItemToSet(CosmeticSet set, CosmeticItem item, bool arg1, bool arg2)
        {
            // Stub: no implementation
        }

        public void UpdateWornCosmetics(bool inRoom)
        {
            // Stub: no implementation
        }

        public void UpdateShoppingCart()
        {
            // Stub: no implementation
        }

        public void ProcessExternalUnlock(string itemName, bool arg1, bool arg2)
        {
            // Stub: no implementation
        }
    }

    // Stub for GorillaComputer (in case it's not found in Assembly-CSharp)
    public class GorillaComputer : MonoBehaviour
    {
        public static GorillaComputer instance;
        public bool isConnectedToMaster => PhotonNetwork.IsConnected;

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
            // Stub: call success callback with null
            Debug.Log($"[PlayFabClientAPI] PurchaseItem called (stub)");
            onSuccess?.Invoke(null);
        }
    }

    public class PurchaseItemRequest
    {
        public string ItemId { get; set; }
        public int Price { get; set; }
        public string VirtualCurrency { get; set; }
        public string CatalogVersion { get; set; }
    }
}
