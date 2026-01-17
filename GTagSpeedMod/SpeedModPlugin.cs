using BepInEx;
using UnityEngine;
using System;

namespace GTagSpeedMod
{
    // This attribute tells BepInEx about your mod
    [BepInPlugin("com.yourname.gtagspeedmod", "GTag Speed Mod", "1.0.0")]
    public class SpeedModPlugin : BaseUnityPlugin
    {
        // UI positioning
        private Rect menuRect = new Rect(20, 20, 350, 500);
        private bool showMenu = false;
        private static bool legacyInputAvailable = true;
        private static System.Type keyboardType;
        private static System.Reflection.PropertyInfo keyboardCurrentProperty;
        private static System.Reflection.PropertyInfo f1KeyProperty;
        private static System.Reflection.PropertyInfo wasPressedProperty;

        // Menu manager
        private MenuManager menuManager;

        // This runs when your mod loads
        void Awake()
        {
            Logger.LogInfo("GTag Speed Mod has loaded!");

            // Initialize the menu manager
            try
            {
                menuManager = new MenuManager();
                Logger.LogInfo("Menu Manager initialized successfully!");
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to initialize Menu Manager: {ex.Message}");
            }
        }

        // This runs every frame
        void Update()
        {
            // Press F1 to toggle the menu
            if (IsF1Pressed())
            {
                showMenu = !showMenu;
                Logger.LogInfo($"Menu toggled: {showMenu}");
            }

            // Update menu manager (executes enabled mods)
            if (menuManager != null && showMenu)
            {
                try
                {
                    menuManager.Update();
                }
                catch (Exception ex)
                {
                    Logger.LogError($"Menu Manager update error: {ex.Message}");
                }
            }
        }

        // This draws the UI on screen
        void OnGUI()
        {
            if (showMenu && menuManager != null)
            {
                // Create a window for our menu
                menuRect = GUI.Window(0, menuRect, menuManager.DrawMenu, "GTag Mod Menu");
            }
        }

        private static bool IsF1Pressed()
        {
            if (TryGetInputSystemKeyDown())
            {
                return true;
            }

            if (!legacyInputAvailable)
            {
                return false;
            }

            try
            {
                return Input.GetKeyDown(KeyCode.F1);
            }
            catch (InvalidOperationException)
            {
                legacyInputAvailable = false;
                return false;
            }
        }

        private static bool TryGetInputSystemKeyDown()
        {
            if (keyboardType == null)
            {
                keyboardType = System.Type.GetType("UnityEngine.InputSystem.Keyboard, Unity.InputSystem");
                keyboardCurrentProperty = keyboardType?.GetProperty("current");
                f1KeyProperty = keyboardType?.GetProperty("f1Key");
            }

            if (keyboardType == null || keyboardCurrentProperty == null || f1KeyProperty == null)
            {
                return false;
            }

            object keyboard = keyboardCurrentProperty.GetValue(null, null);
            if (keyboard == null)
            {
                return false;
            }

            object keyControl = f1KeyProperty.GetValue(keyboard, null);
            if (keyControl == null)
            {
                return false;
            }

            if (wasPressedProperty == null)
            {
                wasPressedProperty = keyControl.GetType().GetProperty("wasPressedThisFrame");
            }

            if (wasPressedProperty == null)
            {
                return false;
            }

            return (bool)wasPressedProperty.GetValue(keyControl, null);
        }
    }
}
