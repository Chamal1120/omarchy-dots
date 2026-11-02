---
name: omarchy-dots
description: >
  REQUIRED whenever a personal config on this machine is created or changed, because
  those changes must live in the user's omarchy-dots repo and be symlinked with GNU
  Stow. Use with the omarchy skill for anything in ~/.config/, ~/.inputrc, or other
  dotfiles: keybindings, Hyprland, tmux, foot, readline, shell, and terminal config.
  Also use for adding a config to the dotfiles, make rice, stow, reinstalling the
  dots on a new machine, or checking the dots after an omarchy update.
---

# omarchy-dots

The user's personal Omarchy config lives in a Git repo and is symlinked into `$HOME`
with GNU Stow. The repo is the source of truth. A config change that is not in the
repo is lost on the next machine.

Find the repo from this skill's own path, which is a symlink into it:

```bash
readlink -f ~/.claude/skills/omarchy-dots/SKILL.md
```

It is normally `~/Projects/omarchy-dots`.

Use the `omarchy` skill as well when the change is to Omarchy, Hyprland, or a terminal.
It covers config syntax and how to validate each change. This skill covers where the
files live.

## Layout

Each top-level folder is a stow package, listed in `PACKAGES` in the `Makefile`. Inside
a package, files sit at their path relative to `$HOME`.

| Package | Links to |
|---|---|
| `hypr` | `~/.config/hypr/bindings.lua`, `~/.config/hypr/looknfeel.lua` |
| `tmux` | `~/.config/tmux/tmux.conf` |
| `foot` | `~/.config/foot/foot.ini` |
| `readline` | `~/.inputrc` |
| `bash` | `~/.bashrc` |
| `nvim` | Every file in `~/.config/nvim/` except `lua/plugins/theme.lua` and `.gitignore` |
| `local-scripts` | `~/.local/scripts/tsesh` |
| `claude` | `~/.claude/skills/omarchy-dots/SKILL.md`, `~/.claude/CLAUDE.md` |

Two files in `~/.config/nvim/` must stay out of the repo. `lua/plugins/theme.lua` is
Omarchy's relative symlink to the active theme, which would break if moved. Stow ignores
`.gitignore` files, so a tracked one would be deleted from `$HOME` and never linked.

`make rice` installs stow if missing, permanently deletes anything in the way of a link
(files, folders, and other symlinks), links every package, reloads Hyprland and tmux,
and installs and applies the Vague theme from GitHub. It keeps no backup, so check for
changes worth saving before running it. It is safe to rerun when everything is already
linked, but each run deletes and reclones `~/.config/omarchy/themes/vague`, so it needs
network access and loses local edits to that theme. It needs sudo only when stow is
missing, so if stow is missing, ask the user to run it in their own terminal.

## Before editing

Check that the config is linked:

```bash
ls -l <config-path>
```

- **It is a symlink into the repo:** edit it at either path. They are the same file.
- **It is a plain file that also exists in the repo:** it has become unlinked. Follow
  "Relinking a file" before editing.
- **It is not in the repo:** follow "Adding a config".

## Adding a config

Use this when the user changes or creates a config the repo doesn't have yet, even if
they didn't mention the dotfiles.

1. Choose the package. Use the existing one for that tool, or a new folder named after
   the tool.
2. Create the file in the repo at its path relative to `$HOME`. For
   `~/.config/hypr/looknfeel.lua`, that is `hypr/.config/hypr/looknfeel.lua`. Start from
   the existing live file so the user's other settings are kept.
3. Add any new package to `PACKAGES` in the `Makefile`.
4. Add the file to the "What's included" table in `README.md`, and any new keys to the
   "Keys" table. Keep the Layout table in this skill current too.
5. Run `make rice` from the repo. It deletes the live file and creates the link, so
   the repo copy must be complete first.
6. Confirm with `ls -l <config-path>` that it is a link, then validate the change.

Rules:

- Don't create symlinks by hand with `ln`. Stow won't own them.
- Don't run `stow --adopt`. It overwrites repo files with whatever is on the machine.
- Don't track secrets, tokens, or machine-specific files. Ask about hardware-specific
  configs such as `monitors.lua` before adding them, because they may break other
  machines.
