# KOBoard v0.6.0 — Suggestions, autocorrection, and synchronized editing

This release significantly improves KOBoard's support for modern Android keyboards, especially Microsoft SwiftKey.

The original suggestions and autocorrection work was contributed by [Gerardo Martínez (`gerardomtz26`)](https://github.com/gerardomtz26). You can view [Gerardo's four original commits and changes](https://github.com/titandrive/koboard/compare/f0bac13...0b089f4). Thank you, Gerardo, for making this release possible.

## What's new

- Predictive suggestions and autocorrection.
- Android composing-text support.
- Improved Microsoft SwiftKey compatibility.
- Complete text and cursor synchronization between KOReader and Android.
- Correct editing after tapping within existing text, including after reopening the keyboard.
- Correct cursor handling around emoji and other supplementary Unicode characters.
- More reliable input transport using atomic file snapshots.
- Removal of development logging that recorded typed text.
- The updater remains pointed at the official `titandrive/koboard` repository.

## What users will see

Suggestions and autocorrections should replace the intended word without duplicating text. You can move the cursor within a field and continue typing or deleting at that location instead of being returned to the beginning or end.

Keyboard selection gestures can select and delete text, although KOReader does not currently display a visible highlight for the selected range.

## Reliability

The Java-to-Lua bridge now publishes complete editor states through atomic file snapshots. This prevents a timing race that could lose characters, corrections, or cursor updates while Lua was reading and clearing the input file.

## Testing

The release was compiled against Android API 34, converted to DEX, installed over ADB, and tested on a physical Android device. Testing covered typing, backspace, suggestions, autocorrection, composing text, cursor movement, reopening the keyboard, emoji, selection deletion, and rapid input.

Java compilation, Lua syntax, embedded DEX consistency, and ZIP integrity checks passed.

## Known limitations

- Android only.
- Android selection ranges are not visibly highlighted by KOReader.
- Keyboard-specific gestures may vary by keyboard application and version.
- A small delay may be perceptible during rapid composing updates because KOReader polls the file bridge.

## Upgrade

Install the attached `koboard.koplugin.zip` or use KOBoard's built-in updater, then restart KOReader. Existing settings are preserved.

Gerardo Martínez's original authored commits remain in the project history, followed by the maintainer synchronization, reliability, and packaging work.
