#!/bin/bash
# Setup script for haxe-fmod-test
# Installs all required Haxe libraries including haxefmod from the target branch.
#
# Usage: ./setup.sh
#
# For local development with a local haxe-fmod checkout, use:
#   haxelib dev haxefmod /path/to/haxe-fmod
# instead of running this script.

set -e

HAXEFMOD_BRANCH="${HAXEFMOD_BRANCH:-hashlink-refactor}"
HAXEFMOD_REPO="${HAXEFMOD_REPO:-https://github.com/Tanz0rz/haxe-fmod.git}"

echo "=== haxe-fmod-test setup ==="
echo "  haxefmod branch: $HAXEFMOD_BRANCH"
echo ""

# Ensure haxelib is configured
if [ ! -d ~/haxelib ]; then
  mkdir -p ~/haxelib
  haxelib setup ~/haxelib
fi

# Install dependencies
haxelib install lime 8.3.0 --always --quiet
haxelib install openfl 9.5.0 --always --quiet
haxelib install flixel 6.1.2 --always --quiet
haxelib install hxcpp 4.3.2 --always --quiet

# Remove any existing haxefmod installation (git, dev, or haxelib)
haxelib remove haxefmod 2>/dev/null || true

# Install haxefmod fresh from git branch
echo "Installing haxefmod from $HAXEFMOD_REPO @ $HAXEFMOD_BRANCH"
haxelib git haxefmod "$HAXEFMOD_REPO" "$HAXEFMOD_BRANCH" --always

# Setup lime
yes | haxelib run lime setup || true

echo ""
echo "=== Setup complete ==="
echo "Build with: haxelib run lime build <target>"
echo "  Targets: linux, mac, windows, hl, html5"
