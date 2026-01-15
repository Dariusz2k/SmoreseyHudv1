using BepInEx;
using UnityEngine;
using System;
using System.Collections.Generic;
using GTagSpeedMod.Managers;

namespace GTagSpeedMod
{
    // This attribute tells BepInEx about your mod
    [BepInPlugin("com.yourname.gtagspeedmod", "GTag Mod Menu", "1.1.0")]
    public class SpeedModPlugin : BaseUnityPlugin
    {
        private class MenuOption
        {
            public string Name { get; }
            public string Description { get; }
            public bool Enabled { get; set; }

            public MenuOption(string name, string description)
            {
                Name = name;
                Description = description;
            }
        }

        private readonly MenuOption[] options =
        {
            new MenuOption("Speed Boost", "Boost movement speed"),
            new MenuOption("Fly", "Toggle flight mode"),
            new MenuOption("No Clip", "Disable collisions"),
            new MenuOption("Long Arms", "Increase arm reach"),
            new MenuOption("High Jump", "Jump higher"),
            new MenuOption("Low Gravity", "Reduce gravity"),
            new MenuOption("Wall Walk", "Stick to walls"),
            new MenuOption("ESP", "Show player outlines"),
            new MenuOption("Tag Aura", "Auto-tag nearby players"),
            new MenuOption("Anti Tag", "Avoid getting tagged"),
            new MenuOption("Platforms", "Spawn temporary platforms"),
            new MenuOption("Chams", "Colorize player models"),
            new MenuOption("Teleport", "Teleport to look position"),
            new MenuOption("Speed Lines", "Visual speed effect"),
            new MenuOption("Night Mode", "Darken scene lighting"),
            new MenuOption("Name Spoof", "Spoof player name"),
            new MenuOption("Random Colors", "Cycle player colors"),
            new MenuOption("Slow Fall", "Reduce fall speed"),
            new MenuOption("Spin Bots", "Spin player model"),
            new MenuOption("FOV Boost", "Increase camera field of view")
        };

        private float speedMultiplier = 2.0f;
        private Vector2 scrollPosition = Vector2.zero;
        private Rect menuRect = new Rect(20, 20, 360, 420);
        private bool showMenu = false;
        private Transform handAnchor;
        private Vector3 handMenuOffset = new Vector3(0.05f, 0.05f, 0.15f);
        private Camera cachedCamera;
        private Texture2D pinkTexture;
        private GUIStyle titleStyle;
        private GUIStyle buttonStyle;
        private GUIStyle toggleButtonStyle;
        private float nextHandSearchTime;
        private bool hasLoggedSpeedWarning;
        private float nextInputPollerRefreshTime;
        private Type inputPollerType;
        private object inputPollerInstance;
        private readonly HashSet<string> loggedMissingFeatures = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        private int activeOptionIndex = -1;
        private float originalFov = -1f;
        private Color? originalAmbientLight;
        private bool? originalFog;
        private Color? originalFogColor;
        private float originalFogDensity;
        private bool hasLoggedOnGUI;
        private bool hasLoggedHandMenuAttempt;
        private bool hasLoggedUpdate;
        private float lastInputDebugTime;

        // This runs when your mod loads
        void Awake()
        {
            Logger.LogInfo("========================================");
            Logger.LogInfo("GTag Mod Menu v1.1.0 Loading...");
            Logger.LogInfo("========================================");

            Logger.LogInfo("Searching for hand anchor...");
            TryFindHandAnchor();

            if (handAnchor != null)
            {
                Logger.LogInfo($"[SUCCESS] Hand anchor found: {handAnchor.name}");
            }
            else
            {
                Logger.LogWarning("[WARNING] Hand anchor not found - will retry every 2 seconds");
                Logger.LogInfo("Hand menu will not be available until hand anchor is found");
            }

            Logger.LogInfo("Building menu styles...");
            BuildMenuStyles();

            Logger.LogInfo("========================================");
            Logger.LogInfo("GTag Mod Menu loaded successfully!");
            Logger.LogInfo("Press F1, Y, or B to toggle menu");
            Logger.LogInfo("========================================");

            // Log initial state
            LogDebugState("Initial startup");
        }
        
