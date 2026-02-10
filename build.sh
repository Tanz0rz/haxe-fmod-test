#!/bin/bash
# Build haxe-fmod-test for a given target.
# Usage: ./build.sh <target>
#
# All targets use plain `lime build` commands. haxefmod's include.xml
# handles FMOD library copying automatically via <templatePath> (HL),
# <postbuild> (C++ Mac/Linux), and <dependency> (C++ Windows).

set -e

TARGET="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <target>"
    echo ""
    echo "Targets:"
    echo "  html5       - HTML5 build"
    echo "  linux       - Linux C++ build"
    echo "  mac         - macOS C++ build"
    echo "  hl          - HashLink build (all platforms)"
    echo "  windows     - Windows C++ build"
    exit 1
fi

cd "$SCRIPT_DIR"

case "$TARGET" in
    html5)
        haxelib run lime build html5
        ;;
    linux)
        haxelib run lime build linux -64
        ;;
    mac)
        haxelib run lime build mac -64
        ;;
    hl)
        haxelib run lime build hl
        ;;
    windows)
        haxelib run lime build windows -64
        ;;
    *)
        echo "Unknown target: $TARGET"
        echo "Run '$0' with no arguments to see available targets."
        exit 1
        ;;
esac
