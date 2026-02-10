#!/bin/bash
# Build haxe-fmod-test for a given target.
# Usage: ./build.sh <target>
#
# This script finds the haxefmod library via haxelib and calls the
# appropriate build script.

set -e

TARGET="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <target>"
    echo ""
    echo "Targets:"
    echo "  html5       - HTML5 build"
    echo "  linux       - Linux C++ build"
    echo "  mac         - macOS C++ build (ARM64 only)"
    echo "  hl          - HashLink build (auto-detects platform)"
    echo "  hl-linux    - Linux HashLink build"
    echo "  hl-mac      - macOS HashLink build (ARM64 only)"
    echo "  windows     - Windows C++ build"
    exit 1
fi

# Resolve haxefmod library path
HAXEFMOD_DIR=$(haxelib path haxefmod 2>/dev/null | head -1)
if [ -z "$HAXEFMOD_DIR" ] || [ ! -d "$HAXEFMOD_DIR" ]; then
    echo "Error: haxefmod not found. Run ./setup.sh first."
    exit 1
fi
echo "Using haxefmod at: $HAXEFMOD_DIR"

case "$TARGET" in
    html5)
        cd "$SCRIPT_DIR"
        haxelib run lime build html5
        ;;
    linux)
        "$HAXEFMOD_DIR/scripts/build-linux.sh" "$SCRIPT_DIR"
        ;;
    mac)
        "$HAXEFMOD_DIR/scripts/build-mac.sh" "$SCRIPT_DIR"
        ;;
    hl-linux)
        "$HAXEFMOD_DIR/scripts/build-hl-linux.sh" "$SCRIPT_DIR"
        ;;
    hl-mac)
        "$HAXEFMOD_DIR/scripts/build-hl-mac.sh" "$SCRIPT_DIR"
        ;;
    hl)
        case "$(uname -s)" in
            Darwin)  "$HAXEFMOD_DIR/scripts/build-hl-mac.sh" "$SCRIPT_DIR" ;;
            Linux)   "$HAXEFMOD_DIR/scripts/build-hl-linux.sh" "$SCRIPT_DIR" ;;
            *)       "$HAXEFMOD_DIR/scripts/build-hl.sh" "$SCRIPT_DIR" ;;
        esac
        ;;
    windows)
        cd "$SCRIPT_DIR"
        haxelib run lime build windows -64
        ;;
    *)
        echo "Unknown target: $TARGET"
        echo "Run '$0' with no arguments to see available targets."
        exit 1
        ;;
esac