        // This runs every frame
        void Update()
        {
            // Log once that Update is being called
            if (!hasLoggedUpdate)
            {
                Logger.LogInfo("[Update] Update() is being called - mod is active");
                hasLoggedUpdate = true;
            }

            // Press Y/B (or F1 as fallback) to toggle the menu
            if (IsMenuTogglePressed())
            {
                showMenu = !showMenu;
                Logger.LogInfo($"Menu toggled: {showMenu}");
                LogDebugState("Menu toggle pressed");
            }

            // Debug: Log input state every 5 seconds to help troubleshoot
            if (Time.time >= lastInputDebugTime + 5f)
            {
                DebugInputState();
                lastInputDebugTime = Time.time;
            }

            if (handAnchor == null && Time.time >= nextHandSearchTime)
            {
                TryFindHandAnchor();
                nextHandSearchTime = Time.time + 2f;
            }

            ApplyActiveOptionEffects();
        }
        
        // This draws the UI on screen
        void OnGUI()
        {
            if (!hasLoggedOnGUI)
            {
                Logger.LogInfo("[OnGUI] First OnGUI call - rendering system is active");
                hasLoggedOnGUI = true;
            }

            // Always draw notifications, even when menu is hidden
            NotificationManager.DrawNotifications();

            if (!showMenu)
            {
                return;
            }

            if (titleStyle == null || buttonStyle == null || toggleButtonStyle == null)
            {
                BuildMenuStyles();
            }

            if (TryGetHandMenuRect(out var handRect))
            {
                if (!hasLoggedHandMenuAttempt)
                {
                    Logger.LogInfo($"[OnGUI] Rendering hand menu at screen position: {handRect}");
                    hasLoggedHandMenuAttempt = true;
                }
                GUI.Window(1, handRect, DrawMenu, "GTag Mod Menu");
                return;
            }

            if (showMenu)
            {
                // Create a window for our menu (fallback mode - not anchored to hand)
                menuRect = GUI.Window(0, menuRect, DrawMenu, "GTag Mod Menu");
            }
        }
        
        // This function draws what's inside the menu
        void DrawMenu(int windowID)
        {
            // Make the window draggable
            GUI.DragWindow(new Rect(0, 0, 360, 20));

            GUILayout.Space(8);
            GUILayout.Label("Shmoresy Menu", titleStyle, GUILayout.Height(26));

            scrollPosition = GUILayout.BeginScrollView(scrollPosition, GUILayout.Height(300));
            for (var i = 0; i < options.Length; i++)
            {
                var option = options[i];
                var label = option.Enabled ? $"[ON] {option.Name}" : $"[OFF] {option.Name}";
                if (GUILayout.Button(label, toggleButtonStyle, GUILayout.Height(32)))
                {
                    ToggleOption(i);
                }
                if (!string.IsNullOrWhiteSpace(option.Description))
                {
                    GUILayout.Label($"  - {option.Description}", GUILayout.Height(16));
                }
                GUILayout.Space(4);
            }
            GUILayout.EndScrollView();

            GUILayout.Space(6);
            GUILayout.Label($"Speed Multiplier: {speedMultiplier:F1}x");
            speedMultiplier = GUILayout.HorizontalSlider(speedMultiplier, 1.0f, 5.0f);

            GUILayout.Space(8);
            GUILayout.Label("Press Y/B (or F1) to toggle menu");

            GUILayout.Space(6);
            if (GUILayout.Button("Turn Off Mod", buttonStyle, GUILayout.Height(28)))
            {
                DisableAllOptions();
            }

            GUILayout.Space(4);
            if (GUILayout.Button("Dump Debug Info", buttonStyle, GUILayout.Height(28)))
            {
                LogDebugState("Manual debug dump");
            }

            GUILayout.Space(4);
            if (GUILayout.Button("Close", buttonStyle, GUILayout.Height(28)))
            {
                showMenu = false;
            }
        }
        
        // This function applies the speed boost
        // NOTE: You'll need to modify this based on how Gorilla Tag actually works!
        void ApplySpeedBoost()
        {
            // TODO: This is a placeholder!
            // You need to find the actual player controller in Gorilla Tag
            // and modify the correct speed variables
            
            // Example approach (won't work without proper references):
            // GameObject player = GameObject.Find("Player");
            // if (player != null)
            // {
            //     // Get the movement component and modify speed
            //     var movement = player.GetComponent<SomeMovementComponent>();
            //     if (movement != null)
            //     {
            //         movement.speed *= speedMultiplier;
            //     }
            // }
            
            if (!hasLoggedSpeedWarning)
            {
                Logger.LogWarning("Speed boost logic needs to be implemented for GorillaLocomotion.Player.");
                hasLoggedSpeedWarning = true;
            }
        }

