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

        // Menu managers
        private MenuManager menuManager;
        private VRMenuManager vrMenuManager;

        // This runs when your mod loads
        void Awake()
        {
            Logger.LogInfo("GTag Speed Mod has loaded!");

            // Initialize the menu manager (PC menu)
            try
            {
                menuManager = new MenuManager();
                Logger.LogInfo("Menu Manager initialized successfully!");
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to initialize Menu Manager: {ex.Message}");
            }

            // Initialize the VR menu manager (In-headset menu)
            try
            {
                GameObject vrMenuObj = new GameObject("VRMenuManager");
                vrMenuManager = vrMenuObj.AddComponent<VRMenuManager>();
                vrMenuManager.Initialize();
                DontDestroyOnLoad(vrMenuObj);
                Logger.LogInfo("VR Menu Manager initialized successfully!");
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to initialize VR Menu Manager: {ex.Message}");
            }
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
    }
}
