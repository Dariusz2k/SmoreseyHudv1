using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

namespace GTagSpeedMod
{
    /// <summary>
    /// VR Menu Manager - Creates an in-game menu that appears on the player's left hand
    /// Can be toggled with Y or B buttons on the controllers
    /// Interactable with right hand controller pointer
    /// </summary>
    public class VRMenuManager : MonoBehaviour
    {
        // Menu state
        private bool menuVisible = false;
        private GameObject menuCanvas;
        private GameObject menuPanel;
        private ScrollRect scrollRect;
        private Transform menuContent;

        // VR Interaction
        private LineRenderer pointerRay;
        private GameObject pointerDot;
        private EventSystem eventSystem;
        private PhysicsRaycaster physicsRaycaster;

        // Input tracking for edge detection
        private bool lastRightPrimary = false;  // Y button
        private bool lastRightSecondary = false; // B button
        private bool lastRightTrigger = false;  // Trigger for clicking

        // Menu configuration
        private const float MENU_WIDTH = 400f;
        private const float MENU_HEIGHT = 500f;
        private const float WRIST_OFFSET_Y = 0.05f; // Offset above wrist
        private const float WRIST_OFFSET_Z = 0.08f; // Offset forward from wrist

        // Categories and buttons
        private Dictionary<string, List<VRModButton>> categories = new Dictionary<string, List<VRModButton>>();
        private string currentCategory = "Main";
        private List<GameObject> buttonObjects = new List<GameObject>();

        // Cached transforms
        private Transform leftHandTransform;
        private Transform rightHandTransform;

        public void Initialize()
        {
            Debug.Log("VRMenuManager: Initializing VR Menu System");
            CreateMenuUI();
            CreatePointerRay();
            SetupEventSystem();
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

            // Add GraphicRaycaster for UI interaction
            GraphicRaycaster raycaster = menuCanvas.AddComponent<GraphicRaycaster>();

            // Set canvas size and position (will be attached to hand)
            RectTransform canvasRect = menuCanvas.GetComponent<RectTransform>();
            canvasRect.sizeDelta = new Vector2(MENU_WIDTH, MENU_HEIGHT);
            canvasRect.localScale = new Vector3(0.0008f, 0.0008f, 0.0008f); // Smaller for wrist

            // Create background panel
            menuPanel = new GameObject("MenuPanel");
            menuPanel.transform.SetParent(menuCanvas.transform, false);

            Image panelImage = menuPanel.AddComponent<Image>();
            panelImage.color = new Color(0.05f, 0.05f, 0.05f, 0.98f); // Very dark background

            RectTransform panelRect = menuPanel.GetComponent<RectTransform>();
            panelRect.anchorMin = Vector2.zero;
            panelRect.anchorMax = Vector2.one;
            panelRect.sizeDelta = Vector2.zero;

            // Add subtle border
            Outline outline = menuPanel.AddComponent<Outline>();
            outline.effectColor = new Color(0.2f, 0.6f, 1f, 1f);
            outline.effectDistance = new Vector2(2, 2);

            // Create title
            GameObject titleObj = new GameObject("Title");
            titleObj.transform.SetParent(menuPanel.transform, false);

            Text titleText = titleObj.AddComponent<Text>();
            titleText.text = "MOD MENU";
            titleText.font = Resources.GetBuiltinResource<Font>("Arial.ttf");
            titleText.fontSize = 28;
            titleText.fontStyle = FontStyle.Bold;
            titleText.alignment = TextAnchor.MiddleCenter;
            titleText.color = new Color(0.2f, 0.8f, 1f, 1f);

            RectTransform titleRect = titleObj.GetComponent<RectTransform>();
            titleRect.anchorMin = new Vector2(0, 0.92f);
            titleRect.anchorMax = new Vector2(1, 1);
            titleRect.sizeDelta = Vector2.zero;

            // Create scroll view for buttons
            GameObject scrollViewObj = new GameObject("ScrollView");
            scrollViewObj.transform.SetParent(menuPanel.transform, false);

            RectTransform scrollRectTransform = scrollViewObj.AddComponent<RectTransform>();
            scrollRectTransform.anchorMin = new Vector2(0.03f, 0.12f);
            scrollRectTransform.anchorMax = new Vector2(0.97f, 0.88f);
            scrollRectTransform.sizeDelta = Vector2.zero;

            this.scrollRect = scrollViewObj.AddComponent<ScrollRect>();

            // Create viewport
            GameObject viewportObj = new GameObject("Viewport");
            viewportObj.transform.SetParent(scrollViewObj.transform, false);

            RectTransform viewportRect = viewportObj.AddComponent<RectTransform>();
            viewportRect.anchorMin = Vector2.zero;
            viewportRect.anchorMax = Vector2.one;
            viewportRect.sizeDelta = Vector2.zero;

            Image viewportImage = viewportObj.AddComponent<Image>();
            viewportImage.color = new Color(0.1f, 0.1f, 0.1f, 1f);

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
            contentRect.sizeDelta = new Vector2(0, 1200);

            VerticalLayoutGroup layoutGroup = contentObj.AddComponent<VerticalLayoutGroup>();
            layoutGroup.spacing = 4;
            layoutGroup.padding = new RectOffset(8, 8, 8, 8);
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
            instructionText.text = "Y/B: Toggle | Trigger: Click";
            instructionText.font = Resources.GetBuiltinResource<Font>("Arial.ttf");
            instructionText.fontSize = 16;
            instructionText.alignment = TextAnchor.MiddleCenter;
            instructionText.color = new Color(0.5f, 0.5f, 0.5f, 1f);

            RectTransform instructionRect = instructionObj.GetComponent<RectTransform>();
            instructionRect.anchorMin = new Vector2(0, 0);
            instructionRect.anchorMax = new Vector2(1, 0.1f);
            instructionRect.sizeDelta = Vector2.zero;

            DontDestroyOnLoad(menuCanvas);
        }

