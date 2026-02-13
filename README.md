# haxe-fmod-test

A minimal [HaxeFlixel](https://haxeflixel.com/) game demonstrating how to use [haxefmod](https://github.com/Tanz0rz/haxe-fmod) for audio. Clone this repo as a starting point or reference for adding FMOD to your own game.

## Quick Start

**Linux/macOS:**
```bash
git clone https://github.com/Tanz0rz/haxe-fmod-test.git
cd haxe-fmod-test
./setup.sh
lime test hl
```

**Windows:**
```cmd
git clone https://github.com/Tanz0rz/haxe-fmod-test.git
cd haxe-fmod-test
setup.cmd
lime test hl
```

## What This Demonstrates

- Adding haxefmod to a HaxeFlixel project ([Project.xml](Project.xml))
- Playing background music and sound effects ([source/PlayState.hx](source/PlayState.hx))
- Auto-generated `FmodSongs` and `FmodSFX` constants for type-safe event references ([source/FmodConstants.hx](source/FmodConstants.hx))
- Global imports via [source/import.hx](source/import.hx) so `FmodManager`, `FmodSongs`, and `FmodSFX` are available everywhere
- FMOD bank file layout (`assets/fmod/Desktop/`)
- HTML5 FMOD preloader ([source/LoadFmodState.hx](source/LoadFmodState.hx))

## FMOD Studio Helper Script

haxe-fmod includes an [FMOD Studio script](https://github.com/Tanz0rz/haxe-fmod/tree/master/fmod-scripts) that auto-generates a `FmodConstants.hx` file from your FMOD Studio project. This gives you autocomplete for all your sound events:

```haxe
FmodManager.PlaySong(FmodSongs.MainLevel);        // instead of "event:/Music/MainLevel"
FmodManager.PlaySoundOneShot(FmodSFX.Coin);        // instead of "event:/SFX/Coin"
```

See the [fmod-scripts README](https://github.com/Tanz0rz/haxe-fmod/tree/master/fmod-scripts) for setup instructions.

## Adding haxefmod to Your Own Game

See the [haxe-fmod README](https://github.com/Tanz0rz/haxe-fmod#how-to-use-this-library) for installation and usage instructions. The key steps are:

1. Install haxefmod via haxelib
2. Add `<haxelib name="haxefmod" />` to your `Project.xml`
3. Build your FMOD Studio banks into `assets/fmod/`
4. Use `FmodManager` in your code

All targets work with standard lime commands:

```bash
lime test windows
lime test mac
lime test linux
lime test hl
lime test html5
```
