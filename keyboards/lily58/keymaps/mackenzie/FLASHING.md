# Building and flashing the mackenzie keymap

Build in WSL, flash from Windows.

## Prerequisites

One-time setup:

- **WSL (Ubuntu)** with this repo cloned at `~/dev/github/evertras/qmk_firmware`.
- **Nix** with flakes enabled. Check with `nix --version`. `~/.config/nix/nix.conf` (or `/etc/nix/nix.conf`) should contain:
  ```
  experimental-features = nix-command flakes
  ```
- **QMK Toolbox** on Windows, from https://github.com/qmk/qmk_toolbox/releases. Install it and let it install its drivers when it asks.
- **Git submodules.** Run this once from the repo root, inside the dev shell (see step 1):
  ```
  make git-submodule
  ```
  The build fails with `lib/lufa/LUFA/makefile: No such file or directory` if this step was skipped.

## 1. Build and copy to Windows (WSL)

```
cd ~/dev/github/evertras/qmk_firmware
nix develop
build-mackenzie
```

The first `nix develop` downloads the toolchain and takes a while. Later runs are quick.

A successful run ends with:

```
 * The firmware size is fine - .../28672 (..%, ... bytes free)
Copied lily58_rev1_mackenzie.hex to keyboards/lily58/keymaps/mackenzie/output/
```

The firmware is then on Windows in OneDrive, at `keyboards\lily58\lily58_rev1_mackenzie.hex`.

### What `build-mackenzie` does

`build-mackenzie` is a small script defined in the repo's `flake.nix`, and is only available inside `nix develop`. It:

1. Moves to the repo root, so it works from any folder in the repo.
2. Runs `make lily58:mackenzie`, which writes `lily58_rev1_mackenzie.hex` to the repo root.
3. Copies that `.hex` into `output/` in this folder. `output` is a symlink to `keyboards\lily58` in OneDrive, so the file lands in OneDrive.

It stops at the first error, so a failed build never copies an old `.hex`.

To do the same by hand, from the repo root:

```
make lily58:mackenzie
cp lily58_rev1_mackenzie.hex keyboards/lily58/keymaps/mackenzie/output/
```

### Troubleshooting the build

- **`build-mackenzie: command not found`:** you're not in the dev shell. Run `nix develop` from the repo root first. If you're in it and it's still missing, exit and re-run `nix develop` so it picks up the latest `flake.nix`.
- **`Cannot run "qmk hello"` / `Please run qmk setup`:** same cause. You're running `make` outside the dev shell.
- **`lib/lufa/LUFA/makefile: No such file or directory`:** the git submodules aren't checked out. Run `make git-submodule` (see Prerequisites).
- **`cp: ... output/: No such file or directory` (or `Not a directory`):** the `output` symlink is missing, for example on a fresh clone, or the Windows folder was moved. Make sure `keyboards\lily58` exists in OneDrive, then recreate the symlink from this folder:
  ```
  ln -s /mnt/c/Users/<windows-user>/OneDrive/keyboards/lily58 output
  ```
- **The file doesn't show up on Windows:** check that `ls output/` in WSL lists it. If it does, OneDrive may still be syncing; the file is on disk at the path above either way.
- **Compile errors after editing `keymap.c`:** the error output points at the line. Every layer must have exactly the same number of keys as the `LAYOUT(...)` macro expects, so a missing or extra key is the usual cause.

## 2. Set up QMK Toolbox (Windows)

1. Open QMK Toolbox.
2. **Local file:** select `lily58_rev1_mackenzie.hex` from `keyboards\lily58` in OneDrive.
3. **MCU:** `atmega32u4`.
4. Tick **Auto-Flash**. The bootloader only stays open for about 8 seconds, so it's easier if the Toolbox flashes as soon as it sees the board.

## 3. Flash the left half

1. Unplug the TRRS cable that joins the two halves. Never plug or unplug it while either half has power.
2. Plug the USB cable into the **left** half.
3. Press the reset button on the left half. If QMK Toolbox doesn't show `Caterina device connected`, press it twice quickly.
4. With Auto-Flash on, the Toolbox flashes the board right away. Wait for `Flash complete`, then for the board to reconnect.

## 4. Flash the right half

1. Unplug the USB cable from the left half.
2. Plug it into the **right** half.
3. Repeat steps 3.3 and 3.4.

Flash both halves every time, so they always run the same firmware.

## 5. Reconnect

1. Unplug USB.
2. Plug the TRRS cable back in.
3. Plug USB into the **left** half. This keymap sets `MASTER_LEFT`, so the left half must be the one connected to the computer.

Untick Auto-Flash in QMK Toolbox when you're done, so it doesn't flash anything you didn't mean to.

## Troubleshooting flashing

- **Toolbox never sees the board:** try a different USB cable (some only carry power) or a different port, and press reset twice quickly.
- **Keys act wrong after flashing:** make sure USB is in the left half, and that both halves were flashed with the same `.hex`.
