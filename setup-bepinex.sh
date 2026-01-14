#!/bin/bash

# BepInEx Setup Script
# Downloads and extracts required BepInEx assemblies for mod development

set -e

LIBS_DIR="./libs"
BEPINEX_VERSION="5.4.23.2"
BEPINEX_URL="https://github.com/BepInEx/BepInEx/releases/download/v${BEPINEX_VERSION}/BepInEx_x64_${BEPINEX_VERSION}.0.zip"
TEMP_DIR="./temp_bepinex"

echo "========================================="
echo "BepInEx Dependency Setup"
echo "========================================="
echo ""

# Create libs directory if it doesn't exist
if [ ! -d "$LIBS_DIR" ]; then
    echo "Creating libs directory..."
    mkdir -p "$LIBS_DIR"
fi

# Create temp directory
echo "Creating temporary directory..."
mkdir -p "$TEMP_DIR"

# Download BepInEx
echo "Downloading BepInEx v${BEPINEX_VERSION}..."
if command -v curl &> /dev/null; then
    curl -L "$BEPINEX_URL" -o "$TEMP_DIR/bepinex.zip"
elif command -v wget &> /dev/null; then
    wget "$BEPINEX_URL" -O "$TEMP_DIR/bepinex.zip"
else
    echo "ERROR: Neither curl nor wget found. Please install one of them."
    exit 1
fi

# Extract BepInEx
echo "Extracting BepInEx..."
if command -v unzip &> /dev/null; then
    unzip -q "$TEMP_DIR/bepinex.zip" -d "$TEMP_DIR"
else
    echo "ERROR: unzip not found. Please install unzip."
    exit 1
fi

# Copy required DLLs
echo "Copying required assemblies to libs folder..."

# Core BepInEx files
if [ -f "$TEMP_DIR/BepInEx/core/BepInEx.dll" ]; then
    cp "$TEMP_DIR/BepInEx/core/BepInEx.dll" "$LIBS_DIR/"
    echo "  ✓ BepInEx.dll"
fi

if [ -f "$TEMP_DIR/BepInEx/core/BepInEx.Core.dll" ]; then
    cp "$TEMP_DIR/BepInEx/core/BepInEx.Core.dll" "$LIBS_DIR/"
    echo "  ✓ BepInEx.Core.dll"
fi

if [ -f "$TEMP_DIR/BepInEx/core/0Harmony.dll" ]; then
    cp "$TEMP_DIR/BepInEx/core/0Harmony.dll" "$LIBS_DIR/"
    echo "  ✓ 0Harmony.dll"
fi

if [ -f "$TEMP_DIR/BepInEx/core/Mono.Cecil.dll" ]; then
    cp "$TEMP_DIR/BepInEx/core/Mono.Cecil.dll" "$LIBS_DIR/"
    echo "  ✓ Mono.Cecil.dll"
fi

# Clean up
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

echo ""
echo "========================================="
echo "BepInEx setup completed successfully!"
echo "========================================="
echo ""
echo "The following assemblies are now in $LIBS_DIR:"
ls -1 "$LIBS_DIR"/*.dll 2>/dev/null | xargs -n1 basename
echo ""
echo "Note: You still need Unity DLLs (UnityEngine.dll, etc.)"
echo "These should be extracted from your Gorilla Tag installation."
echo ""
