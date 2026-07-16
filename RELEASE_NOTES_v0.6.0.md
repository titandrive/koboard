# KOBoard v0.6.0 — Android IME suggestions, autocorrection, and synchronized editing

KOBoard v0.6.0 is a substantial upgrade to the Android system-keyboard bridge. Modern Android keyboards can now use composing text, predictive suggestions, and autocorrection while remaining synchronized with the text and cursor shown by KOReader.

The initial SwiftKey support was contributed by [Gerardo Martínez (`gerardomtz26`)](https://github.com/gerardomtz26) in the [original contribution](https://github.com/titandrive/koboard/compare/main...gerardomtz26:koboard:main). The maintainer follow-up expanded that work into bidirectional editor synchronization, corrected cursor handling, removed development logging, restored official update behavior, and hardened the file bridge. Thank you, Gerardo, for developing and sharing the feature that made this release possible.

## What users will notice

### Suggestions and autocorrection

Android keyboards can now offer predictive suggestions and replace misspelled or partially composed words. Choosing a suggestion should replace the intended word instead of appending duplicate text. Autocorrection can also revise a word after a space or punctuation mark is entered.

This is especially useful with Microsoft SwiftKey, which motivated the original contribution, and uses standard Android `InputConnection` composing APIs that may also benefit other keyboards.

### Correct editing at the cursor

KOBoard now synchronizes the complete field contents and cursor position between KOReader and Android. Users can:

- Tap within existing text and continue typing at that position.
- Move the cursor without closing the keyboard.
- Close and reopen the keyboard, tap within existing text, and edit there.
- Backspace or accept corrections away from the end of the field.
- Edit text containing emoji and other characters represented by UTF-16 surrogate pairs.

Previously, Android only knew about text entered through the current input connection. Advanced edits could therefore be applied at the beginning or end of the field rather than at KOReader's visible cursor.

### Composing-text support

The Android editor now maintains the temporary composing range used while a keyboard is building or correcting a word. KOBoard publishes the resulting complete editor state to KOReader after composition, commit, deletion, or selection operations.

### Functional keyboard selection gestures

Keyboard gestures that select text before deleting it are preserved inside Android. For example, a backspace-selection gesture can select a range and delete it on release.

KOReader does not currently expose a live arbitrary-range highlight through its input widget, so the selected range may not be visibly highlighted even though the deletion or replacement works. This is a display limitation, not loss of the Android selection.

## Reliability and privacy improvements

### Atomic editor-state snapshots

Java no longer appends messages to a file that Lua later reads and truncates. That approach had a small race in which Java could append an update after Lua read the file but before Lua cleared it, causing the new update to be lost.

Java now writes each complete editor state to a temporary file and publishes it by rename. Lua first claims that complete snapshot by renaming it again, then reads and removes the claimed copy. Intermediate composing states may be replaced by a newer complete state, but Lua cannot erase a state that Java is still writing.

Users should see fewer opportunities for missing characters, reverted autocorrections, or ignored cursor updates during rapid input.

### No typed-text debug log

Development logging introduced in the original fork has been removed. KOBoard does not maintain a separate debug file containing users' typed text, and the temporary diagnostics used during device testing are not included in the release.

### Official updater retained

The built-in updater continues to check releases from [`titandrive/koboard`](https://github.com/titandrive/koboard). It does not redirect installed copies to a contributor fork.

## Technical summary

- Enables standard text suggestions by removing Android's `TYPE_TEXT_FLAG_NO_SUGGESTIONS` editor flag.
- Implements composing, committed-text, surrounding-text deletion, selection, and extracted-text behavior through `BaseInputConnection`.
- Initializes Android's editable buffer with KOReader's complete text and cursor position.
- Synchronizes later KOReader cursor changes back to Android and calls `InputMethodManager.updateSelection()`.
- Converts between KOReader's character positions and Android UTF-16 offsets, including supplementary Unicode characters such as emoji.
- Defers opening the Android IME briefly so KOReader can finish positioning the cursor from the tap that opened the keyboard.
- Casts cursor offsets explicitly to JNI `jint` values, preventing positions from being passed incorrectly through LuaJIT's JNI varargs boundary.
- Publishes complete state messages as Base64-encoded UTF-8, allowing multiline and Unicode text to cross the line-oriented file bridge safely.
- Publishes editor state using atomic file snapshots instead of read-and-truncate queue handling.
- Rebuilds the embedded Android DEX and `koboard.koplugin.zip` for version 0.6.0.

## Testing performed

The release was compiled against Android API 34, converted to DEX with Android build tools, installed over ADB, and exercised in KOReader on a physical Android device.

The tested scenarios included:

- Normal typing and backspace.
- Predictive suggestions and autocorrection.
- Composing-text updates.
- Cursor movement followed by insertion and deletion.
- Closing and reopening the keyboard before editing existing text.
- Emoji and UTF-16 cursor positioning.
- Backspace selection followed by deletion.
- Rapid input after switching the bridge to atomic snapshots.

The Lua source parses successfully, the Java source compiles successfully, the embedded DEX matches the rebuilt Java component, and the release ZIP passes archive-integrity checks.

## Known limitations

- Android only; the plugin has no effect on Kindle, Kobo, or other non-Android platforms.
- Live Android selection ranges are not visibly highlighted by KOReader, although selection-based deletion and replacement can work.
- Swipe-to-select and other keyboard-specific gestures may vary by keyboard application and version.
- Input still crosses a file-based bridge polled by KOReader, so a small delay may be perceptible during rapid composing updates.
- Voice input, handwriting, complex non-Latin IMEs, multiline fields, password fields, and every Android keyboard have not all been exhaustively tested.

## Upgrade notes

Install `koboard.koplugin.zip` as usual or use KOBoard's built-in updater after the v0.6.0 release is published. Restart KOReader after installation so the new embedded DEX is loaded.

Existing KOBoard enable/disable and update-notification settings are preserved. No settings migration is required.

## Attribution

- **Gerardo Martínez (`gerardomtz26`)** — original SwiftKey suggestions, autocorrection, composing-text support, documentation, version bump, and initial v0.6.0 archive.
- **KOBoard maintainer (`titandrive`)** — security and repository cleanup, bidirectional text/cursor synchronization, UTF-16/JNI cursor fixes, device testing, and atomic snapshot transport.

The contributor's original commits remain in the project history with Gerardo Martínez recorded as their author.
