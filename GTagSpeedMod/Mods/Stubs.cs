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

        // GameObject finder
        public static GameObject GetObject(string path)
        {
            return GameObject.Find(path);
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

    // Coroutine Manager stub
    public static class CoroutineManager
    {
        public static Coroutine StartCoroutine(IEnumerator coroutine)
        {
            // Stub: returns null
            Debug.Log("[CoroutineManager] StartCoroutine called (stub)");
            return null;
        }

        public static CoroutineManager instance => null; // Stub instance
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
}
