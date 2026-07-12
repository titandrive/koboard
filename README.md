# koboard.koplugin

A KOReader plugin for Android that replaces KOReader's built-in virtual keyboard with the system IME (your default Android keyboard).

This fork adds improved support for Android IME suggestions and autocorrection, with a particular focus on Microsoft SwiftKey.

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

## SwiftKey suggestions and autocorrection

The original KOBoard implementation provides an Android