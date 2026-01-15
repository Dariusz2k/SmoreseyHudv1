/*
 * GTag Mod Menu - Mods/Advantages.cs
 * A mod menu for Gorilla Tag with various tag advantages
 *
 * Copyright (C) 2026  Goldentrophy Software
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using UnityEngine;

namespace GTagSpeedMod.Mods
{
    public static class Advantages
    {
        // Tag-related settings
        public static bool instantTag = false;
        public static float tagAuraDistance = 1.666f;
        public static int tagAuraIndex = 1;
        public static float tagReachDistance = 0.3f;
        public static int tagRangeIndex = 0;

        // Gun system
        private static bool gunLocked = false;
        private static object lockTarget = null;
        private static GameObject gunPointer = null;

        // Timing variables
        private static float reportTagDelay = 0f;
        private static float spamtagdelay = -1f;
        private static float tagGunDelay = 0f;
        private static float paintbrawlSpamDelay = 0f;
        public static int paintbrawlKillIndex = 0;
        public static readonly Dictionary<int, float> paintbrawlKillDelays = new Dictionary<int, float>();

        // Cached game references
        private static Type gorillaTaggerType;
        private static Type vrRigType;
        private static Type playerType;
        private static Type photonNetworkType;
        private static Type gorillaGameManagerType;

        // Initialize cached types
        static Advantages()
        {
            RefreshGameReferences();
        }

        /// <summary>
        /// Refresh cached references to game types via reflection
        /// </summary>
        public static void RefreshGameReferences()
        {
            gorillaTaggerType = FindType("GorillaTagger");
            vrRigType = FindType("VRRig");
            playerType = FindType("Photon.Realtime.Player");
            photonNetworkType = FindType("Photon.Pun.PhotonNetwork");
            gorillaGameManagerType = FindType("GorillaGameModes.GorillaGameManager");
        }

        /// <summary>
        /// Tag the local player
        /// </summary>
        public static void TagSelf()
        {
            try
            {
                if (IsMasterClient())
                {
                    AddInfected(GetLocalPlayer());
                    LogInfo("You have been tagged.");
                }
                else
                {
                    if (IsLocalPlayerTagged())
                    {
                        LogInfo("You have been tagged.");
                        EnableLocalRig(true);
                    }
                    else
                    {
                        // Find nearest tagged player
                        object nearestTaggedRig = FindNearestTaggedPlayer();
                        if (nearestTaggedRig != null && instantTag)
                        {
                            // Instant tag implementation would go here
                            LogInfo("Instant tag not fully implemented yet.");
                        }
                        else if (nearestTaggedRig != null)
                        {
                            // Standard tag - move to tagged player
                            MoveToPlayer(nearestTaggedRig);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogError($"TagSelf error: {ex.Message}");
            }
        }

        /// <summary>
        /// Remove tag from local player
        /// </summary>
        public static void UntagSelf()
        {
            try
            {
                if (IsMasterClient())
                {
                    RemoveInfected(GetLocalPlayer());
                }
                else
                {
                    LogInfo("Reconnect required to untag (not implemented).");
                }
            }
            catch (Exception ex)
            {
                LogError($"UntagSelf error: {ex.Message}");
            }
        }

        /// <summary>
        /// Prevent being tagged
        /// </summary>
        public static void AntiTag()
        {
            try
            {
                if (IsMasterClient())
                {
                    // Master client implementation
                    LogInfo("Anti-tag enabled (master client).");
                }
                else
                {
                    if (IsLocalPlayerTagged())
                    {
                        UntagSelf();
                    }
                }
            }
            catch (Exception ex)
            {
                LogError($"AntiTag error: {ex.Message}");
            }
        }

        /// <summary>
        /// Change tag aura range setting
        /// </summary>
        public static void ChangeTagAuraRange(bool positive = true)
        {
            string[] names = { "Short", "Normal", "Far", "Maximum" };
            float[] distances = { 0.777f, 1.666f, 3f, 5.5f };

            if (positive)
                tagAuraIndex++;
            else
                tagAuraIndex--;

            tagAuraIndex = (tagAuraIndex + names.Length) % names.Length;
            tagAuraDistance = distances[tagAuraIndex];

            LogInfo($"Tag Aura Range: {names[tagAuraIndex]} ({tagAuraDistance}m)");
        }

        /// <summary>
        /// Change tag reach distance setting
        /// </summary>
        public static void ChangeTagReachDistance(bool positive = true)
        {
            string[] names = { "Unnoticeable", "Normal", "Far", "Maximum" };
            float[] distances = { 0.3f, 0.5f, 1f, 3f };

            if (positive)
                tagRangeIndex++;
            else
                tagRangeIndex--;

            tagRangeIndex = (tagRangeIndex + names.Length) % names.Length;
            tagReachDistance = distances[tagRangeIndex];

            LogInfo($"Tag Reach Distance: {names[tagRangeIndex]} ({tagReachDistance}m)");
        }

        /// <summary>
        /// Automatically tag nearby players (requires being tagged)
        /// </summary>
        public static void TagAura()
        {
            try
            {
                if (!IsLocalPlayerTagged())
                    return;

                var nearbyPlayers = GetPlayersInRange(tagAuraDistance);
                foreach (var player in nearbyPlayers)
                {
                    if (!IsPlayerTagged(player))
                    {
                        ReportTag(player);
                    }
                }
            }
            catch (Exception ex)
            {
                LogError($"TagAura error: {ex.Message}");
            }
        }

        /// <summary>
        /// Increase tag reach distance
        /// </summary>
        public static void TagReach()
        {
            try
            {
                if (!IsLocalPlayerTagged())
                    return;

                // Extend tag reach by modifying game properties
                var taggerInstance = GetTaggerInstance();
                if (taggerInstance != null)
                {
                    SetField(gorillaTaggerType, taggerInstance, "maxTagDistance", float.MaxValue);
                    SetProperty(gorillaTaggerType, taggerInstance, "tagRadiusOverride", tagReachDistance);
                }
            }
            catch (Exception ex)
            {
                LogError($"TagReach error: {ex.Message}");
            }
        }

        /// <summary>
        /// Tag all players in the room
        /// </summary>
        public static void TagAll()
        {
            try
            {
                if (IsMasterClient())
                {
                    var allPlayers = GetAllPlayers();
                    foreach (var player in allPlayers)
                    {
                        AddInfected(player);
                    }
                    LogInfo("Everyone is tagged!");
                }
                else
                {
                    if (!IsLocalPlayerTagged())
                    {
                        LogError("You must be tagged.");
                        return;
                    }

                    // Tag each untagged player
                    var untaggedPlayers = GetUntaggedPlayers();
                    foreach (var player in untaggedPlayers)
                    {
                        MoveToPlayer(player);
                        ReportTag(player);
                    }

                    if (untaggedPlayers.Count == 0)
                    {
                        LogInfo("Everyone is tagged!");
                    }
                }
            }
            catch (Exception ex)
            {
                LogError($"TagAll error: {ex.Message}");
            }
        }

        /// <summary>
        /// Tag a specific player using a gun mechanic
        /// </summary>
        public static void TagGun()
        {
            try
            {
                if (GetGunInput(false))
                {
                    RenderGun();

                    if (gunLocked && lockTarget != null)
                    {
                        if (!IsPlayerTagged(lockTarget))
                        {
                            EnableLocalRig(false);
                            MoveToPlayer(lockTarget);
                            ReportTag(lockTarget);
                        }
                        else
                        {
                            gunLocked = false;
                            EnableLocalRig(true);
                        }
                    }

                    if (GetGunInput(true))
                    {
                        var target = GetGunTarget();
                        if (target != null && !IsLocalPlayer(target))
                        {
                            if (IsMasterClient())
                            {
                                AddInfected(target);
                            }
                            else if (IsLocalPlayerTagged())
                            {
                                gunLocked = true;
                                lockTarget = target;
                            }
                        }
                    }
                }
                else
                {
                    if (gunLocked)
                    {
                        gunLocked = false;
                        EnableLocalRig(true);
                    }
                }
            }
            catch (Exception ex)
            {
                LogError($"TagGun error: {ex.Message}");
            }
        }

        /// <summary>
        /// Report a tag on a player
        /// </summary>
        private static void ReportTag(object player)
        {
            if (Time.time > reportTagDelay)
            {
                reportTagDelay = Time.time + 0.1f;

                // Call game mode's ReportTag method via reflection
                var gameManager = GetGameManagerInstance();
                if (gameManager != null)
                {
                    CallMethod(gorillaGameManagerType, gameManager, "ReportTag", new[] { player });
                }
            }
        }

        // === Utility Methods ===

        private static bool IsMasterClient()
        {
            if (photonNetworkType == null)
                return false;

            var property = photonNetworkType.GetProperty("IsMasterClient", BindingFlags.Public | BindingFlags.Static);
            if (property != null)
            {
                return (bool)property.GetValue(null);
            }
            return false;
        }

        private static object GetLocalPlayer()
        {
            if (photonNetworkType == null)
                return null;

            var property = photonNetworkType.GetProperty("LocalPlayer", BindingFlags.Public | BindingFlags.Static);
            return property?.GetValue(null);
        }

        private static List<object> GetAllPlayers()
        {
            var result = new List<object>();

            if (photonNetworkType == null)
                return result;

            var property = photonNetworkType.GetProperty("PlayerList", BindingFlags.Public | BindingFlags.Static);
            if (property != null)
            {
                var playerList = property.GetValue(null) as Array;
                if (playerList != null)
                {
                    foreach (var player in playerList)
                    {
                        result.Add(player);
                    }
                }
            }

            return result;
        }

        private static bool IsLocalPlayerTagged()
        {
            // Check if local VRRig is tagged via reflection
            var localRig = GetLocalRig();
            return IsPlayerTagged(localRig);
        }

        private static bool IsPlayerTagged(object player)
        {
            if (player == null || vrRigType == null)
                return false;

            // Check infected status via reflection
            var infected = GetField(vrRigType, player, "infected");
            if (infected is bool)
                return (bool)infected;

            return false;
        }

        private static object GetLocalRig()
        {
            var taggerInstance = GetTaggerInstance();
            if (taggerInstance != null)
            {
                return GetField(gorillaTaggerType, taggerInstance, "myVRRig");
            }
            return null;
        }

        private static object GetTaggerInstance()
        {
            if (gorillaTaggerType == null)
                return null;

            var instanceField = gorillaTaggerType.GetField("Instance", BindingFlags.Public | BindingFlags.Static);
            return instanceField?.GetValue(null);
        }

        private static object GetGameManagerInstance()
        {
            if (gorillaGameManagerType == null)
                return null;

            var instanceProperty = gorillaGameManagerType.GetProperty("instance", BindingFlags.Public | BindingFlags.Static);
            return instanceProperty?.GetValue(null);
        }

        private static void EnableLocalRig(bool enabled)
        {
            var localRig = GetLocalRig();
            if (localRig is MonoBehaviour behaviour)
            {
                behaviour.enabled = enabled;
            }
        }

        private static void MoveToPlayer(object target)
        {
            // Move local rig to target player's position
            var localRig = GetLocalRig();
            if (localRig == null || target == null)
                return;

            var targetTransform = GetProperty(vrRigType, target, "transform") as Transform;
            var localTransform = GetProperty(vrRigType, localRig, "transform") as Transform;

            if (targetTransform != null && localTransform != null)
            {
                localTransform.position = targetTransform.position - new Vector3(0f, 3f, 0f);
            }
        }

        private static void AddInfected(object player)
        {
            var gameManager = GetGameManagerInstance();
            if (gameManager != null)
            {
                CallMethod(gorillaGameManagerType, gameManager, "AddInfected", new[] { player });
            }
        }

        private static void RemoveInfected(object player)
        {
            var gameManager = GetGameManagerInstance();
            if (gameManager != null)
            {
                CallMethod(gorillaGameManagerType, gameManager, "RemoveInfected", new[] { player });
            }
        }

        private static object FindNearestTaggedPlayer()
        {
            // Placeholder for finding nearest tagged player
            return null;
        }

        private static List<object> GetPlayersInRange(float range)
        {
            // Placeholder for getting players in range
            return new List<object>();
        }

        private static List<object> GetUntaggedPlayers()
        {
            var result = new List<object>();
            var allPlayers = GetAllPlayers();

            foreach (var player in allPlayers)
            {
                if (!IsPlayerTagged(player))
                {
                    result.Add(player);
                }
            }

            return result;
        }

        private static bool GetGunInput(bool trigger)
        {
            if (trigger)
            {
                return Input.GetMouseButtonDown(0) || Input.GetKeyDown(KeyCode.JoystickButton15);
            }
            else
            {
                return Input.GetMouseButton(0) || Input.GetKey(KeyCode.JoystickButton15);
            }
        }

        private static void RenderGun()
        {
            // Create visual gun pointer
            if (gunPointer == null)
            {
                gunPointer = GameObject.CreatePrimitive(PrimitiveType.Sphere);
                gunPointer.transform.localScale = Vector3.one * 0.1f;

                var renderer = gunPointer.GetComponent<Renderer>();
                if (renderer != null)
                {
                    renderer.material.color = Color.red;
                }
            }

            // Position gun pointer based on raycast
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            if (UnityEngine.Physics.Raycast(ray, out RaycastHit hit, 100f))
            {
                gunPointer.transform.position = hit.point;
            }
        }

        private static object GetGunTarget()
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            if (UnityEngine.Physics.Raycast(ray, out RaycastHit hit, 100f))
            {
                var rig = hit.collider.GetComponentInParent(vrRigType);
                return rig;
            }
            return null;
        }

        private static bool IsLocalPlayer(object player)
        {
            var localPlayer = GetLocalPlayer();
            return player == localPlayer;
        }

        // === Reflection Helper Methods ===

        private static Type FindType(string fullName)
        {
            foreach (var assembly in AppDomain.CurrentDomain.GetAssemblies())
            {
                var type = assembly.GetType(fullName);
                if (type != null)
                    return type;
            }
            return null;
        }

        private static object GetField(Type type, object instance, string fieldName)
        {
            if (type == null || instance == null)
                return null;

            var field = type.GetField(fieldName, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            return field?.GetValue(instance);
        }

        private static void SetField(Type type, object instance, string fieldName, object value)
        {
            if (type == null || instance == null)
                return;

            var field = type.GetField(fieldName, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            field?.SetValue(instance, value);
        }

        private static object GetProperty(Type type, object instance, string propertyName)
        {
            if (type == null || instance == null)
                return null;

            var property = type.GetProperty(propertyName, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            return property?.GetValue(instance);
        }

        private static void SetProperty(Type type, object instance, string propertyName, object value)
        {
            if (type == null || instance == null)
                return;

            var property = type.GetProperty(propertyName, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            property?.SetValue(instance, value);
        }

        private static object CallMethod(Type type, object instance, string methodName, object[] parameters)
        {
            if (type == null || instance == null)
                return null;

            var method = type.GetMethod(methodName, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            return method?.Invoke(instance, parameters);
        }

        private static void LogInfo(string message)
        {
            Debug.Log($"[Advantages] {message}");
        }

        private static void LogError(string message)
        {
            Debug.LogError($"[Advantages] {message}");
        }
    }
}
