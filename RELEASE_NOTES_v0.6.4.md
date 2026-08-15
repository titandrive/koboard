## Native keyboard dialog layout fix

KOBoard v0.6.4 keeps KOReader input-dialog buttons above the Android system
keyboard.

KOBoard now measures the bottom region occupied by the active Android IME and
passes that height to KOReader's existing input-dialog layout. The measurement
uses physical display coordinates, avoiding incorrect results on fullscreen
Android devices whose application content area is shorter than the display.

The measured height is retained when KOReader recreates an input dialog, so the
layout settles after one resize without repeatedly closing and reopening the
keyboard.

This adapts automatically to screen resolution, orientation, suggestion rows,
and the height of a normally docked keyboard. Floating and split keyboards do
not reserve one continuous bottom region and are not covered by this fix.
