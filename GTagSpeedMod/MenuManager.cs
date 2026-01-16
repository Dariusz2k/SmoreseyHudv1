using System;
using System.Collections.Generic;
using UnityEngine;

namespace GTagSpeedMod
{
    /// <summary>
    /// Manages the mod menu with categories and toggleable buttons
    /// </summary>
    public class MenuManager
    {
        private Dictionary<string, List<ModButton>> categories = new Dictionary<string, List<ModButton>>();
        private string currentCategory = "Main";
        private Vector2 scrollPosition = Vector2.zero;

        public MenuManager()
        {
            InitializeCategories();
        }

        private void InitializeCategories()
        {
            // Main category
            AddButton("Main", "Head Mods", () => currentCategory = "Head");
            AddButton("Main", "Hand Mods", () => currentCategory = "Hand");
            AddButton("Main", "Camera Mods", () => currentCategory = "Camera");
            AddButton("Main", "Visual Mods", () => currentCategory = "Visual");
            AddButton("Main", "Movement Mods", () => currentCategory = "Movement");
            AddButton("Main", "Object Mods", () => currentCategory = "Objects");
            AddButton("Main", "Player Mods", () => currentCategory = "Player");
            AddButton("Main", "Cosmetic Mods", () => currentCategory = "Cosmetics");
            AddButton("Main", "Building Mods", () => currentCategory = "Building");
            AddButton("Main", "Projectile Mods", () => currentCategory = "Projectiles");
            AddButton("Main", "Utility Mods", () => currentCategory = "Utility");

            // Head Mods Category
            AddButton("Head", "Fix Head", Mods.Fun.FixHead);
            AddToggleButton("Head", "Upside Down Head", Mods.Fun.UpsideDownHead);
            AddToggleButton("Head", "Broken Neck", Mods.Fun.BrokenNeck);
            AddToggleButton("Head", "Backwards Head", Mods.Fun.BackwardsHead);
            AddToggleButton("Head", "Sideways Head", Mods.Fun.SidewaysHead);
            AddToggleButton("Head", "Head Bang", Mods.Fun.HeadBang);
            AddToggleButton("Head", "Spin Head X", () => Mods.Fun.SpinHead("x"));
            AddToggleButton("Head", "Spin Head Y", () => Mods.Fun.SpinHead("y"));
            AddToggleButton("Head", "Spin Head Z", () => Mods.Fun.SpinHead("z"));
            AddToggleButton("Head", "Spaz Head X", () => Mods.Fun.SpazHead("x"));
            AddToggleButton("Head", "Spaz Head Y", () => Mods.Fun.SpazHead("y"));
            AddToggleButton("Head", "Spaz Head Z", () => Mods.Fun.SpazHead("z"));
            AddButton("Head", "< Back", () => currentCategory = "Main");

            // Hand Mods Category
            AddToggleButton("Hand", "Flip Hands", Mods.Fun.FlipHands);
            AddButton("Hand", "Fix Hand Taps", Mods.Fun.FixHandTaps);
            AddToggleButton("Hand", "Loud Hand Taps", Mods.Fun.LoudHandTaps);
            AddToggleButton("Hand", "Silent Hand Taps", Mods.Fun.SilentHandTaps);
            AddToggleButton("Hand", "Silent Hand Taps On Tag", Mods.Fun.SilentHandTapsOnTag);
            AddToggleButton("Hand", "Water Splash Hands", Mods.Fun.WaterSplashHands);
            AddButton("Hand", "Give Water Splash Gun", Mods.Fun.GiveWaterSplashHandsGun);
            AddToggleButton("Hand", "Water Splash Aura", Mods.Fun.WaterSplashAura);
            AddToggleButton("Hand", "Water Splash Gun", Mods.Fun.WaterSplashGun);
            AddToggleButton("Hand", "Water Splash Walk", Mods.Fun.WaterSplashWalk);
            AddButton("Hand", "< Back", () => currentCategory = "Main");

            // Camera Mods Category
            AddToggleButton("Camera", "Freecam", Mods.Fun.Freecam);
            AddButton("Camera", "Disable Freecam", Mods.Fun.DisableFreecam);
            AddToggleButton("Camera", "Third Person Camera", Mods.Fun.ThirdPersonCamera);
            AddToggleButton("Camera", "Flip Camera", Mods.Fun.FlipCamera);
            AddToggleButton("Camera", "Nausea", Mods.Fun.Nausea);
            AddToggleButton("Camera", "Camera FOV", Mods.Fun.CameraFOV);
            AddButton("Camera", "Fix Camera FOV", Mods.Fun.FixCameraFOV);
            AddToggleButton("Camera", "Spectate Gun", Mods.Fun.SpectateGun);
            AddButton("Camera", "< Back", () => currentCategory = "Main");

            // Visual Mods Category
            AddButton("Visual", "Instant Party", Mods.Fun.InstantParty);
            AddToggleButton("Visual", "Orbit Water Splash", Mods.Fun.OrbitWaterSplash);
            AddToggleButton("Visual", "Flash Color", Mods.Fun.FlashColor);
            AddToggleButton("Visual", "Strobe Color", Mods.Fun.StrobeColor);
            AddToggleButton("Visual", "Rainbow Color", Mods.Fun.RainbowColor);
            AddToggleButton("Visual", "Hard Rainbow Color", Mods.Fun.HardRainbowColor);
            AddToggleButton("Visual", "Rainbow Bracelet", Mods.Fun.RainbowBracelet);
            AddButton("Visual", "Remove Rainbow Bracelet", Mods.Fun.RemoveRainbowBracelet);
            AddToggleButton("Visual", "Rainbow Hoverboard", Mods.Fun.RainbowHoverboard);
            AddToggleButton("Visual", "Strobe Hoverboard", Mods.Fun.StrobeHoverboard);
            AddButton("Visual", "< Back", () => currentCategory = "Main");

            // Movement Mods Category
            AddToggleButton("Movement", "Noclip Building", Mods.Fun.NoclipBuilding);
            AddButton("Movement", "Disable Noclip Building", Mods.Fun.DisableNoclipBuilding);
            AddToggleButton("Movement", "Fast Hoverboard", Mods.Fun.FastHoverboard);
            AddToggleButton("Movement", "Slow Hoverboard", Mods.Fun.SlowHoverboard);
            AddButton("Movement", "Fix Hoverboard", Mods.Fun.FixHoverboard);
            AddToggleButton("Movement", "Global Hoverboard", Mods.Fun.GlobalHoverboard);
            AddButton("Movement", "Disable Global Hoverboard", Mods.Fun.DisableGlobalHoverboard);
            AddToggleButton("Movement", "Rope Grab Reach", Mods.Fun.RopeGrabReach);
            AddButton("Movement", "< Back", () => currentCategory = "Main");

            // Object Mods Category
            AddButton("Objects", "Grab Camera", Mods.Fun.GrabCamera);
            AddButton("Objects", "Grab Tablet", Mods.Fun.GrabTablet);
            AddButton("Objects", "Grab Gliders", Mods.Fun.GrabGliders);
            AddButton("Objects", "Grab Balloons", Mods.Fun.GrabBalloons);
            AddButton("Objects", "Destroy Camera", Mods.Fun.DestroyCamera);
            AddButton("Objects", "Destroy Tablet", Mods.Fun.DestroyTablet);
            AddButton("Objects", "Destroy Gliders", Mods.Fun.DestroyGliders);
            AddButton("Objects", "Destroy Balloons", Mods.Fun.DestroyBalloons);
            AddButton("Objects", "Respawn Gliders", Mods.Fun.RespawnGliders);
            AddToggleButton("Objects", "Physical Camera", Mods.Fun.PhysicalCamera);
            AddToggleButton("Objects", "Spaz Camera", Mods.Fun.SpazCamera);
            AddToggleButton("Objects", "Spaz Tablet", Mods.Fun.SpazTablet);
            AddToggleButton("Objects", "Spaz Gliders", Mods.Fun.SpazGliders);
            AddToggleButton("Objects", "Spaz Balloons", Mods.Fun.SpazBalloons);
            AddToggleButton("Objects", "Orbit Camera", Mods.Fun.OrbitCamera);
            AddToggleButton("Objects", "Orbit Tablet", Mods.Fun.OrbitTablet);
            AddToggleButton("Objects", "Orbit Gliders", Mods.Fun.OrbitGliders);
            AddToggleButton("Objects", "Orbit Balloons", Mods.Fun.OrbitBalloons);
            AddButton("Objects", "More Objects >", () => currentCategory = "Objects2");
            AddButton("Objects", "< Back", () => currentCategory = "Main");

            // Objects Page 2
            AddToggleButton("Objects2", "Camera Aura", Mods.Fun.CameraAura);
            AddToggleButton("Objects2", "Tablet Aura", Mods.Fun.TabletAura);
            AddToggleButton("Objects2", "Balloon Aura", Mods.Fun.BalloonAura);
            AddToggleButton("Objects2", "Glider Aura", Mods.Fun.GliderAura);
            AddToggleButton("Objects2", "Hoverboard Aura", Mods.Fun.HoverboardAura);
            AddButton("Objects2", "Become Camera", Mods.Fun.BecomeCamera);
            AddButton("Objects2", "Become Tablet", Mods.Fun.BecomeTablet);
            AddButton("Objects2", "Become Balloon", Mods.Fun.BecomeBalloon);
            AddButton("Objects2", "Become Hoverboard", Mods.Fun.BecomeHoverboard);
            AddButton("Objects2", "Camera Gun", Mods.Fun.CameraGun);
            AddButton("Objects2", "Tablet Gun", Mods.Fun.TabletGun);
            AddButton("Objects2", "Glider Gun", Mods.Fun.GliderGun);
            AddButton("Objects2", "Hoverboard Gun", Mods.Fun.HoverboardGun);
            AddButton("Objects2", "Balloon Gun", Mods.Fun.BalloonGun);
            AddButton("Objects2", "Pop All Balloons", Mods.Fun.PopAllBalloons);
            AddButton("Objects2", "< Back", () => currentCategory = "Objects");

            // Player Mods Category
            AddToggleButton("Player", "Copy Identity Gun", Mods.Fun.CopyIdentityGun);
            AddToggleButton("Player", "Copy Cosmetics Gun", Mods.Fun.CopyCosmeticsGun);
            AddButton("Player", "Copy ID Gun", Mods.Fun.CopyIDGun);
            AddToggleButton("Player", "Copy ID Aura", Mods.Fun.CopyIDAura);
            AddToggleButton("Player", "Copy ID On Touch", Mods.Fun.CopyIDOnTouch);
            AddButton("Player", "Copy ID All", Mods.Fun.CopyIDAll);
            AddButton("Player", "Copy Self ID", Mods.Fun.CopySelfID);
            AddButton("Player", "White Color Gun", Mods.Fun.WhiteColorGun);
            AddButton("Player", "Black Color Gun", Mods.Fun.BlackColorGun);
            AddButton("Player", "Chicken Gun", Mods.Fun.ChickenGun);
            AddButton("Player", "Mute Gun", Mods.Fun.MuteGun);
            AddButton("Player", "Mute All", Mods.Fun.MuteAll);
            AddButton("Player", "Unmute All", Mods.Fun.UnmuteAll);
            AddButton("Player", "< Back", () => currentCategory = "Main");

            // Cosmetic Mods Category
            AddToggleButton("Cosmetics", "Change Accessories", Mods.Fun.ChangeAccessories);
            AddToggleButton("Cosmetics", "Spaz Accessories", Mods.Fun.SpazAccessories);
            AddToggleButton("Cosmetics", "Spaz Accessories Balloon", Mods.Fun.SpazAccessoriesBalloon);
            AddToggleButton("Cosmetics", "Spaz Accessories Others", Mods.Fun.SpazAccessoriesOthers);
            AddToggleButton("Cosmetics", "Sticky Holdables", Mods.Fun.StickyHoldables);
            AddToggleButton("Cosmetics", "Spaz Holdables", Mods.Fun.SpazHoldables);
            AddToggleButton("Cosmetics", "Try On Anywhere", Mods.Fun.TryOnAnywhere);
            AddButton("Cosmetics", "Try Off Anywhere", Mods.Fun.TryOffAnywhere);
            AddButton("Cosmetics", "Get Bracelet", () => Mods.Fun.GetBracelet(true));
            AddButton("Cosmetics", "Remove Bracelet", Mods.Fun.RemoveBracelet);
            AddToggleButton("Cosmetics", "Bracelet Spam", Mods.Fun.BraceletSpam);
            AddButton("Cosmetics", "Give Builder Watch", Mods.Fun.GiveBuilderWatch);
            AddButton("Cosmetics", "Remove Builder Watch", Mods.Fun.RemoveBuilderWatch);
            AddButton("Cosmetics", "Auto Load Cosmetics", Mods.Fun.AutoLoadCosmetics);
            AddButton("Cosmetics", "No Auto Load Cosmetics", Mods.Fun.NoAutoLoadCosmetics);
            AddButton("Cosmetics", "Unlock All Cosmetics", Mods.Fun.UnlockAllCosmetics);
            AddButton("Cosmetics", "< Back", () => currentCategory = "Main");

            // Building Mods Category
            AddButton("Building", "Blocks Gun", Mods.Fun.BlocksGun);
            AddButton("Building", "Select Block Gun", Mods.Fun.SelectBlockGun);
            AddButton("Building", "Copy Block Info Gun", Mods.Fun.CopyBlockInfoGun);
            AddToggleButton("Building", "Block Browser", Mods.Fun.BlockBrowser);
            AddButton("Building", "Remove Block Browser", Mods.Fun.RemoveCosmeticBrowser);
            AddToggleButton("Building", "Spam Grab Blocks", Mods.Fun.SpamGrabBlocks);
            AddToggleButton("Building", "Building Block Minigun", Mods.Fun.BuildingBlockMinigun);
            AddButton("Building", "Destroy Blocks", Mods.Fun.DestroyBlocks);
            AddToggleButton("Building", "Building Block Aura", Mods.Fun.BuildingBlockAura);
            AddToggleButton("Building", "Building Block Text Gun", Mods.Fun.BuildingBlockTextGun);
            AddToggleButton("Building", "Rain Building Blocks", Mods.Fun.RainBuildingBlocks);
            AddToggleButton("Building", "Building Block Fountain", Mods.Fun.BuildingBlockFountain);
            AddToggleButton("Building", "Orbit Blocks", Mods.Fun.OrbitBlocks);
            AddButton("Building", "Grab All Blocks Nearby", Mods.Fun.GrabAllBlocksNearby);
            AddButton("Building", "Grab All Selected Nearby", Mods.Fun.GrabAllSelectedNearby);
            AddButton("Building", "More Building >", () => currentCategory = "Building2");
            AddButton("Building", "< Back", () => currentCategory = "Main");

            // Building Page 2
            AddToggleButton("Building2", "Unlimited Building", Mods.Fun.UnlimitedBuilding);
            AddButton("Building2", "Disable Unlimited Building", Mods.Fun.DisableUnlimitedBuilding);
            AddButton("Building2", "Place Block Gun", Mods.Fun.PlaceBlockGun);
            AddButton("Building2", "Destroy Block Gun", Mods.Fun.DestroyBlockGun);
            AddButton("Building2", "Attic Draw Gun", Mods.Fun.AtticDrawGun);
            AddButton("Building2", "Attic Build Gun", Mods.Fun.AtticBuildGun);
            AddButton("Building2", "Attic Freeze Gun", Mods.Fun.AtticFreezeGun);
            AddButton("Building2", "Attic Freeze All", Mods.Fun.AtticFreezeAll);
            AddButton("Building2", "Attic Float Gun", Mods.Fun.AtticFloatGun);
            AddButton("Building2", "Attic Tower Gun", Mods.Fun.AtticTowerGun);
            AddToggleButton("Building2", "Multi Grab", Mods.Fun.MultiGrab);
            AddButton("Building2", "Shotgun", Mods.Fun.Shotgun);
            AddButton("Building2", "Massive Block", Mods.Fun.MassiveBlock);
            AddButton("Building2", "Save Builder Table Data", Mods.Fun.SaveBuilderTableData);
            AddButton("Building2", "Load Builder Table Data", Mods.Fun.LoadBuilderTableData);
            AddButton("Building2", "< Back", () => currentCategory = "Building");

            // Projectile Mods Category
            AddToggleButton("Projectiles", "Spaz Snowballs", Mods.Fun.SpazSnowballs);
            AddToggleButton("Projectiles", "Fast Snowballs", Mods.Fun.FastSnowballs);
            AddToggleButton("Projectiles", "Slow Snowballs", Mods.Fun.SlowSnowballs);
            AddButton("Projectiles", "Fix Snowballs", Mods.Fun.FixSnowballs);
            AddToggleButton("Projectiles", "Projectile Range", Mods.Fun.ProjectileRange);
            AddToggleButton("Projectiles", "Snowball Buttocks", Mods.Fun.SnowballButtocks);
            AddToggleButton("Projectiles", "Snowball Breasts", Mods.Fun.SnowballBreasts);
            AddButton("Projectiles", "Disable Snowball Genitals", Mods.Fun.DisableSnowballGenitals);
            AddToggleButton("Projectiles", "Slingshot Self", () => Mods.Fun.SlingshotSelf(true));
            AddToggleButton("Projectiles", "Slingshot Helper", Mods.Fun.SlingshotHelper);
            AddToggleButton("Projectiles", "Slingshot Trigger Bot", Mods.Fun.SlingshotTriggerBot);
            AddButton("Projectiles", "< Back", () => currentCategory = "Main");

            // Utility Mods Category
            AddToggleButton("Utility", "Auto Clicker", Mods.Fun.AutoClicker);
            AddToggleButton("Utility", "Keyboard Tracker", Mods.Fun.KeyboardTracker);
            AddButton("Utility", "Disable Keyboard Tracker", Mods.Fun.DisableKeyboardTracker);
            AddButton("Utility", "Preload Tag Sounds", Mods.Fun.PreloadTagSounds);
            AddButton("Utility", "Report Gun", Mods.Fun.ReportGun);
            AddButton("Utility", "Report All", Mods.Fun.ReportAll);
            AddButton("Utility", "Trigger Anti Report Gun", Mods.Fun.TriggerAntiReportGun);
            AddButton("Utility", "Trigger Anti Report All", Mods.Fun.TriggerAntiReportAll);
            AddButton("Utility", "Break Mod Checkers", Mods.Fun.BreakModCheckers);
            AddButton("Utility", "Mute DJ Sets", Mods.Fun.MuteDJSets);
            AddButton("Utility", "Unmute DJ Sets", Mods.Fun.UnmuteDJSets);
            AddButton("Utility", "Quest Noises", Mods.Fun.QuestNoises);
            AddButton("Utility", "Fake FPS", Mods.Fun.FakeFPS);
            AddButton("Utility", "< Back", () => currentCategory = "Main");
        }

