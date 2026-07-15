# koboard.koplugin

A KOReader plugin for Android that replaces KOReader's built-in virtual keyboard with the system IME (your default Android keyboard).

> **Android only** — this plugin does nothing on Kindle, Kobo, or other non-Android devices.

> **Experimental** — tested on Android with KOReader. Behaviour may vary across devices, Android versions, KOReader versions, and keyboard apps.

## Features

- Replaces KOReader's built-in keyboard with your Android system keyboard
- Predictive text suggestions through the Android IME
- Autocorrection support
- Improved compatibility with Microsoft SwiftKey
- Basic composing-text support used by modern Android keyboards
- Full text input including backspace
- Minimal KOBoard UI under **Tools → KOBoard** with an enable/disable toggle
- Update checker with optional background notifications
- Dispatcher actions for automation

## Limitations

Input is routed through a file-based bridge between the Android IME and KOReader. Basic typing, backspace, composing text, suggestions, and autocorrection are supported, but selection and cursor movement may vary across keyboard apps. Swipe-to-select and swipe-to-delete are not supported.

## Installation

1. Download `koboard.koplugin.zip` from the [latest release](https://github.com/titandrive/koboard/releases/latest) and unzip it, or clone this repo.
2. Copy the `koboard.koplugin` folder to `/sdcard/koreader/plugins/` on your device.
3. Restart KOReader.
4. Enable the plugin from the KOBoard UI under **Tools → KOBoard**.

Once enabled, KOBoard activates automatically whenever a text field is opened. To temporarily use KOReader's built-in keyboard, open **Tools → KOBoard** and turn **Enable KOBoard** off.

## Menu and updates

KOBoard includes controls under **Tools → KOBoard**:

- **Enable KOBoard** turns the Android keyboard bridge on or off.
- **Notify on wake when update available** controls background update checks.
- **Installed version: vX.Y.Z** checks GitHub releases for a newer version.

KOBoard also registers dispatcher actions: `koboard_enable`, `koboard_disable`, and `koboard_toggle`.

## How it works

KOBoard embeds a small compiled Java component loaded at runtime with `DexClassLoader`. It registers a custom `InputConnection` with Android's `InputMethodManager`. Input operations are written to a file, which KOReader polls and forwards to the active `VirtualKeyboard` instance.

## Building from source

Requirements: Android SDK (`android.jar` for API 34), a JDK, and `d8`.

```bash
javac -cp /path/to/android.jar -d build/android/classes android_src/org/koreader/koboard/*.java
d8 --output build/android/dex build/android/classes/org/koreader/koboard/*.class
base64 -i build/android/dex/classes.dex | tr -d '\n' > build/koboard_ic.dex.b64
```

Replace the `DEX_B64` string in `koboard.koplugin/main.lua` with the contents of `build/koboard_ic.dex.b64`, then rebuild `koboard.koplugin.zip`.

## License

MIT
