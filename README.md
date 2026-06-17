# KOBoard

A KOReader plugin for Android that replaces the built-in virtual keyboard with the system IME (your default Android keyboard).

> **Experimental** — tested on Android with KOReader nightly builds. Behaviour may vary across devices and keyboard apps.

## Features

- Replaces KOReader's built-in keyboard with your system keyboard
- Full text input including backspace
- Works with any Android IME (Gboard, SwiftKey, etc.)

## Installation

1. Download `koboard.koplugin.zip` from the [latest release](https://github.com/titandrive/kboard/releases/latest) and unzip it, or clone this repo.
2. Copy the `koboard.koplugin` folder to `/sdcard/koreader/plugins/` on your device.
3. Restart KOReader.
4. Enable the plugin under **Tools → More tools → KOBoard**.

## How it works

KOBoard embeds a small compiled Java component (loaded at runtime via `DexClassLoader`) that registers a custom `InputConnection` with Android's `InputMethodManager`. This gives the system IME a real connection to type into. Keypresses and backspace are written to a file, which KOReader polls every 50ms and forwards to the active `VirtualKeyboard` instance.

## Building from source

Requirements: Android SDK (`android.jar` for API 34), `dx` or `d8`.

```bash
# Compile
javac -cp /path/to/android.jar -d build/android/classes android_src/org/koreader/koboard/*.java

# Dex
d8 --output build/android/dex build/android/classes/org/koreader/koboard/*.class

# Base64-encode and embed in main.lua
base64 -i build/android/dex/classes.dex | tr -d '\n' > build/koboard_ic.dex.b64
```

Then replace the `DEX_B64` string in `koboard.koplugin/main.lua` with the contents of `build/koboard_ic.dex.b64`.

## License

MIT