        private void CreatePointerRay()
        {
            // Create pointer ray object
            GameObject rayObj = new GameObject("VRPointerRay");
            pointerRay = rayObj.AddComponent<LineRenderer>();
            pointerRay.material = new Material(Shader.Find("Sprites/Default"));
            pointerRay.startColor = new Color(0.2f, 0.8f, 1f, 0.8f);
            pointerRay.endColor = new Color(0.2f, 0.8f, 1f, 0.3f);
            pointerRay.startWidth = 0.003f;
            pointerRay.endWidth = 0.001f;
            pointerRay.positionCount = 2;
            pointerRay.enabled = false;

            // Create pointer dot
            pointerDot = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            pointerDot.name = "VRPointerDot";
            pointerDot.transform.localScale = new Vector3(0.01f, 0.01f, 0.01f);
            Destroy(pointerDot.GetComponent<Collider>()); // Remove collider

            Renderer dotRenderer = pointerDot.GetComponent<Renderer>();
            dotRenderer.material = new Material(Shader.Find("Sprites/Default"));
            dotRenderer.material.color = new Color(0.2f, 0.8f, 1f, 1f);
            pointerDot.SetActive(false);

            DontDestroyOnLoad(rayObj);
            DontDestroyOnLoad(pointerDot);
        }

        private void SetupEventSystem()
        {
            // Check if EventSystem exists, create if not
            eventSystem = EventSystem.current;
            if (eventSystem == null)
            {
                GameObject eventSystemObj = new GameObject("VREventSystem");
                eventSystem = eventSystemObj.AddComponent<EventSystem>();
                eventSystemObj.AddComponent<StandaloneInputModule>();
                DontDestroyOnLoad(eventSystemObj);
            }
        }

