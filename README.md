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
haxelib git haxefmod https://github.com/Tanz0rz/haxe-fmod.git hashlink-refactor-build-cleanup
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

All targets work with standard `lime` commands. FMOD libraries and native bindings are automatically copied to the output directory — no extra steps needed.

Only 64-bit builds are supported. Lime defaults to 64-bit on 64-bit hosts, so no `-64` flag is needed.

```bash
lime test windows    # Windows C++
lime test mac        # macOS C++
lime test linux      # Linux C++
lime test hl         # HashLink (all platforms)
lime test html5      # HTML5
```

`lime test` builds and runs in one step. Use `lime build` if you only want to compile.

### HTML5

HTML5 builds require a startup scene to load FMOD before the game starts. See [source/LoadFmodState.hx](source/LoadFmodState.hx) and [source/Main.hx](source/Main.hx) in this repo for an example.

## Running This Test Project Locally

```bash
git clone https://github.com/Tanz0rz/haxe-fmod-test.git
cd haxe-fmod-test
./setup.sh
lime test hl
```

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
