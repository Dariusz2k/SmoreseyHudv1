#!/bin/bash
# Quick build script for Linux environments
# This compiles the C# project using mcs (Mono C# compiler)

echo "=========================================="
echo "Building GTag Mod Menu"
echo "=========================================="
echo ""

cd GTagSpeedMod

# Find all .cs files
CS_FILES=$(find . -name "*.cs" -type f)

echo "Found C# files:"
echo "$CS_FILES"
echo ""

# Build with mcs if available
if command -v mcs &> /dev/null; then
    echo "Using Mono C# compiler (mcs)..."
    mcs -target:library \
        -out:bin/Release/GTagSpeedMod.dll \
        -r:../libs/BepInEx.dll \
        -r:../libs/0Harmony.dll \
        -r:../libs/UnityEngine.dll \
        -r:../libs/UnityEngine.CoreModule.dll \
        -r:../libs/UnityEngine.IMGUIModule.dll \
        -r:../libs/UnityEngine.InputLegacyModule.dll \
        -r:../libs/UnityEngine.UI.dll \
        -r:../libs/Assembly-CSharp.dll \
        $CS_FILES

    if [ $? -eq 0 ]; then
        echo ""
        echo "=========================================="
        echo "Build Successful!"
        echo "=========================================="
        echo ""
        echo "Output: GTagSpeedMod/bin/Release/GTagSpeedMod.dll"
        echo ""
        echo "To deploy, copy to:"
        echo "  <Gorilla Tag>/BepInEx/plugins/GTagSpeedMod.dll"
    else
        echo ""
        echo "Build failed!"
        exit 1
    fi
else
    echo "ERROR: mcs (Mono C# compiler) not found"
    echo ""
    echo "On Windows, use MSBuild instead:"
    echo "  msbuild GTagSpeedMod.csproj /p:Configuration=Release"
    echo ""
    echo "Or run build-and-deploy.bat"
    exit 1
fi

cd ..
