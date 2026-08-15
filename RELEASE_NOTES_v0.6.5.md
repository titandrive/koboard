## Android keyboard auto-capitalization

KOBoard v0.6.5 restores automatic sentence capitalization in Android keyboards
such as Gboard.

KOBoard now identifies its editor as sentence-capable text input and reports the
capitalization mode at the current cursor position. Keyboards can therefore
capitalize the first letter of an empty field and the first letter after a
sentence boundary while continuing to respect the user's keyboard preference.
