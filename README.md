# omarchy-dots

Personal overrides for a fresh [Omarchy](https://omarchy.org/) install, linked
into place with GNU Stow.

## Install

```bash
git clone <this-repo> ~/Projects/omarchy-dots
cd ~/Projects/omarchy-dots
make rice
```

`make rice` installs stow, permanently deletes any file, folder, or symlink in the way
of a link, links the configs, reloads Hyprland and tmux, and installs and applies the
[Vague theme](https://github.com/chrisviegas/omarchy-vague-theme). It keeps no backup. It
is safe to run again once everything is linked, but each run deletes and reclones the
theme, so it needs network access and loses local edits to the theme. It may ask for your
sudo password to install stow.

Open a new terminal afterwards: foot and Bash read these files at startup.

The configs are symlinks, so edits in `~/.config` change this repo. Commit them here.

## What's included

| Package | File | Changes |
|---|---|---|
| `hypr` | `~/.config/hypr/bindings.lua` | Vim window focus and swap, moved defaults, web app launchers removed |
| `hypr` | `~/.config/hypr/looknfeel.lua` | Drag window borders with the mouse to resize |
| `tmux` | `~/.config/tmux/tmux.conf` | `Ctrl+S` leader, vim pane focus, copy mode binds |
| `foot` | `~/.config/foot/foot.ini` | Sends `Ctrl+Shift+Space` and `Ctrl+Shift+I` to tmux |
| `readline` | `~/.inputrc` | Vi mode at the Bash prompt with a mode indicator |
| `bash` | `~/.bashrc` | `vim` alias for `nvim`, `Ctrl+F` opens tsesh |
| `nvim` | `~/.config/nvim/` | Full Neovim config: `Ctrl+F` opens tsesh, Telescope and Oil keys, no indent guides, bottom-line command mode, word highlights, side tree or top file bar, no which-key popups, manual completion |
| `local-scripts` | `~/.local/scripts/tsesh` | Fuzzy-pick a project and open it in a tmux session |
| `claude` | `~/.claude/skills/omarchy-dots/SKILL.md`, `~/.claude/CLAUDE.md` | Teaches Claude Code to keep new configs in this repo, plus hard rules for every session |

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
| `Ctrl+F` | Open tsesh, in Bash and Neovim normal mode |
| `Ctrl+P` | Neovim: find files by name |
| `Ctrl+Space` | Neovim: search file contents |
| `_` | Neovim: open Oil |
| `Alt+I` | Neovim: toggle the completion menu |
| `Ctrl+N` / `Ctrl+P` | Neovim: next or previous completion item |
| `Space g d` | Neovim: go to definition |
| `Space g r` | Neovim: go to references |
| `Space g v` | Neovim: Git diff hunks (moved from `Space g d`) |

## Notes

The copy mode keys need the `foot` package, so they only work in foot.

To add a config, put it under a new package folder at its path relative to `~`,
then add the folder to `PACKAGES` in the `Makefile`.
