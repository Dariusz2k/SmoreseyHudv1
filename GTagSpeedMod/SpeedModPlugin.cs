using BepInEx;
using UnityEngine;
using System;
using UnityEngine.UI;
using GorillaLocomotion;

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
        private GameObject handMenuRoot;
        private Text handMenuText;
        private Transform handAnchor;
        
        // This runs when your mod loads
        void Awake()
        {
            Logger.LogInfo("GTag Mod Menu has loaded!");
            TryFindHandAnchor();
        }
        
        // This runs every frame
        void Update()
        {
            // Press Y or B on VR controllers to toggle the menu
            if (Input.GetKeyDown(KeyCode.JoystickButton3) || Input.GetKeyDown(KeyCode.JoystickButton1))
            {
                showMenu = !showMenu;
                Logger.LogInfo($"Menu toggled: {showMenu}");
            }

            if (showMenu)
            {
                EnsureHandMenu();
                UpdateHandMenuText();
            }
            else if (handMenuRoot != null)
            {
                handMenuRoot.SetActive(false);
            }
            
            if (options[0].Enabled)
            {
                ApplySpeedBoost();
            }
        }
        
        // This draws the UI on screen
        void OnGUI()
        {
            if (showMenu && handMenuRoot == null)
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
            GUILayout.Label("Press Y or B to toggle menu");

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
            if (Player.Instance != null && Player.Instance.rightHandTransform != null)
            {
                handAnchor = Player.Instance.rightHandTransform;
                return;
            }

            var rightHand = GameObject.Find("RightHand Controller");
            if (rightHand != null)
            {
                handAnchor = rightHand.transform;
            }
        }

        private void EnsureHandMenu()
        {
            if (handMenuRoot != null)
            {
                handMenuRoot.SetActive(true);
                if (handAnchor != null)
                {
                    handMenuRoot.transform.SetParent(handAnchor, false);
                }
                return;
            }

            if (handAnchor == null)
            {
                TryFindHandAnchor();
                if (handAnchor == null)
                {
                    return;
                }
            }

            handMenuRoot = new GameObject("GTagHandMenu");
            handMenuRoot.transform.SetParent(handAnchor, false);
            handMenuRoot.transform.localPosition = new Vector3(0.05f, 0.05f, 0.15f);
            handMenuRoot.transform.localRotation = Quaternion.Euler(0f, 180f, 0f);
            handMenuRoot.transform.localScale = Vector3.one * 0.0025f;

            var canvas = handMenuRoot.AddComponent<Canvas>();
            canvas.renderMode = RenderMode.WorldSpace;
            handMenuRoot.AddComponent<CanvasScaler>();
            handMenuRoot.AddComponent<GraphicRaycaster>();

            var panel = new GameObject("Panel");
            panel.transform.SetParent(handMenuRoot.transform, false);
            var panelImage = panel.AddComponent<Image>();
            panelImage.color = new Color(0f, 0f, 0f, 0.75f);
            var panelRect = panel.GetComponent<RectTransform>();
            panelRect.sizeDelta = new Vector2(600f, 900f);

            var textObject = new GameObject("MenuText");
            textObject.transform.SetParent(panel.transform, false);
            handMenuText = textObject.AddComponent<Text>();
            handMenuText.font = Resources.GetBuiltinResource<Font>("Arial.ttf");
            handMenuText.fontSize = 36;
            handMenuText.color = Color.white;
            handMenuText.alignment = TextAnchor.UpperLeft;
            var textRect = handMenuText.GetComponent<RectTransform>();
            textRect.anchorMin = new Vector2(0f, 1f);
            textRect.anchorMax = new Vector2(1f, 1f);
            textRect.pivot = new Vector2(0.5f, 1f);
            textRect.sizeDelta = new Vector2(-40f, -40f);
            textRect.anchoredPosition = new Vector2(0f, -20f);
        }

        private void UpdateHandMenuText()
        {
            if (handMenuText == null)
            {
                return;
            }

            var builder = new System.Text.StringBuilder();
            builder.AppendLine("GTag Mod Menu");
            builder.AppendLine($"Speed: {speedMultiplier:F1}x");
            builder.AppendLine("--------------------");
            foreach (var option in options)
            {
                var status = option.Enabled ? "[X]" : "[ ]";
                builder.AppendLine($"{status} {option.Name}");
            }
            builder.AppendLine("--------------------");
            builder.AppendLine("Press Y/B to hide");
            handMenuText.text = builder.ToString();
        }
    }
}
