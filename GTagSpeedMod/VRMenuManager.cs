using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace GTagSpeedMod
{
    /// <summary>
    /// VR Menu Manager - Creates an in-game menu that appears in the VR headset
    /// Can be toggled with Y or B buttons on the controllers
    /// </summary>
    public class VRMenuManager : MonoBehaviour
    {
        // Menu state
        private bool menuVisible = false;
        private GameObject menuCanvas;
        private GameObject menuPanel;
        private ScrollRect scrollRect;
        private Transform menuContent;

        // Input tracking for edge detection
        private bool lastRightPrimary = false;  // Y button
        private bool lastRightSecondary = false; // B button

        // Menu configuration
        private const float MENU_DISTANCE = 1.5f; // Distance from headset
        private const float MENU_WIDTH = 800f;
        private const float MENU_HEIGHT = 600f;

        // Categories and buttons
        private Dictionary<string, List<VRModButton>> categories = new Dictionary<string, List<VRModButton>>();
        private string currentCategory = "Main";
        private List<GameObject> buttonObjects = new List<GameObject>();

        public void Initialize()
        {
            Debug.Log("VRMenuManager: Initializing VR Menu System");
            CreateMenuUI();
            SetupCategories();
            menuCanvas.SetActive(false);
        }

        private void CreateMenuUI()
        {
            // Create canvas
            menuCanvas = new GameObject("VRModMenuCanvas");
            Canvas canvas = menuCanvas.AddComponent<Canvas>();
            canvas.renderMode = RenderMode.WorldSpace;

            CanvasScaler scaler = menuCanvas.AddComponent<CanvasScaler>();
            scaler.dynamicPixelsPerUnit = 10f;

            menuCanvas.AddComponent<GraphicRaycaster>();

            // Set canvas size and position
            RectTransform canvasRect = menuCanvas.GetComponent<RectTransform>();
            canvasRect.sizeDelta = new Vector2(MENU_WIDTH, MENU_HEIGHT);
            canvasRect.localScale = new Vector3(0.001f, 0.001f, 0.001f); // Scale down for VR

            // Create background panel
            menuPanel = new GameObject("MenuPanel");
            menuPanel.transform.SetParent(menuCanvas.transform, false);

            Image panelImage = menuPanel.AddComponent<Image>();
            panelImage.color = new Color(0.1f, 0.1f, 0.1f, 0.95f); // Dark semi-transparent background

            RectTransform panelRect = menuPanel.GetComponent<RectTransform>();
            panelRect.anchorMin = Vector2.zero;
            panelRect.anchorMax = Vector2.one;
            panelRect.sizeDelta = Vector2.zero;

            // Create title
            GameObject titleObj = new GameObject("Title");
            titleObj.transform.SetParent(menuPanel.transform, false);

            Text titleText = titleObj.AddComponent<Text>();
            titleText.text = "GTAG MOD MENU";
            titleText.font = Resources.GetBuiltinResource<Font>("Arial.ttf");
            titleText.fontSize = 32;
            titleText.alignment = TextAnchor.MiddleCenter;
            titleText.color = Color.white;

            RectTransform titleRect = titleObj.GetComponent<RectTransform>();
            titleRect.anchorMin = new Vector2(0, 0.9f);
            titleRect.anchorMax = new Vector2(1, 1);
            titleRect.sizeDelta = Vector2.zero;

            // Create scroll view for buttons
            GameObject scrollViewObj = new GameObject("ScrollView");
            scrollViewObj.transform.SetParent(menuPanel.transform, false);

            RectTransform scrollRect = scrollViewObj.AddComponent<RectTransform>();
            scrollRect.anchorMin = new Vector2(0.05f, 0.1f);
            scrollRect.anchorMax = new Vector2(0.95f, 0.85f);
            scrollRect.sizeDelta = Vector2.zero;

            this.scrollRect = scrollViewObj.AddComponent<ScrollRect>();

            // Create viewport
            GameObject viewportObj = new GameObject("Viewport");
            viewportObj.transform.SetParent(scrollViewObj.transform, false);

            RectTransform viewportRect = viewportObj.AddComponent<RectTransform>();
            viewportRect.anchorMin = Vector2.zero;
            viewportRect.anchorMax = Vector2.one;
            viewportRect.sizeDelta = Vector2.zero;

            Image viewportImage = viewportObj.AddComponent<Image>();
            viewportImage.color = new Color(0.15f, 0.15f, 0.15f, 1f);

            Mask viewportMask = viewportObj.AddComponent<Mask>();
            viewportMask.showMaskGraphic = true;

            this.scrollRect.viewport = viewportRect;

            // Create content container
            GameObject contentObj = new GameObject("Content");
            contentObj.transform.SetParent(viewportObj.transform, false);

            RectTransform contentRect = contentObj.AddComponent<RectTransform>();
            contentRect.anchorMin = new Vector2(0, 1);
            contentRect.anchorMax = new Vector2(1, 1);
            contentRect.pivot = new Vector2(0.5f, 1);
            contentRect.sizeDelta = new Vector2(0, 1000);

            VerticalLayoutGroup layoutGroup = contentObj.AddComponent<VerticalLayoutGroup>();
            layoutGroup.spacing = 5;
            layoutGroup.padding = new RectOffset(10, 10, 10, 10);
            layoutGroup.childAlignment = TextAnchor.UpperCenter;
            layoutGroup.childControlWidth = true;
            layoutGroup.childControlHeight = false;
            layoutGroup.childForceExpandWidth = true;
            layoutGroup.childForceExpandHeight = false;

            ContentSizeFitter contentFitter = contentObj.AddComponent<ContentSizeFitter>();
            contentFitter.verticalFit = ContentSizeFitter.FitMode.PreferredSize;

            this.scrollRect.content = contentRect;
            this.scrollRect.horizontal = false;
            this.scrollRect.vertical = true;

            menuContent = contentObj.transform;

            // Create instruction text at bottom
            GameObject instructionObj = new GameObject("Instructions");
            instructionObj.transform.SetParent(menuPanel.transform, false);

            Text instructionText = instructionObj.AddComponent<Text>();
            instructionText.text = "Press Y or B to close menu";
            instructionText.font = Resources.GetBuiltinResource<Font>("Arial.ttf");
            instructionText.fontSize = 18;
            instructionText.alignment = TextAnchor.MiddleCenter;
            instructionText.color = new Color(0.7f, 0.7f, 0.7f, 1f);

            RectTransform instructionRect = instructionObj.GetComponent<RectTransform>();
            instructionRect.anchorMin = new Vector2(0, 0);
            instructionRect.anchorMax = new Vector2(1, 0.08f);
            instructionRect.sizeDelta = Vector2.zero;

            DontDestroyOnLoad(menuCanvas);
        }

        private void SetupCategories()
        {
            // Add popular toggle mods
            AddToggleButton("Main", "Speed Boost", Mods.Fun.SpeedBoost);
            AddToggleButton("Main", "Platforms", Mods.Fun.Platforms);
            AddToggleButton("Main", "Fly", Mods.Fun.Fly);
            AddToggleButton("Main", "No Clip", Mods.Fun.NoClip);

            AddToggleButton("Head", "Upside Down Head", Mods.Fun.UpsideDownHead);
            AddToggleButton("Head", "Spin Head X", () => Mods.Fun.SpinHead("x"));
            AddToggleButton("Head", "Spin Head Y", () => Mods.Fun.SpinHead("y"));
            AddToggleButton("Head", "Head Bang", Mods.Fun.HeadBang);

            AddToggleButton("Hand", "Flip Hands", Mods.Fun.FlipHands);
            AddToggleButton("Hand", "Long Arms", Mods.Fun.LongArms);

            AddToggleButton("Visual", "ESP Players", Mods.Fun.ESPPlayers);
            AddToggleButton("Visual", "Tracers", Mods.Fun.Tracers);
            AddToggleButton("Visual", "Chams", Mods.Fun.Chams);

            AddToggleButton("Fun", "Water Splash Hands", Mods.Fun.WaterSplashHands);
            AddToggleButton("Fun", "Checkpoint", Mods.Fun.CheckPoint);

            RebuildButtonList();
        }

        public void AddToggleButton(string category, string buttonText, Action action)
        {
            if (!categories.ContainsKey(category))
            {
                categories[category] = new List<VRModButton>();
            }

            categories[category].Add(new VRModButton
            {
                Text = buttonText,
                Action = action,
                IsToggle = true,
                Enabled = false
            });
        }

        private void RebuildButtonList()
        {
            // Clear existing buttons
            foreach (GameObject btn in buttonObjects)
            {
                Destroy(btn);
            }
            buttonObjects.Clear();

            if (!categories.ContainsKey(currentCategory))
                return;

            // Create buttons for current category
            foreach (VRModButton modButton in categories[currentCategory])
            {
                GameObject buttonObj = CreateToggleButton(modButton);
                buttonObjects.Add(buttonObj);
            }
        }

        private GameObject CreateToggleButton(VRModButton modButton)
        {
            GameObject buttonObj = new GameObject(modButton.Text);
            buttonObj.transform.SetParent(menuContent, false);

            RectTransform rect = buttonObj.AddComponent<RectTransform>();
            rect.sizeDelta = new Vector2(0, 50);

            Image buttonImage = buttonObj.AddComponent<Image>();
            buttonImage.color = modButton.Enabled ? new Color(0.2f, 0.8f, 0.2f, 1f) : new Color(0.3f, 0.3f, 0.3f, 1f);

            Button button = buttonObj.AddComponent<Button>();
            ColorBlock colors = button.colors;
            colors.normalColor = modButton.Enabled ? new Color(0.2f, 0.8f, 0.2f, 1f) : new Color(0.3f, 0.3f, 0.3f, 1f);
            colors.highlightedColor = modButton.Enabled ? new Color(0.3f, 0.9f, 0.3f, 1f) : new Color(0.4f, 0.4f, 0.4f, 1f);
            colors.pressedColor = modButton.Enabled ? new Color(0.15f, 0.7f, 0.15f, 1f) : new Color(0.2f, 0.2f, 0.2f, 1f);
            button.colors = colors;

            button.onClick.AddListener(() => OnToggleButtonClick(modButton, buttonImage));

            GameObject textObj = new GameObject("Text");
            textObj.transform.SetParent(buttonObj.transform, false);

            Text text = textObj.AddComponent<Text>();
            text.text = modButton.Text + (modButton.Enabled ? " [ON]" : " [OFF]");
            text.font = Resources.GetBuiltinResource<Font>("Arial.ttf");
            text.fontSize = 24;
            text.alignment = TextAnchor.MiddleCenter;
            text.color = Color.white;

            RectTransform textRect = textObj.GetComponent<RectTransform>();
            textRect.anchorMin = Vector2.zero;
            textRect.anchorMax = Vector2.one;
            textRect.sizeDelta = Vector2.zero;

            modButton.TextComponent = text;
            modButton.ImageComponent = buttonImage;

            return buttonObj;
        }

        private void OnToggleButtonClick(VRModButton modButton, Image buttonImage)
        {
            modButton.Enabled = !modButton.Enabled;

            // Update button appearance
            if (buttonImage != null)
            {
                buttonImage.color = modButton.Enabled ? new Color(0.2f, 0.8f, 0.2f, 1f) : new Color(0.3f, 0.3f, 0.3f, 1f);
            }

            if (modButton.TextComponent != null)
            {
                modButton.TextComponent.text = modButton.Text + (modButton.Enabled ? " [ON]" : " [OFF]");
            }
        }

        public void Update()
        {
            HandleInput();

            if (menuVisible)
            {
                UpdateMenuPosition();
                ExecuteEnabledToggles();
            }
        }

        private void HandleInput()
        {
            // Get controller input
            bool rightPrimary = ControllerInputPoller.instance.rightControllerPrimaryButton;    // Y button
            bool rightSecondary = ControllerInputPoller.instance.rightControllerSecondaryButton; // B button

            // Toggle menu on Y or B button press (edge detection)
            if ((rightPrimary && !lastRightPrimary) || (rightSecondary && !lastRightSecondary))
            {
                ToggleMenu();
            }

            lastRightPrimary = rightPrimary;
            lastRightSecondary = rightSecondary;
        }

        private void ToggleMenu()
        {
            menuVisible = !menuVisible;
            menuCanvas.SetActive(menuVisible);

            if (menuVisible)
            {
                UpdateMenuPosition();
            }
        }

        private void UpdateMenuPosition()
        {
            // Position menu in front of player's headset
            Camera mainCamera = Camera.main;
            if (mainCamera != null)
            {
                Vector3 forward = mainCamera.transform.forward;
                Vector3 position = mainCamera.transform.position + forward * MENU_DISTANCE;

                menuCanvas.transform.position = position;
                menuCanvas.transform.rotation = Quaternion.LookRotation(forward);
            }
            else
            {
                // Fallback to GorillaTagger head position
                Transform headTransform = GorillaTagger.Instance?.headCollider?.transform;
                if (headTransform != null)
                {
                    Vector3 forward = headTransform.forward;
                    Vector3 position = headTransform.position + forward * MENU_DISTANCE;

                    menuCanvas.transform.position = position;
                    menuCanvas.transform.rotation = Quaternion.LookRotation(forward);
                }
            }
        }

        private void ExecuteEnabledToggles()
        {
            // Execute all enabled toggle actions
            foreach (var categoryList in categories.Values)
            {
                foreach (var button in categoryList)
                {
                    if (button.IsToggle && button.Enabled)
                    {
                        try
                        {
                            button.Action?.Invoke();
                        }
                        catch (Exception ex)
                        {
                            Debug.LogError($"VRMenuManager: Error executing {button.Text}: {ex.Message}");
                        }
                    }
                }
            }
        }
    }

    /// <summary>
    /// Represents a mod button in the VR menu
    /// </summary>
    public class VRModButton
    {
        public string Text { get; set; }
        public Action Action { get; set; }
        public bool IsToggle { get; set; }
        public bool Enabled { get; set; }
        public Text TextComponent { get; set; }
        public Image ImageComponent { get; set; }
    }
}
