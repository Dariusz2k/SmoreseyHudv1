/*
 * GTag Mod Menu - Utilities/GameUtilities.cs
 * Utility functions for game interactions
 *
 * Copyright (C) 2026  Goldentrophy Software
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

using System;
using System.Reflection;
using UnityEngine;

namespace GTagSpeedMod.Utilities
{
    public static class GameUtilities
    {
        /// <summary>
        /// Find a type by full name across all loaded assemblies
        /// </summary>
        public static Type FindTypeByName(string fullName)
        {
            foreach (var assembly in AppDomain.CurrentDomain.GetAssemblies())
            {
                var type = assembly.GetType(fullName, false, true);
                if (type != null)
                {
                    return type;
                }

                // Also try to find types with partial name matching
                foreach (var assemblyType in assembly.GetTypes())
                {
                    if (assemblyType.FullName != null &&
                        assemblyType.FullName.EndsWith(fullName, StringComparison.OrdinalIgnoreCase))
                    {
                        return assemblyType;
                    }
                }
            }
            return null;
        }

        /// <summary>
        /// Get a singleton instance from a type
        /// </summary>
        public static object GetInstanceFromType(Type type)
        {
            if (type == null)
                return null;

            // Try common singleton property names
            var instanceProperty = type.GetProperty("Instance", BindingFlags.Public | BindingFlags.Static)
                                ?? type.GetProperty("instance", BindingFlags.Public | BindingFlags.Static)
                                ?? type.GetProperty("Instance", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);

            if (instanceProperty != null)
            {
                return instanceProperty.GetValue(null);
            }

            // Try common singleton field names
            var instanceField = type.GetField("Instance", BindingFlags.Public | BindingFlags.Static)
                             ?? type.GetField("instance", BindingFlags.Public | BindingFlags.Static)
                             ?? type.GetField("Instance", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);

            if (instanceField != null)
            {
                return instanceField.GetValue(null);
            }

            return null;
        }

        /// <summary>
        /// Safely invoke a method on an object using reflection
        /// </summary>
        public static object InvokeMethod(Type type, object instance, string methodName, object[] parameters = null)
        {
            if (type == null || instance == null)
                return null;

            try
            {
                var method = type.GetMethod(methodName,
                    BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);

                if (method != null)
                {
                    return method.Invoke(instance, parameters);
                }
            }
            catch (Exception ex)
            {
                Debug.LogError($"[GameUtilities] Failed to invoke method {methodName}: {ex.Message}");
            }

            return null;
        }

        /// <summary>
        /// Safely get a field value using reflection
        /// </summary>
        public static object GetFieldValue(Type type, object instance, string fieldName)
        {
            if (type == null || instance == null)
                return null;

            try
            {
                var field = type.GetField(fieldName,
                    BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);

                if (field != null)
                {
                    return field.GetValue(instance);
                }
            }
            catch (Exception ex)
            {
                Debug.LogError($"[GameUtilities] Failed to get field {fieldName}: {ex.Message}");
            }

            return null;
        }

        /// <summary>
        /// Safely set a field value using reflection
        /// </summary>
        public static void SetFieldValue(Type type, object instance, string fieldName, object value)
        {
            if (type == null || instance == null)
                return;

            try
            {
                var field = type.GetField(fieldName,
                    BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);

                if (field != null)
                {
                    field.SetValue(instance, value);
                }
            }
            catch (Exception ex)
            {
                Debug.LogError($"[GameUtilities] Failed to set field {fieldName}: {ex.Message}");
            }
        }

        /// <summary>
        /// Safely get a property value using reflection
        /// </summary>
        public static object GetPropertyValue(Type type, object instance, string propertyName)
        {
            if (type == null || instance == null)
                return null;

            try
            {
                var property = type.GetProperty(propertyName,
                    BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);

                if (property != null)
                {
                    return property.GetValue(instance);
                }
            }
            catch (Exception ex)
            {
                Debug.LogError($"[GameUtilities] Failed to get property {propertyName}: {ex.Message}");
            }

            return null;
        }

        /// <summary>
        /// Safely set a property value using reflection
        /// </summary>
        public static void SetPropertyValue(Type type, object instance, string propertyName, object value)
        {
            if (type == null || instance == null)
                return;

            try
            {
                var property = type.GetProperty(propertyName,
                    BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);

                if (property != null && property.CanWrite)
                {
                    property.SetValue(instance, value);
                }
            }
            catch (Exception ex)
            {
                Debug.LogError($"[GameUtilities] Failed to set property {propertyName}: {ex.Message}");
            }
        }

        /// <summary>
        /// Generate a random Vector3 within a range
        /// </summary>
        public static Vector3 RandomVector3(float min = -1f, float max = 1f)
        {
            return new Vector3(
                UnityEngine.Random.Range(min, max),
                UnityEngine.Random.Range(min, max),
                UnityEngine.Random.Range(min, max)
            );
        }

        /// <summary>
        /// Generate a random Quaternion
        /// </summary>
        public static Quaternion RandomQuaternion()
        {
            return Quaternion.Euler(
                UnityEngine.Random.Range(0f, 360f),
                UnityEngine.Random.Range(0f, 360f),
                UnityEngine.Random.Range(0f, 360f)
            );
        }
    }
}
