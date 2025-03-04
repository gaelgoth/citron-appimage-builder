#!/bin/bash

# =========================================================
# Title: Citron AppImage Build Steam Deck Script
# Description: Builds and runs an Arch Linux container inside Distrobox 
#              to create a Citron AppImage.
# =========================================================

set -e  # Exit immediately if any command fails

echo "======================================="
echo " Citron AppImage Build Steam Deck Script"
echo "======================================="
echo "This script will build a Citron AppImage using Distrobox."
echo "Distrobox should be preinstalled with SteamOS 3.5."
echo ""

# =========================================================
# CHECK FOR DISTROBOX INSTALLATION
# =========================================================
echo ">>> Checking for Distrobox installation..."
if ! command -v distrobox &> /dev/null; then
    echo -e "\n========================================================"
    echo "   ERROR: Distrobox is not installed on your system."
    echo "   Please install Distrobox manually or update your SteamOS to 3.5+."
    echo -e "========================================================\n"
    exit 1
fi

echo "✔ Distrobox is installed. Proceeding with setup..."
echo ""

# =========================================================
# ASK USER FOR VERSION SELECTION
# =========================================================
echo ">>> Select the Citron version to build:"
echo "  1. Latest master branch (nightly build)"
echo "  2. Citron Canary Refresh Version 0.5"
echo "  3. Citron Canary Refresh Version 0.4"
echo "  4. Specific version (Tag or Branch name)"
read -rp "Enter choice [1-4]: " VERSION_CHOICE

case "$VERSION_CHOICE" in
    1) CITRON_VERSION="master" ;;
    2) CITRON_VERSION="v0.5-canary-refresh" ;;
    3) CITRON_VERSION="v0.4-canary-refresh" ;;
    4) read -rp "Enter the version (Tag/Branch): " CITRON_VERSION ;;
    *) echo "Invalid choice. Defaulting to latest master branch."; CITRON_VERSION="master" ;;
esac
echo ""

# =========================================================
# ASK USER FOR BUILD MODE
# =========================================================
echo ">>> Select the build mode:"
echo "  1. SteamDeck optimizations"
echo "  2. Release mode"
echo "  3. Compatibility mode (for older architectures)"
echo "  4. Debug mode"
read -rp "Enter choice [1-4]: " BUILD_MODE_CHOICE

case "$BUILD_MODE_CHOICE" in
    1) CITRON_BUILD_MODE="steamdeck" ;;
    2) CITRON_BUILD_MODE="release" ;;
    3) CITRON_BUILD_MODE="compatibility" ;;
    4) CITRON_BUILD_MODE="debug" ;;
    *) echo "Invalid choice. Defaulting to SteamDeck optimizations."; CITRON_BUILD_MODE="steamdeck" ;;
esac
echo ""

# =========================================================
# ASK USER ABOUT CACHING GIT REPOSITORY
# =========================================================
echo ">>> Do you want to cache the Git repository for subsequent builds?"
echo "  1. Yes (may use ~1 GB of disk space)"
echo "  2. No (default)"
read -rp "Enter choice [1-2]: " CACHE_REPO

USE_CACHE=false
if [[ "$CACHE_REPO" == "1" ]]; then
    USE_CACHE=true
fi
echo ""

# =========================================================
# ASK USER ABOUT OUTPUTTING LINUX BINARIES
# =========================================================
echo ">>> Do you want to output Linux binaries?"
echo "  1. Yes"
echo "  2. No (default)"
read -rp "Enter choice [1-2]: " OUTPUT_BINARIES

OUTPUT_LINUX_BINARIES=false
if [[ "$OUTPUT_BINARIES" == "1" ]]; then
    OUTPUT_LINUX_BINARIES=true
fi
echo ""

# =========================================================
# CREATE AND ENTER DISTROBOX CONTAINER
# =========================================================
CONTAINER_NAME="citron-builder"

echo ">>> Checking if Distrobox container '$CONTAINER_NAME' exists..."
if ! distrobox list | grep -q "$CONTAINER_NAME"; then
    echo "Creating a new Distrobox container with Arch Linux..."
    distrobox create --name "$CONTAINER_NAME" --yes --image archlinux:latest --additional-packages "base-devel boost catch2 cmake ffmpeg fmt git glslang libzip lz4 mbedtls ninja nlohmann-json openssl opus qt5 sdl2 zlib zstd zip unzip qt6-base qt6-tools qt6-svg qt6-declarative qt6-webengine sdl3 qt6-multimedia clang qt6-wayland fuse2 rapidjson wget sdl3 dos2unix"
else
    echo "Using existing Distrobox container '$CONTAINER_NAME'."
    echo "If you encounter issues, try removing it manually with: 'distrobox rm -f $CONTAINER_NAME'."
fi
echo ""

# =========================================================
# SET OUTPUT AND WORKING DIRECTORIES
# =========================================================
OUTPUT_DIR="$(pwd)"
WORKING_DIR="$(pwd)/workdir"
mkdir -p "$WORKING_DIR"
chmod 777 "$WORKING_DIR"

# =========================================================
# ENTERING AND PREPARING THE DISTROBOX CONTAINER
# =========================================================
echo ">>> Entering and preparing the Distrobox container..."

distrobox enter --additional-flags "--env CITRON_VERSION=$CITRON_VERSION --env CITRON_BUILD_MODE=$CITRON_BUILD_MODE --env USE_CACHE=$USE_CACHE --env OUTPUT_LINUX_BINARIES=$OUTPUT_LINUX_BINARIES --env OUTPUT_DIR=$OUTPUT_DIR --env WORKING_DIR=$WORKING_DIR" "$CONTAINER_NAME" -- bash << 'EOF'
    dos2unix ./build-citron.sh
    chmod +x ./build-citron.sh

    echo ">>> Inside container, executing build script..."
    ./build-citron.sh
EOF

# =========================================================
# CLEANUP WORKING DIRECTORY
# =========================================================
echo ">>> Cleaning up working directory..."
rm -rf "$WORKING_DIR"
echo "✔ Cleanup complete."
echo ""

# =========================================================
# ASK USER TO REMOVE DISTROBOX CONTAINER
# =========================================================
read -rp "Do you want to remove the '$CONTAINER_NAME' Distrobox container? ([Y]/n): " DELETE_BOX
if [[ "$DELETE_BOX" =~ ^[Yy]?$ ]]; then
    distrobox rm --force "$CONTAINER_NAME"
    echo "✔ Distrobox container removed."
else
    echo "✔ Distrobox container kept."
fi
echo ""

# =========================================================
# ASK USER TO DELETE CACHED GIT REPOSITORY
# =========================================================
if [ -f citron.tar.zst ]; then
    read -rp "Do you want to delete the cached repository file citron.tar.zst to free up space? (y/[N]): " DELETE_CACHE
    if [[ "$DELETE_CACHE" =~ ^[Yy]$ ]]; then
        rm -f citron.tar.zst
        echo "✔ Cache deleted."
    else
        echo "✔ Cache kept."
    fi
fi