        private void SetupCategories()
        {
            // Add popular toggle mods (all in Main for simplicity)
            AddToggleButton("Main", "Speed Boost", Mods.Fun.SpeedBoost);
            AddToggleButton("Main", "Platforms", Mods.Fun.Platforms);
            AddToggleButton("Main", "Fly", Mods.Fun.Fly);
            AddToggleButton("Main", "No Clip", Mods.Fun.NoClip);
            AddToggleButton("Main", "Upside Down Head", Mods.Fun.UpsideDownHead);
            AddToggleButton("Main", "Spin Head X", () => Mods.Fun.SpinHead("x"));
            AddToggleButton("Main", "Head Bang", Mods.Fun.HeadBang);
            AddToggleButton("Main", "Flip Hands", Mods.Fun.FlipHands);
            AddToggleButton("Main", "Long Arms", Mods.Fun.LongArms);
            AddToggleButton("Main", "ESP Players", Mods.Fun.ESPPlayers);
            AddToggleButton("Main", "Tracers", Mods.Fun.Tracers);
            AddToggleButton("Main", "Water Splash", Mods.Fun.WaterSplashHands);

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
            rect.sizeDelta = new Vector2(0, 45);

            Image buttonImage = buttonObj.AddComponent<Image>();
            buttonImage.color = modButton.Enabled ? new Color(0.1f, 0.7f, 0.2f, 1f) : new Color(0.2f, 0.2f, 0.25f, 1f);

            Button button = buttonObj.AddComponent<Button>();
            ColorBlock colors = button.colors;
            colors.normalColor = modButton.Enabled ? new Color(0.1f, 0.7f, 0.2f, 1f) : new Color(0.2f, 0.2f, 0.25f, 1f);
            colors.highlightedColor = modButton.Enabled ? new Color(0.2f, 0.85f, 0.3f, 1f) : new Color(0.3f, 0.3f, 0.35f, 1f);
            colors.pressedColor = modButton.Enabled ? new Color(0.05f, 0.5f, 0.1f, 1f) : new Color(0.15f, 0.15f, 0.2f, 1f);
            button.colors = colors;

            button.onClick.AddListener(() => OnToggleButtonClick(modButton, buttonImage, button));

            GameObject textObj = new GameObject("Text");
            textObj.transform.SetParent(buttonObj.transform, false);

            Text text = textObj.AddComponent<Text>();
            text.text = modButton.Text + (modButton.Enabled ? " [ON]" : " [OFF]");
            text.font = Resources.GetBuiltinResource<Font>("Arial.ttf");
            text.fontSize = 20;
            text.alignment = TextAnchor.MiddleCenter;
            text.color = Color.white;
            text.fontStyle = FontStyle.Bold;

            RectTransform textRect = textObj.GetComponent<RectTransform>();
            textRect.anchorMin = Vector2.zero;
            textRect.anchorMax = Vector2.one;
            textRect.sizeDelta = Vector2.zero;

            modButton.TextComponent = text;
            modButton.ImageComponent = buttonImage;
            modButton.ButtonComponent = button;

            return buttonObj;
        }

        private void OnToggleButtonClick(VRModButton modButton, Image buttonImage, Button button)
        {
            modButton.Enabled = !modButton.Enabled;

            // Update button appearance
            ColorBlock colors = button.colors;
            colors.normalColor = modButton.Enabled ? new Color(0.1f, 0.7f, 0.2f, 1f) : new Color(0.2f, 0.2f, 0.25f, 1f);
            colors.highlightedColor = modButton.Enabled ? new Color(0.2f, 0.85f, 0.3f, 1f) : new Color(0.3f, 0.3f, 0.35f, 1f);
            colors.pressedColor = modButton.Enabled ? new Color(0.05f, 0.5f, 0.1f, 1f) : new Color(0.15f, 0.15f, 0.2f, 1f);
            button.colors = colors;

            if (buttonImage != null)
            {
                buttonImage.color = modButton.Enabled ? new Color(0.1f, 0.7f, 0.2f, 1f) : new Color(0.2f, 0.2f, 0.25f, 1f);
            }

            if (modButton.TextComponent != null)
            {
                modButton.TextComponent.text = modButton.Text + (modButton.Enabled ? " [ON]" : " [OFF]");
            }

            Debug.Log($"VRMenuManager: Toggled {modButton.Text} to {(modButton.Enabled ? "ON" : "OFF")}");
        }

        public void Update()
        {
            UpdateTransforms();
            HandleInput();

            if (menuVisible)
            {
                UpdateMenuPosition();
                HandlePointerInteraction();
                ExecuteEnabledToggles();
            }
            else
            {
                // Hide pointer when menu is hidden
                if (pointerRay != null) pointerRay.enabled = false;
                if (pointerDot != null) pointerDot.SetActive(false);
            }
        }

        private void UpdateTransforms()
        {
            // Cache hand transforms
            if (GorillaTagger.Instance != null)
            {
                leftHandTransform = GorillaTagger.Instance.leftHandTransform;
                rightHandTransform = GorillaTagger.Instance.rightHandTransform;
            }
        }

