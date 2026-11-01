# CLAUDE.md

This is a fork of QMK firmware (early 2022). The only work done here is on the Lily58 keymaps:

- `keyboards/lily58/keymaps/mackenzie/`
- `keyboards/lily58/keymaps/evertras/`

Build with `nix develop`, then `make lily58:<keymap>`. Flashing is done from Windows, not WSL.

## Rules

- Make the smallest change that does what was asked. Don't refactor, reformat, or touch unrelated keys, layers, or files.
- Preserve the ASCII art layout comment above each layer. Keep its alignment exactly intact, and update only the labels for keys that actually changed so the art always matches the keymap.