- Never edit `/usr/share/omarchy/`. Override it from a file in the repo.
- Only commit or push when the user asks. Show them what changed in the repo instead.

## Relinking a file

An unlinked file can hold changes a migration made, so check before replacing it.

1. Run `diff <config-path> <repo-copy>`.
2. Copy anything worth keeping into the repo copy.
3. Run `make rice`. The plain file is deleted and the link returns.

## Validating

| Changed | How |
|---|---|
| `hypr` | `hyprctl reload`, then `hyprctl configerrors` |
| `tmux` | Load it on a throwaway server first: `tmux -L check -f <file> new-session -d`, then `tmux -L check kill-server`. Then `tmux source-file ~/.config/tmux/tmux.conf`. |
| `foot` | `foot --check-config`. Applies to new windows only. |
| `readline` | Applies to new shells only. |

Sourcing a tmux config does not remove binds deleted from it. Run `tmux unbind` for
those in the running server.

## Binding keys

When rebinding, check for conflicts with `omarchy menu keybindings --print`. Hyprland
binds need `hl.unbind` before the new `o.bind`.

The user is a Vim user who wants `hjkl` on their most used binds. When a requested bind
displaces another, move the displaced action to a free key that isn't `hjkl`, and tell
them which key. Don't change other binds.

These binds depend on each other:

- **tmux copy mode:** `Ctrl+Shift+Space` and `Ctrl+Shift+I` are bound in `tmux`, but only
  work because `foot` sends them as CSI-u codes and `readline` ignores those codes at a
  plain prompt. Any new `Ctrl+Shift` key for tmux needs all three changes. Test it in a
  real foot window, because foot sends Tab for `Ctrl+Shift+I` without the text binding.
- **`Super` keys:** tmux never sees them. Hyprland handles them first.
- **Readline in vi mode:** set in `~/.inputrc`, not with `set -o vi`. Otherwise Omarchy's
  and fzf's keys bind to the wrong keymap. Keep `vi-insert` as the last keymap in the
  file for the same reason.

## What might break

- **`omarchy update` and migrations:** these can patch `tmux.conf` and `foot.ini`. A
  `sed -i` replaces the symlink with a plain file, so the file stops being linked.
  Migrations that write through the link show up in `git status` instead.
- **`omarchy refresh`:** `omarchy refresh hyprland`, `omarchy refresh tmux`, and
  `omarchy refresh config <file>` copy stock files through the symlink and overwrite the
  repo's copy. Warn the user first. To undo it, use `git restore`.
- **`omarchy-nvim-refresh`:** this moves all of `~/.config/nvim` to a backup, copies in
  stock files, and deletes Neovim's plugin data, cache, and state. The repo is safe, but
  every Neovim link is lost. `omarchy reinstall` can reach it too. Warn the user first,
  and run `make rice` afterwards. It deletes the plain stock files.
- **Lazy and LazyVim writes:** `lazy-lock.json` and `lazyvim.json` are rewritten through
  their links, so plugin updates show up in `git status`. Commit them when the user asks.
- **New Omarchy defaults:** a new default can land on a key the user took, firing both
  actions. A key the repo unbinds also blocks any new default assigned to it.
- **Full-file copies:** `tmux.conf` and `foot.ini` don't receive later changes to
  Omarchy's stock versions. Compare them with `$OMARCHY_PATH/config/` when something new
  is missing.
- **Fresh installs:** no pacman sync databases exist until the first update, so
  `scripts/install-stow.sh` runs `pacman -Sy`. Recommend `omarchy update` afterwards.

## Checking after an update

```bash
git -C ~/Projects/omarchy-dots status
ls -l ~/.config/hypr/bindings.lua ~/.config/tmux/tmux.conf ~/.config/foot/foot.ini ~/.inputrc ~/.bashrc ~/.config/nvim/init.lua
```

- **Repo changes in `git status`:** a migration wrote through the link. Show the user the
  diff.
- **A file that isn't a link:** follow "Relinking a file".