        private void TryFindHandAnchor()
        {
            Logger.LogInfo("[HandAnchor] Attempting to find hand anchor...");

            if (TryFindHandFromGorillaTagger())
            {
                Logger.LogInfo("[HandAnchor] Found via GorillaTagger reflection");
                return;
            }

            var rightHand = GameObject.Find("RightHand Controller");
            if (rightHand != null)
            {
                handAnchor = rightHand.transform;
                Logger.LogInfo("[HandAnchor] Found 'RightHand Controller'");
                return;
            }

            var rightHandAnchor = GameObject.Find("RightHandAnchor");
            if (rightHandAnchor != null)
            {
                handAnchor = rightHandAnchor.transform;
                Logger.LogInfo("[HandAnchor] Found 'RightHandAnchor'");
                return;
            }

            var rightHandTransform = GameObject.Find("RightHand");
            if (rightHandTransform != null)
            {
                handAnchor = rightHandTransform.transform;
                Logger.LogInfo("[HandAnchor] Found 'RightHand'");
                return;
            }

            var rightHandNode = GameObject.Find("PlayerRightHand");
            if (rightHandNode != null)
            {
                handAnchor = rightHandNode.transform;
                Logger.LogInfo("[HandAnchor] Found 'PlayerRightHand'");
                return;
            }

            Logger.LogInfo("[HandAnchor] Named objects not found, searching all transforms...");
#pragma warning disable CS0618
            var transforms = GameObject.FindObjectsOfType<Transform>();
#pragma warning restore CS0618
            Logger.LogInfo($"[HandAnchor] Found {transforms.Length} total transforms in scene");

            foreach (var transform in transforms)
            {
                if (transform == null)
                {
                    continue;
                }

                var name = transform.name;
                if (string.IsNullOrEmpty(name))
                {
                    continue;
                }

                if (name.IndexOf("right", StringComparison.OrdinalIgnoreCase) >= 0
                    && name.IndexOf("hand", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    handAnchor = transform;
                    Logger.LogInfo($"[HandAnchor] Found via fallback search: {name}");
                    return;
                }
            }

            Logger.LogWarning("[HandAnchor] No hand anchor found after searching all methods");
        }

        private bool TryFindHandFromGorillaTagger()
        {
            var gorillaTaggerType = FindTypeByName("GorillaTagger");
            if (gorillaTaggerType == null)
            {
                return false;
            }

            var instance = GetInstanceFromType(gorillaTaggerType);
            if (instance == null)
            {
                return false;
            }

            if (TryGetTransformMember(gorillaTaggerType, instance, "rightHandTransform", out var rightHand)
                || TryGetTransformMember(gorillaTaggerType, instance, "RightHandTransform", out rightHand)
                || TryGetTransformMember(gorillaTaggerType, instance, "rightHand", out rightHand)
                || TryGetTransformMember(gorillaTaggerType, instance, "RightHand", out rightHand))
            {
                handAnchor = rightHand;
                return true;
            }

            if (TryGetTransformMember(gorillaTaggerType, instance, "leftHandTransform", out var leftHand)
                || TryGetTransformMember(gorillaTaggerType, instance, "LeftHandTransform", out leftHand)
                || TryGetTransformMember(gorillaTaggerType, instance, "leftHand", out leftHand)
                || TryGetTransformMember(gorillaTaggerType, instance, "LeftHand", out leftHand))
            {
                handAnchor = leftHand;
                return true;
            }

            return false;
        }

        private void ApplyActiveOptionEffects()
        {
            if (activeOptionIndex < 0 || activeOptionIndex >= options.Length)
            {
                return;
            }

            var option = options[activeOptionIndex];
            if (!option.Enabled)
            {
                return;
            }

            switch (option.Name)
            {
                case "Speed Boost":
                    ApplySpeedBoost();
                    break;
                case "FOV Boost":
                    ApplyFovBoost();
                    break;
                case "Night Mode":
                    ApplyNightMode();
                    break;
                case "Low Gravity":
                    ApplyLowGravity();
                    break;
                case "Slow Fall":
                    ApplySlowFall();
                    break;
                default:
                    LogMissingFeature(option.Name);
                    break;
            }
        }

        private void ToggleOption(int index)
        {
            if (index < 0 || index >= options.Length)
            {
                return;
            }

            if (options[index].Enabled)
            {
                options[index].Enabled = false;
                activeOptionIndex = -1;
                RestoreEnvironmentSettings();
                return;
            }

            DisableAllOptions();
            options[index].Enabled = true;
            activeOptionIndex = index;
        }

        private void DisableAllOptions()
        {
            for (var i = 0; i < options.Length; i++)
            {
                options[i].Enabled = false;
            }

            activeOptionIndex = -1;
            RestoreEnvironmentSettings();
        }

        private void ApplyFovBoost()
        {
            var camera = ResolveCamera();
            if (camera == null)
            {
                LogMissingFeature("FOV Boost");
                return;
            }

            if (originalFov < 0f)
            {
                originalFov = camera.fieldOfView;
            }

            camera.fieldOfView = Mathf.Clamp(originalFov + 20f, 60f, 120f);
        }

        private void ApplyNightMode()
        {
            if (!originalAmbientLight.HasValue)
            {
                originalAmbientLight = RenderSettings.ambientLight;
            }

            if (!originalFog.HasValue)
            {
                originalFog = RenderSettings.fog;
                originalFogColor = RenderSettings.fogColor;
                originalFogDensity = RenderSettings.fogDensity;
            }

            RenderSettings.ambientLight = new Color(0.1f, 0.05f, 0.2f, 1f);
            RenderSettings.fog = true;
            RenderSettings.fogColor = new Color(0.05f, 0.02f, 0.08f, 1f);
            RenderSettings.fogDensity = 0.02f;
        }

        private void ApplyLowGravity()
        {
            LogMissingFeature("Low Gravity");
        }

        private void ApplySlowFall()
        {
            LogMissingFeature("Slow Fall");
        }

        private void RestoreEnvironmentSettings()
        {
            if (originalFov >= 0f)
            {
                var camera = ResolveCamera();
                if (camera != null)
                {
                    camera.fieldOfView = originalFov;
                }
            }

            if (originalAmbientLight.HasValue)
            {
                RenderSettings.ambientLight = originalAmbientLight.Value;
            }

            if (originalFog.HasValue)
            {
                RenderSettings.fog = originalFog.Value;
                if (originalFogColor.HasValue)
                {
                    RenderSettings.fogColor = originalFogColor.Value;
                }

                RenderSettings.fogDensity = originalFogDensity;
            }

        }

        private void LogMissingFeature(string featureName)
        {
            if (loggedMissingFeatures.Add(featureName))
            {
                Logger.LogWarning($"Feature '{featureName}' is not implemented yet. Check logs for updates.");
            }
        }

        private void LogDebugState(string reason)
        {
            var camera = ResolveCamera();
            var cameraName = camera != null ? camera.name : "None";
            var handName = handAnchor != null ? handAnchor.name : "None";
            var inputPollerName = inputPollerType != null ? inputPollerType.FullName : "None";

            Logger.LogInfo($"[Debug] ========== {reason} ==========");
            Logger.LogInfo($"[Debug] Menu Visible: {showMenu}");
            Logger.LogInfo($"[Debug] HandAnchor: {handName}");
            Logger.LogInfo($"[Debug] Camera: {cameraName}");
            Logger.LogInfo($"[Debug] InputPoller: {inputPollerName}");
            Logger.LogInfo($"[Debug] OnGUI Called: {hasLoggedOnGUI}");
            Logger.LogInfo($"[Debug] Hand Menu Attempted: {hasLoggedHandMenuAttempt}");

            if (handAnchor != null)
            {
                Logger.LogInfo($"[Debug] Hand Position: {handAnchor.position}");
            }

            if (camera != null)
            {
                Logger.LogInfo($"[Debug] Camera Position: {camera.transform.position}");
            }

            Logger.LogInfo($"[Debug] =====================================");
        }

        private void DebugInputState()
        {
            Logger.LogInfo("[Input] === Input Debug ===");
            Logger.LogInfo($"[Input] F1 key: {Input.GetKey(KeyCode.F1)}");
            Logger.LogInfo($"[Input] Y key: {Input.GetKey(KeyCode.Y)}");
            Logger.LogInfo($"[Input] B key: {Input.GetKey(KeyCode.B)}");
            Logger.LogInfo($"[Input] Joystick buttons detected: {Input.GetJoystickNames().Length} controllers");

            if (inputPollerType != null && inputPollerInstance != null)
            {
                Logger.LogInfo($"[Input] InputPoller found: {inputPollerType.Name}");
                Logger.LogInfo($"[Input]   rightControllerPrimaryButton: {GetBoolMember(inputPollerType, inputPollerInstance, "rightControllerPrimaryButton")}");
                Logger.LogInfo($"[Input]   rightControllerSecondaryButton: {GetBoolMember(inputPollerType, inputPollerInstance, "rightControllerSecondaryButton")}");
                Logger.LogInfo($"[Input]   leftControllerPrimaryButton: {GetBoolMember(inputPollerType, inputPollerInstance, "leftControllerPrimaryButton")}");
                Logger.LogInfo($"[Input]   leftControllerSecondaryButton: {GetBoolMember(inputPollerType, inputPollerInstance, "leftControllerSecondaryButton")}");
            }
            else
            {
                Logger.LogInfo("[Input] InputPoller NOT found - will search for ControllerInputPoller");
            }

            Logger.LogInfo($"[Input] Current menu state: {(showMenu ? "VISIBLE" : "HIDDEN")}");
            Logger.LogInfo("[Input] === Press Y/B button on controller or F1 on keyboard to toggle ===");
        }

        private bool IsMenuTogglePressed()
        {
            // Check keyboard inputs
            if (Input.GetKeyDown(KeyCode.F1))
            {
                Logger.LogInfo("[Input] Menu toggle detected: F1 key");
                return true;
            }

            if (Input.GetKeyDown(KeyCode.Y))
            {
                Logger.LogInfo("[Input] Menu toggle detected: Y key");
                return true;
            }

            if (Input.GetKeyDown(KeyCode.B))
            {
                Logger.LogInfo("[Input] Menu toggle detected: B key");
                return true;
            }

            // Check joystick buttons
            for (int i = 0; i <= 9; i++)
            {
                var keyCode = (KeyCode)((int)KeyCode.JoystickButton0 + i);
                if (Input.GetKeyDown(keyCode))
                {
                    Logger.LogInfo($"[Input] Menu toggle detected: JoystickButton{i}");
                    return true;
                }
            }

            // Refresh InputPoller cache periodically
            if (Time.time >= nextInputPollerRefreshTime)
            {
                CacheInputPoller();
                nextInputPollerRefreshTime = Time.time + 2f;
            }

            if (inputPollerType == null || inputPollerInstance == null)
            {
                return false;
            }

            // Check ControllerInputPoller buttons
            if (GetBoolMember(inputPollerType, inputPollerInstance, "rightControllerPrimaryButton")
                || GetBoolMember(inputPollerType, inputPollerInstance, "rightControllerPrimaryButtonDown"))
            {
                Logger.LogInfo("[Input] Menu toggle detected: Right Controller Primary Button (Y)");
                return true;
            }

            if (GetBoolMember(inputPollerType, inputPollerInstance, "rightControllerSecondaryButton")
                || GetBoolMember(inputPollerType, inputPollerInstance, "rightControllerSecondaryButtonDown"))
            {
                Logger.LogInfo("[Input] Menu toggle detected: Right Controller Secondary Button (B)");
                return true;
            }

            if (GetBoolMember(inputPollerType, inputPollerInstance, "leftControllerPrimaryButton")
                || GetBoolMember(inputPollerType, inputPollerInstance, "leftControllerPrimaryButtonDown"))
            {
                Logger.LogInfo("[Input] Menu toggle detected: Left Controller Primary Button (X)");
                return true;
            }

            if (GetBoolMember(inputPollerType, inputPollerInstance, "leftControllerSecondaryButton")
                || GetBoolMember(inputPollerType, inputPollerInstance, "leftControllerSecondaryButtonDown"))
            {
                Logger.LogInfo("[Input] Menu toggle detected: Left Controller Secondary Button (A)");
                return true;
            }

            return false;
        }

        private void CacheInputPoller()
        {
            inputPollerType = FindTypeByName("ControllerInputPoller");
            if (inputPollerType == null)
            {
                inputPollerInstance = null;
                return;
            }

            inputPollerInstance = GetInstanceFromType(inputPollerType);
        }

        private static Type FindTypeByName(string typeName)
        {
            var assemblies = AppDomain.CurrentDomain.GetAssemblies();
            for (var index = 0; index < assemblies.Length; index++)
            {
                var assembly = assemblies[index];
                if (assembly == null)
                {
                    continue;
                }

                var type = assembly.GetType(typeName, false);
                if (type != null)
                {
                    return type;
                }
            }

            return null;
        }

        private static object GetInstanceFromType(Type type)
        {
            var instanceProperty = type.GetProperty("Instance")
                                   ?? type.GetProperty("instance")
                                   ?? type.GetProperty("Instance", System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.NonPublic);
            if (instanceProperty != null)
            {
                return instanceProperty.GetValue(null, null);
            }

            var instanceField = type.GetField("Instance")
                               ?? type.GetField("instance")
                               ?? type.GetField("Instance", System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.NonPublic);
            if (instanceField != null)
            {
                return instanceField.GetValue(null);
            }

            return null;
        }

        private static bool TryGetTransformMember(Type type, object instance, string memberName, out Transform transform)
        {
            transform = null;
            if (type == null || instance == null)
            {
                return false;
            }

            var property = type.GetProperty(memberName);
            if (property != null && typeof(Transform).IsAssignableFrom(property.PropertyType))
            {
                transform = property.GetValue(instance, null) as Transform;
                return transform != null;
            }

            var field = type.GetField(memberName);
            if (field != null && typeof(Transform).IsAssignableFrom(field.FieldType))
            {
                transform = field.GetValue(instance) as Transform;
                return transform != null;
            }

            return false;
        }

        private static bool GetBoolMember(Type type, object instance, string memberName)
        {
            var property = type.GetProperty(memberName);
            if (property != null && property.PropertyType == typeof(bool))
            {
                return (bool)property.GetValue(instance, null);
            }

            var field = type.GetField(memberName);
            if (field != null && field.FieldType == typeof(bool))
            {
                return (bool)field.GetValue(instance);
            }

            return false;
        }

        private bool TryGetHandMenuRect(out Rect rect)
        {
            rect = default;
            if (handAnchor == null)
            {
                TryFindHandAnchor();
            }

            var camera = ResolveCamera();
            if (handAnchor == null || camera == null)
            {
                return false;
            }

            var worldPosition = handAnchor.position + handAnchor.TransformDirection(handMenuOffset);
            var width = 360f;
            var height = 420f;
            var screenPosition = camera.WorldToScreenPoint(worldPosition);
            if (screenPosition.z <= 0)
            {
                return false;
            }

            var rawX = screenPosition.x - width * 0.5f;
            var rawY = Screen.height - screenPosition.y - height * 0.5f;
            var clampedX = Mathf.Clamp(rawX, 0f, Screen.width - width);
            var clampedY = Mathf.Clamp(rawY, 0f, Screen.height - height);
            rect = new Rect(clampedX, clampedY, width, height);
            return true;
        }

        private Camera ResolveCamera()
        {
            if (cachedCamera != null)
            {
                return cachedCamera;
            }

            if (Camera.main != null)
            {
                cachedCamera = Camera.main;
                return cachedCamera;
            }

            var mainCameraObject = GameObject.Find("Main Camera");
            if (mainCameraObject != null)
            {
                cachedCamera = mainCameraObject.GetComponent<Camera>();
                if (cachedCamera != null)
                {
                    return cachedCamera;
                }
            }

            if (Camera.allCamerasCount > 0)
            {
                cachedCamera = Camera.allCameras[0];
            }

            return cachedCamera;
        }

        private void BuildMenuStyles()
        {
            if (pinkTexture == null)
            {
                pinkTexture = new Texture2D(1, 1);
                pinkTexture.SetPixel(0, 0, new Color(1f, 0.2f, 0.6f, 0.9f));
                pinkTexture.Apply();
            }

            titleStyle = new GUIStyle(GUI.skin.label)
            {
                fontSize = 18,
                normal = { textColor = Color.white }
            };

            buttonStyle = new GUIStyle(GUI.skin.button)
            {
                fontSize = 14,
                normal = { textColor = Color.white, background = pinkTexture },
                hover = { textColor = Color.white, background = pinkTexture }
            };

            toggleButtonStyle = new GUIStyle(buttonStyle)
            {
                fontSize = 13
            };
        }
    }
}
