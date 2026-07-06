# koboard.koplugin

A KOReader plugin for Android that replaces the built-in virtual keyboard with the system IME (your default Android keyboard).

> **Android only** — this plugin does nothing on Kindle, Kobo, or other non-Android devices.

> **Experimental** — tested on Android with KOReader nightly builds. Behaviour may vary across devices and keyboard apps.

## Features

- Replaces KOReader's built-in keyboard with your system keyboard
- Minimal KOBoard menu with an enable/disable toggle
- Full text input including backspace
- Tested with Gboard, Samsung Keyboard, and Heliboard

<img width="175" alt="image" src="https://github.com/user-attachments/assets/5a0a6aad-2b39-445f-824f-fe436d749736" />


## Limitations

Input is routed through a file-based bridge between the Android IME and KOReader, which means basic typing and backspace work but advanced IME features do not. Swipe gestures (swipe-to-select, swipe-to-delete) will not work. Autocorrect may work depending on your keyboard app.

## Installation

1. Download `koboard.koplugin.zip` from the [latest release](https://github.com/titandrive/koboard/releases/latest) and unzip it, or clone this repo.
2. Copy the `koboard.koplugin` folder to `/sdcard/koreader/plugins/` on your device.
3. Restart KOReader.
4. Enable the plugin under **Tools → More tools → KOBoard**.

Once the plugin is enabled, KOBoard activates automatically whenever a text field is opened. To temporarily use KOReader's built-in keyboard instead, open **Tools → KOBoard** and turn **Enable KOBoard** off. The KOBoard menu also includes an **Update** entry reserved for the updater flow.

KOBoard also registers dispatcher actions for automation: `koboard_enable`, `koboard_disable`, and `koboard_toggle`.

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
