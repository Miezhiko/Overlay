#!/bin/bash
set -euo pipefail

# MTGA Updater for Gentoo / main ~/.wine prefix
# Dependencies: wine, jq, curl

WINEPREFIX="${WINEPREFIX:-$HOME/.wine}"
export WINEPREFIX
export WINEARCH=win64

WINE_BIN="${WINE_BIN:-wine}"

# Cache must be user-writable (script is installed to /usr/bin)
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/mtga-update"
mkdir -p "$CACHE_DIR"

echo "=== MTGA Updater (Gentoo) ==="
echo "WINEPREFIX: $WINEPREFIX"
echo "Wine binary: $WINE_BIN"
echo "Cache dir:  $CACHE_DIR"

if [ ! -d "$WINEPREFIX" ]; then
    echo "ERROR: WINEPREFIX '$WINEPREFIX' does not exist."
    echo "This script updates an existing install; it does not create one."
    exit 1
fi

GAME_DIR="$WINEPREFIX/drive_c/Program Files/Wizards of the Coast/MTGA"
if [ ! -d "$GAME_DIR" ]; then
    echo "WARNING: Expected game dir not found:"
    echo "  $GAME_DIR"
    echo "Continuing anyway, but double-check your prefix."
fi

export WINEDEBUG="${WINEDEBUG:--all}"

echo "Checking for latest version..."
VERSION_JSON=$(curl -fsSL https://mtgarena.downloads.wizards.com/Live/Windows32/version)
MSI_URL=$(echo "$VERSION_JSON" | jq -r '.CurrentInstallerURL')

if [ -z "$MSI_URL" ] || [ "$MSI_URL" = "null" ]; then
    echo "ERROR: Could not parse CurrentInstallerURL from version JSON."
    echo "Raw response:"
    echo "$VERSION_JSON"
    exit 1
fi

CURRENT_VERSION=$(basename "$MSI_URL")
echo "Latest installer: $CURRENT_VERSION"

VERSION_FILE="$CACHE_DIR/installed_version"
if [ -f "$VERSION_FILE" ] && [ "$(cat "$VERSION_FILE")" = "$CURRENT_VERSION" ]; then
    echo "Already up to date ($CURRENT_VERSION)."
    if [ "${1:-}" != "--force" ]; then
        echo "Run with --force to reinstall."
        exit 0
    fi
    echo "Force reinstall requested."
fi

INSTALLER_PATH="$CACHE_DIR/$CURRENT_VERSION"
if [ -f "$INSTALLER_PATH" ]; then
    echo "Installer already cached: $INSTALLER_PATH"
else
    echo "Downloading $MSI_URL ..."
    curl -fL "$MSI_URL" --output "$INSTALLER_PATH"
    echo "Download complete."
fi

echo "Running installer via Wine (silent)..."
"$WINE_BIN" msiexec /i "$INSTALLER_PATH" /quiet
echo "Installation complete."

echo "$CURRENT_VERSION" > "$VERSION_FILE"

echo "=== Done ==="
echo "Launch with:"
echo "  WINEPREFIX=\"$WINEPREFIX\" wine \"$GAME_DIR/MTGA.exe\""
