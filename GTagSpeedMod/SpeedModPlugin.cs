using BepInEx;
using UnityEngine;
using System;

namespace GTagSpeedMod
{
    // This attribute tells BepInEx about your mod
    [BepInPlugin("com.yourname.gtagspeedmod", "GTag Speed Mod", "1.0.0")]
    public class SpeedModPlugin : BaseUnityPlugin
    {
        // These are our mod settings
        private bool modMenuEnabled = false;
        private bool speedBoostEnabled = false;
        private float speedMultiplier = 2.0f;
        
        // UI positioning
        private Rect menuRect = new Rect(20, 20, 250, 200);
        private bool showMenu = false;
        
        // This runs when your mod loads
        void Awake()
        {
            Logger.LogInfo("GTag Speed Mod has loaded!");
        }
        
        // This runs every frame
        void Update()
        {
            // Press F1 to toggle the menu
            if (Input.GetKeyDown(KeyCode.F1))
            {
                showMenu = !showMenu;
                Logger.LogInfo($"Menu toggled: {showMenu}");
            }
            
            // Apply speed boost if enabled
            if (speedBoostEnabled)
            {
                ApplySpeedBoost();
            }
        }
        
        // This draws the UI on screen
        void OnGUI()
        {
            if (showMenu)
            {
                // Create a window for our menu
                menuRect = GUI.Window(0, menuRect, DrawMenu, "Speed Mod Menu");
            }
        }
        
        // This function draws what's inside the menu
        void DrawMenu(int windowID)
        {
            // Make the window draggable
            GUI.DragWindow(new Rect(0, 0, 250, 20));
            
            GUILayout.Space(10);
            
            // Toggle for speed boost
            speedBoostEnabled = GUILayout.Toggle(speedBoostEnabled, "Speed Boost Enabled");
            
            GUILayout.Space(10);
            
            // Slider to control speed
            GUILayout.Label($"Speed Multiplier: {speedMultiplier:F1}x");
            speedMultiplier = GUILayout.HorizontalSlider(speedMultiplier, 1.0f, 5.0f);
            
            GUILayout.Space(10);
            
            // Info text
            GUILayout.Label("Press F1 to toggle menu");
            
            GUILayout.Space(10);
            
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
    }
}
