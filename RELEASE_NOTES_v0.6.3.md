## Important updater repair

KOBoard v0.6.3 repairs a recurring failure in the plugin's self-updater.

The updater bundled with v0.6.1 and v0.6.2 could terminate KOReader after
discovering a newer release. Its update-check result screen ran in an
unguarded callback, so a UI error became a fatal application error before the
new archive was downloaded. The previous installation path could also replace
files directly inside the live plugin directory, allowing a failed or partial
update to leave old and new plugin files mixed together.

### What changed

- Update checks are now guarded so an error is reported in KOReader instead of
  terminating the application.
- The update prompt uses KOReader's standard confirmation dialog.
- Android's system `unzip` command is used when KOReader does not provide an
  archive-extraction API.
- Downloads are extracted into a temporary staging directory.
- `_meta.lua`, `main.lua`, and `koboard_updater.lua` are validated before the
  installed plugin is touched.
- The complete staged plugin is activated with a directory swap.
- If activation fails, the previous plugin directory is restored.

### Manual update required from v0.6.1 or v0.6.2

Because the defect is inside the updater that must download this repair,
affected installations cannot reliably bootstrap v0.6.3 themselves. Users
running v0.6.1 or v0.6.2 should download `koboard.koplugin.zip` from this
release and install it manually once.

After v0.6.3 is installed, KOBoard's updater contains the repaired,
staged-installation path and can be used for subsequent releases.