        private void HandleInput()
        {
            if (ControllerInputPoller.instance == null)
                return;

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
                Debug.Log("VRMenuManager: Menu opened on left hand");
            }
            else
            {
                Debug.Log("VRMenuManager: Menu closed");
            }
        }

        private void UpdateMenuPosition()
        {
            if (leftHandTransform == null)
                return;

            // Position menu on the left wrist
            Vector3 wristPosition = leftHandTransform.position;
            Vector3 wristForward = leftHandTransform.forward;
            Vector3 wristUp = leftHandTransform.up;

            // Offset the menu slightly above and forward from the wrist
            Vector3 menuPosition = wristPosition + (wristUp * WRIST_OFFSET_Y) + (wristForward * WRIST_OFFSET_Z);

            menuCanvas.transform.position = menuPosition;

            // Rotate to face up from the wrist
            menuCanvas.transform.rotation = Quaternion.LookRotation(-wristUp, wristForward);
        }

        private void HandlePointerInteraction()
        {
            if (rightHandTransform == null || menuCanvas == null)
                return;

            // Create ray from right hand controller
            Ray ray = new Ray(rightHandTransform.position, rightHandTransform.forward);
            RaycastHit hit;

            // Check if ray hits the menu canvas
            bool hitMenu = false;
            float maxDistance = 2f;

            if (Physics.Raycast(ray, out hit, maxDistance))
            {
                // Check if we hit the menu canvas
                if (hit.collider != null && hit.collider.transform.IsChildOf(menuCanvas.transform))
                {
                    hitMenu = true;
                }
            }

            // Also check UI raycast
            GraphicRaycaster raycaster = menuCanvas.GetComponent<GraphicRaycaster>();
            if (raycaster != null && !hitMenu)
            {
                // Manual UI raycast check
                Vector3 localPoint;
                RectTransform canvasRect = menuCanvas.GetComponent<RectTransform>();

                if (RectTransformUtility.ScreenPointToLocalPointInRectangle(
                    canvasRect,
                    Camera.main != null ? Camera.main.WorldToScreenPoint(rightHandTransform.position + rightHandTransform.forward * 0.5f) : Vector2.zero,
                    null,
                    out localPoint))
                {
                    // Check if point is within canvas bounds
                    Rect rect = canvasRect.rect;
                    if (rect.Contains(localPoint))
                    {
                        hitMenu = true;
                    }
                }
            }

            // Update pointer visualization
            if (pointerRay != null)
            {
                pointerRay.enabled = true;
                pointerRay.SetPosition(0, rightHandTransform.position);
                pointerRay.SetPosition(1, rightHandTransform.position + rightHandTransform.forward * (hitMenu ? hit.distance : maxDistance));
            }

            if (pointerDot != null)
            {
                pointerDot.SetActive(hitMenu);
                if (hitMenu)
                {
                    pointerDot.transform.position = hit.point;
                }
            }

            // Handle trigger click
            if (ControllerInputPoller.instance != null)
            {
                bool rightTrigger = ControllerInputPoller.instance.rightControllerIndexFloat > 0.5f;

                if (rightTrigger && !lastRightTrigger && hitMenu)
                {
                    // Simulate click on UI element
                    TryClickUI(ray);
                }

                lastRightTrigger = rightTrigger;
            }
        }

        private void TryClickUI(Ray ray)
        {
            // Get the graphic raycaster
            GraphicRaycaster raycaster = menuCanvas.GetComponent<GraphicRaycaster>();
            if (raycaster == null || eventSystem == null)
                return;

            // Create pointer event data
            PointerEventData pointerData = new PointerEventData(eventSystem);

            // Use right hand position projected to screen space
            if (Camera.main != null)
            {
                Vector3 screenPoint = Camera.main.WorldToScreenPoint(rightHandTransform.position + rightHandTransform.forward * 0.5f);
                pointerData.position = new Vector2(screenPoint.x, screenPoint.y);
            }

            // Raycast to find UI elements
            List<RaycastResult> results = new List<RaycastResult>();
            raycaster.Raycast(pointerData, results);

            // Click the first button we hit
            foreach (RaycastResult result in results)
            {
                Button button = result.gameObject.GetComponent<Button>();
                if (button != null)
                {
                    button.onClick.Invoke();
                    Debug.Log($"VRMenuManager: Clicked button via VR pointer");
                    break;
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
        public Button ButtonComponent { get; set; }
    }
}
