/*
 * GTag Mod Menu - Managers/NotificationManager.cs
 * Handles on-screen notifications for the mod menu
 *
 * Copyright (C) 2026  Goldentrophy Software
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

using System;
using System.Collections.Generic;
using UnityEngine;

namespace GTagSpeedMod.Managers
{
    public static class NotificationManager
    {
        private class Notification
        {
            public string Message { get; set; }
            public float ExpiryTime { get; set; }
            public Color Color { get; set; }
        }

        private static readonly List<Notification> activeNotifications = new List<Notification>();
        private static readonly float notificationDuration = 3f;
        private static GUIStyle notificationStyle;

        /// <summary>
        /// Send a notification message
        /// </summary>
        public static void SendNotification(string message)
        {
            var notification = new Notification
            {
                Message = message,
                ExpiryTime = Time.time + notificationDuration,
                Color = ParseColorFromMessage(message)
            };

            activeNotifications.Add(notification);
            Debug.Log($"[Notification] {StripColorTags(message)}");
        }

        /// <summary>
        /// Render all active notifications
        /// </summary>
        public static void DrawNotifications()
        {
            if (activeNotifications.Count == 0)
                return;

            // Remove expired notifications
            activeNotifications.RemoveAll(n => Time.time > n.ExpiryTime);

            if (notificationStyle == null)
            {
                InitializeStyle();
            }

            // Draw notifications
            float yOffset = 10f;
            foreach (var notification in activeNotifications)
            {
                var content = new GUIContent(StripColorTags(notification.Message));
                var size = notificationStyle.CalcSize(content);

                var xPos = Screen.width - size.x - 20f;
                var rect = new Rect(xPos, yOffset, size.x + 10f, size.y + 5f);

                // Draw background
                GUI.Box(rect, "", notificationStyle);

                // Draw text
                var textStyle = new GUIStyle(notificationStyle)
                {
                    normal = { textColor = notification.Color }
                };
                GUI.Label(rect, content, textStyle);

                yOffset += size.y + 10f;
            }
        }

        private static void InitializeStyle()
        {
            notificationStyle = new GUIStyle(GUI.skin.box)
            {
                fontSize = 14,
                fontStyle = FontStyle.Bold,
                alignment = TextAnchor.MiddleLeft,
                padding = new RectOffset(5, 5, 5, 5)
            };

            var bgTexture = new Texture2D(1, 1);
            bgTexture.SetPixel(0, 0, new Color(0.1f, 0.1f, 0.1f, 0.8f));
            bgTexture.Apply();
            notificationStyle.normal.background = bgTexture;
            notificationStyle.normal.textColor = Color.white;
        }

        private static Color ParseColorFromMessage(string message)
        {
            if (message.Contains("SUCCESS"))
                return Color.green;
            if (message.Contains("ERROR"))
                return Color.red;
            if (message.Contains("WARNING"))
                return new Color(1f, 0.65f, 0f); // Orange

            return Color.white;
        }

        private static string StripColorTags(string message)
        {
            // Remove HTML-style color tags
            string result = message;
            while (result.Contains("<color=") || result.Contains("</color>"))
            {
                int startIndex = result.IndexOf("<color=");
                if (startIndex >= 0)
                {
                    int endIndex = result.IndexOf(">", startIndex);
                    if (endIndex >= 0)
                    {
                        result = result.Remove(startIndex, endIndex - startIndex + 1);
                    }
                    else
                    {
                        break;
                    }
                }

                result = result.Replace("</color>", "");
            }

            // Clean up brackets used for styling
            result = result.Replace("<color=grey>[</color>", "[");
            result = result.Replace("<color=grey>]</color>", "]");

            return result;
        }

        /// <summary>
        /// Clear all active notifications
        /// </summary>
        public static void ClearAll()
        {
            activeNotifications.Clear();
        }
    }
}
