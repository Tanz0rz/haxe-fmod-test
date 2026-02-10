# haxe-fmod-test

A minimal [HaxeFlixel](https://haxeflixel.com/) game demonstrating how to use [haxefmod](https://github.com/Tanz0rz/haxe-fmod) for audio. Clone this repo as a starting point or reference for adding FMOD to your own game.

## Quick Start

```bash
git clone https://github.com/Tanz0rz/haxe-fmod-test.git
cd haxe-fmod-test
./setup.sh
lime test hl
```

## What This Demonstrates

- Adding haxefmod to a HaxeFlixel project ([Project.xml](Project.xml))
- Playing background music and sound effects ([source/PlayState.hx](source/PlayState.hx))
- FMOD bank file layout (`assets/fmod/Desktop/`)
- HTML5 FMOD preloader ([source/LoadFmodState.hx](source/LoadFmodState.hx))

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