        public void AddButton(string category, string buttonText, Action action, bool isToggle = false)
        {
            if (!categories.ContainsKey(category))
            {
                categories[category] = new List<ModButton>();
            }

            categories[category].Add(new ModButton
            {
                Text = buttonText,
                Action = action,
                IsToggle = isToggle,
                Enabled = false
            });
        }

        public void AddToggleButton(string category, string buttonText, Action action)
        {
            AddButton(category, buttonText, action, true);
        }

        public void DrawMenu(int windowID)
        {
            GUILayout.Space(10);

            // Category title
            GUILayout.Label($"Category: {currentCategory}", GUI.skin.box);

            GUILayout.Space(10);

            // Scrollable area for buttons
            scrollPosition = GUILayout.BeginScrollView(scrollPosition, GUILayout.Height(400));

            if (categories.ContainsKey(currentCategory))
            {
                foreach (var button in categories[currentCategory])
                {
                    if (button.IsToggle)
                    {
                        // Toggle button
                        bool newState = GUILayout.Toggle(button.Enabled, button.Text);
                        if (newState != button.Enabled)
                        {
                            button.Enabled = newState;
                        }
                    }
                    else
                    {
                        // Regular button
                        if (GUILayout.Button(button.Text))
                        {
                            button.Action?.Invoke();
                        }
                    }

                    GUILayout.Space(5);
                }
            }

            GUILayout.EndScrollView();

            GUILayout.Space(10);

            // Info text at bottom
            GUILayout.Label("Press F1 to toggle menu", GUI.skin.box);

            // Make window draggable
            GUI.DragWindow(new Rect(0, 0, 10000, 20));
        }

        public void Update()
        {
            // Execute enabled toggle actions
            if (categories.ContainsKey(currentCategory))
            {
                foreach (var button in categories[currentCategory])
                {
                    if (button.IsToggle && button.Enabled)
                    {
                        try
                        {
                            button.Action?.Invoke();
                        }
                        catch (Exception ex)
                        {
                            Debug.LogError($"Error executing {button.Text}: {ex.Message}");
                        }
                    }
                }
            }
        }
    }

    public class ModButton
    {
        public string Text { get; set; }
        public Action Action { get; set; }
        public bool IsToggle { get; set; }
        public bool Enabled { get; set; }
    }
}
