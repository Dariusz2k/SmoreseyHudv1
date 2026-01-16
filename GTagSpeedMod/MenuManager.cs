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
            AddButton("Main", "Speed Mods", () => currentCategory = "Speed");

            // Head Mods Category
            AddToggleButton("Head", "Fix Head", Mods.Fun.FixHead);
            AddToggleButton("Head", "Upside Down Head", Mods.Fun.UpsideDownHead);
            AddToggleButton("Head", "Broken Neck", Mods.Fun.BrokenNeck);
            AddToggleButton("Head", "Backwards Head", Mods.Fun.BackwardsHead);
            AddToggleButton("Head", "Sideways Head", Mods.Fun.SidewaysHead);
            AddToggleButton("Head", "Head Bang", Mods.Fun.HeadBang);
            AddButton("Head", "< Back", () => currentCategory = "Main");

            // Hand Mods Category
            AddToggleButton("Hand", "Flip Hands", Mods.Fun.FlipHands);
            AddButton("Hand", "Fix Hand Taps", Mods.Fun.FixHandTaps);
            AddToggleButton("Hand", "Loud Hand Taps", Mods.Fun.LoudHandTaps);
            AddToggleButton("Hand", "Silent Hand Taps", Mods.Fun.SilentHandTaps);
            AddButton("Hand", "< Back", () => currentCategory = "Main");

            // Camera Mods Category
            AddButton("Camera", "< Back", () => currentCategory = "Main");

            // Speed Mods Category
            AddButton("Speed", "< Back", () => currentCategory = "Main");
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
