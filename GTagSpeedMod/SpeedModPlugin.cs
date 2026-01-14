using BepInEx;
using UnityEngine;
using System;

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
        
        // This runs when your mod loads
        void Awake()
        {
            Logger.LogInfo("GTag Mod Menu has loaded!");
            TryFindHandAnchor();
        }
        
        // This runs every frame
        void Update()
        {
            // Press Y/B (or F1 as fallback) to toggle the menu
            if (Input.GetKeyDown(KeyCode.F1)
                || Input.GetKeyDown(KeyCode.Y)
                || Input.GetKeyDown(KeyCode.B)
                || Input.GetKeyDown(KeyCode.JoystickButton3)
                || Input.GetKeyDown(KeyCode.JoystickButton1)
                || Input.GetKeyDown(KeyCode.JoystickButton2)
                || Input.GetKeyDown(KeyCode.JoystickButton0))
            {
                showMenu = !showMenu;
                Logger.LogInfo($"Menu toggled: {showMenu}");
            }

            if (options[0].Enabled)
            {
                ApplySpeedBoost();
            }
        }
        
        // This draws the UI on screen
        void OnGUI()
        {
            if (!showMenu)
            {
                return;
            }

            if (TryGetHandMenuRect(out var handRect))
            {
                GUI.Window(1, handRect, DrawMenu, "GTag Mod Menu");
                return;
            }

            if (showMenu)
            {
                // Create a window for our menu
                menuRect = GUI.Window(0, menuRect, DrawMenu, "GTag Mod Menu");
            }
        }
        
        // This function draws what's inside the menu
        void DrawMenu(int windowID)
        {
            // Make the window draggable
            GUI.DragWindow(new Rect(0, 0, 360, 20));

            GUILayout.Space(8);
            GUILayout.Label("Toggles", GUILayout.Height(18));

            scrollPosition = GUILayout.BeginScrollView(scrollPosition, GUILayout.Height(260));
            foreach (var option in options)
            {
                option.Enabled = GUILayout.Toggle(option.Enabled, option.Name);
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
            if (GUILayout.Button("Close"))
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
            
            Logger.LogWarning("Speed boost logic needs to be implemented!");
        }

        private void TryFindHandAnchor()
        {
            var rightHand = GameObject.Find("RightHand Controller");
            if (rightHand != null)
            {
                handAnchor = rightHand.transform;
                return;
            }

            var rightHandAnchor = GameObject.Find("RightHandAnchor");
            if (rightHandAnchor != null)
            {
                handAnchor = rightHandAnchor.transform;
            }
        }

        private bool TryGetHandMenuRect(out Rect rect)
        {
            rect = default;
            if (handAnchor == null)
            {
                TryFindHandAnchor();
            }

            if (handAnchor == null || Camera.main == null)
            {
                return false;
            }

            var worldPosition = handAnchor.position + handAnchor.TransformDirection(handMenuOffset);
            var screenPosition = Camera.main.WorldToScreenPoint(worldPosition);
            if (screenPosition.z <= 0)
            {
                return false;
            }

            var width = 360f;
            var height = 420f;
            rect = new Rect(
                screenPosition.x - width * 0.5f,
                Screen.height - screenPosition.y - height * 0.5f,
                width,
                height);
            return true;
        }
    }
}
