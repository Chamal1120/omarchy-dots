# omarchy-dots

Personal overrides for a fresh [Omarchy](https://omarchy.org/) install, linked
into place with GNU Stow.

## Install

```bash
git clone <this-repo> ~/Projects/omarchy-dots
cd ~/Projects/omarchy-dots
make rice
```

`make rice` installs stow, moves any file it would replace into
`~/.local/state/omarchy-dots/backup-<timestamp>/`, links the configs, and reloads
Hyprland and tmux. It is safe to run again. It may ask for your sudo password to
install stow.

Open a new terminal afterwards: foot and Bash read these files at startup.

The configs are symlinks, so edits in `~/.config` change this repo. Commit them here.

## What's included

| Package | File | Changes |
|---|---|---|
| `hypr` | `~/.config/hypr/bindings.lua` | Vim window focus and swap, moved defaults, web app launchers removed |
| `tmux` | `~/.config/tmux/tmux.conf` | `Ctrl+S` leader, vim pane focus, copy mode binds |
| `foot` | `~/.config/foot/foot.ini` | Sends `Ctrl+Shift+Space` and `Ctrl+Shift+I` to tmux |
| `readline` | `~/.inputrc` | Vi mode at the Bash prompt with a mode indicator |

## Keys

| Keys | Action |
|---|---|
| `Super + H/J/K/L` | Focus window |
| `Super + Shift + H/J/K/L` | Swap window |
| `Super + B` | Keybindings menu |
| `Super + E` | Toggle window split |
| `Super + M` | Toggle workspace layout |
| `Ctrl+S` | tmux leader (`Ctrl+B` also works) |
| `Leader h/j/k/l` | Focus tmux pane |
| `Leader -` | Split tmux pane vertically |
| `Leader X` | Kill tmux window, with confirmation |
| `Leader a` | Last tmux window |
| `Ctrl+Shift+Space` | Enter tmux copy mode |
| `Ctrl+Shift+I` | Exit tmux copy mode |

## Notes

The copy mode keys need the `foot` package, so they only work in foot.

To add a config, put it under a new package folder at its path relative to `~`,
then add the folder to `PACKAGES` in the `Makefile`.
