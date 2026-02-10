# haxe-fmod-test

Integration test project for [haxe-fmod](https://github.com/Tanz0rz/haxe-fmod). This is a HaxeFlixel game (EZPlatformer) that uses haxefmod for audio, with CI that builds and validates across all supported platforms.

## How to Use haxefmod in Your Game

### 1. Install Prerequisites

**Haxe toolchain:**
- [Haxe 4.3+](https://haxe.org/download/)
- [Neko](https://nekovm.org/download/) (required by haxelib)
- [HashLink](https://hashlink.haxe.org/) (only if building HashLink targets)

**FMOD Studio:**

Download [FMOD Studio](https://fmod.com/download) (version 2.03.x) to create and manage your game audio. FMOD Studio builds `.bank` files that your game loads at runtime.

### 2. Install haxefmod

```bash
haxelib git haxefmod https://github.com/Tanz0rz/haxe-fmod.git hashlink-refactor-windows
```

Then install the required companion libraries:

```bash
haxelib install lime 8.3.0
haxelib install openfl 9.5.0
haxelib install flixel 6.1.2    # if using HaxeFlixel
haxelib install hxcpp 4.3.2     # if building C++ targets
```

### 3. Add to Your Project

Add `<haxelib name="haxefmod" />` to the Libraries section of your `Project.xml`:

```xml
<project>
    <!-- ... -->
    <haxelib name="flixel" />
    <haxelib name="haxefmod" />
    <!-- ... -->
</project>
```

### 4. Add FMOD Banks to Your Project

Set your FMOD Studio project to build banks into `assets/fmod/`:

1. Create `assets/fmod/` in your project directory
2. In FMOD Studio: Edit > Preferences > Build tab
3. Set "Built banks output directory" to your `assets/fmod/` folder

FMOD Studio will create `assets/fmod/Desktop/Master.bank` and `assets/fmod/Desktop/Master.strings.bank`.

### 5. Use in Code

```haxe
import haxefmod.FmodManager;

override public function create():Void {
    // Play background music
    FmodManager.PlaySong("event:/Music/MainLevel");

    // Play a one-shot sound effect
    FmodManager.PlaySoundOneShot("event:/SFX/Jump");
}

override public function update(elapsed:Float):Void {
    // Required to process async events
    FmodManager.Update();
}
```

See all available functions in [FmodManager.hx](https://github.com/Tanz0rz/haxe-fmod/blob/master/haxefmod/FmodManager.hx).

## Building Your Game

### HTML5

```bash
haxelib run lime build html5
```

HTML5 builds require a startup scene to load FMOD before the game starts. See [source/LoadFmodState.hx](source/LoadFmodState.hx) and [source/Main.hx](source/Main.hx) in this repo for an example.

### Windows C++

```bash
haxelib run lime build windows -64
```

FMOD DLLs are automatically copied into the output by the build system.

### Windows HashLink

```bash
# Build the game
haxelib run lime build hl

# Copy FMOD DLLs and hlaxe_fmod.hdll to the output directory
HAXEFMOD_DIR=$(haxelib path haxefmod | head -1)
BIN_DIR="export/hl/bin"
cp "$HAXEFMOD_DIR/lib/Windows/api/core/lib/x64/fmod.dll" "$BIN_DIR/"
cp "$HAXEFMOD_DIR/lib/Windows/api/studio/lib/x64/fmodstudio.dll" "$BIN_DIR/"
cp "$HAXEFMOD_DIR/native/hlaxe/hlaxe_fmod.hdll" "$BIN_DIR/"
```

Or use the provided build script:

```bash
HAXEFMOD_DIR=$(haxelib path haxefmod | head -1)
"$HAXEFMOD_DIR/scripts/build-hl.sh" .
```

### Linux C++

```bash
# Use the build script (copies FMOD .so files and creates run.sh)
HAXEFMOD_DIR=$(haxelib path haxefmod | head -1)
"$HAXEFMOD_DIR/scripts/build-linux.sh" .

# Run
./export/linux/bin/run.sh
```

The `run.sh` script sets `LD_LIBRARY_PATH` so the FMOD shared libraries are found at runtime.

### Linux HashLink

Requires building HashLink from source on Ubuntu 24.04 (the 1.15 release has mbedtls compatibility issues):

```bash
# Build HashLink from master
git clone --depth 1 https://github.com/HaxeFoundation/hashlink.git /tmp/hashlink-src
cd /tmp/hashlink-src && make -j$(nproc) && sudo make install && sudo ldconfig

# Compile hlaxe_fmod.hdll
HAXEFMOD_DIR=$(haxelib path haxefmod | head -1)
cd "$HAXEFMOD_DIR/native/hlaxe" && make

# Build and package
cd /path/to/your/project
"$HAXEFMOD_DIR/scripts/build-hl.sh" .

# Run
./export/hl/bin/run.sh
```

### macOS C++ (ARM64 only)

```bash
# Use the build script (copies dylibs into .app bundle)
HAXEFMOD_DIR=$(haxelib path haxefmod | head -1)
"$HAXEFMOD_DIR/scripts/build-mac.sh" .

# Run
open export/macos/bin/YourGame.app
```

### macOS HashLink (ARM64 only)

Requires Homebrew with `haxe`, `neko`, and `hashlink` installed:

```bash
brew install haxe neko hashlink
```

Then build:

```bash
HAXEFMOD_DIR=$(haxelib path haxefmod | head -1)

# Compile hlaxe_fmod.hdll
cd "$HAXEFMOD_DIR/native/hlaxe"
cc -dynamiclib -arch x86_64 -O2 -o hlaxe_fmod.hdll hlaxe_fmod.c \
    -I"$(brew --prefix hashlink)/include" \
    -I"$HAXEFMOD_DIR/lib/Mac/api/core/inc" \
    -I"$HAXEFMOD_DIR/lib/Mac/api/studio/inc" \
    -L"$HAXEFMOD_DIR/lib/Mac/api/core/lib" \
    -L"$HAXEFMOD_DIR/lib/Mac/api/studio/inc/lib" \
    -lfmod -lfmodstudio \
    -install_name @executable_path/hlaxe_fmod.hdll

# Build the game
cd /path/to/your/project
haxelib run lime build hl

# Copy FMOD files into the .app bundle
APP_BUNDLE=$(find export/hl -name "*.app" | head -1)
cp "$HAXEFMOD_DIR/native/hlaxe/hlaxe_fmod.hdll" "$APP_BUNDLE/Contents/MacOS/"
cp "$HAXEFMOD_DIR/lib/Mac/api/core/lib/libfmod.dylib" "$APP_BUNDLE/Contents/MacOS/"
cp "$HAXEFMOD_DIR/lib/Mac/api/studio/inc/lib/libfmodstudio.dylib" "$APP_BUNDLE/Contents/MacOS/"

# Run
open "$APP_BUNDLE"
```

## Running This Test Project Locally

```bash
git clone https://github.com/Tanz0rz/haxe-fmod-test.git
cd haxe-fmod-test
./setup.sh
```

Then build for your platform using the commands above.

## CI

This repo has a CI workflow that builds and validates across 7 platform/target combinations:

| Job | Platform | Target |
|-----|----------|--------|
| linux-cpp | Ubuntu | C++ (HXCPP) |
| linux-hl | Ubuntu | HashLink |
| linux-html5 | Ubuntu | HTML5 (Chromium) |
| mac-cpp | macOS ARM64 | C++ (HXCPP) |
| mac-hl | macOS ARM64 | HashLink |
| windows-cpp | Windows | C++ (HXCPP) |
| windows-hl | Windows | HashLink |

Each job validates:
1. **Build output** - correct binaries, FMOD banks, and dependencies present
2. **Audio output** - game produces audible audio (recorded via PulseAudio/FMOD WAVWRITER)
3. **Game logs** - FMOD initializes without errors
