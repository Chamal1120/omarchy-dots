# omarchy-dots

Personal overrides for [Omarchy](https://omarchy.org/) linux.

## Install

```bash
git clone https://github.com/Chamal1120/omarchy-dots
cd omarchy-dots
make rice
```

- `make rice` installs stow, permanently deletes any file, folder, or symlink in the way and links the configs and reloads the UI shell.
- It keeps no backup. 
- It is safe to run again once everything is linked theme and loses local edits to the theme. 
- It may ask for your sudo password to install stow.
- Open a new terminal once finished installing as foot and Bash read these files at startup.
- The configs are symlinks, so edits in `~/.config` change the files in repo.

## What's included

| Package | File | Changes |
|---|---|---|
| `hypr` | `~/.config/hypr/bindings.lua` | Vim window focus and swap, moved defaults, web app launchers removed |
| `hypr` | `~/.config/hypr/looknfeel.lua` | Drag window borders with the mouse to resize |
| `hypr` | `~/.config/hypr/input.lua` | Natural (inverted) touchpad scrolling |
| `tmux` | `~/.config/tmux/tmux.conf` | `Ctrl+S` leader, vim pane focus, copy mode binds |
| `foot` | `~/.config/foot/foot.ini` | Sends `Ctrl+Shift+Space` and `Ctrl+Shift+I` to tmux |
| `readline` | `~/.inputrc` | Vi mode at the Bash prompt with a mode indicator |
| `bash` | `~/.bashrc` | `vim` alias for `nvim`, `Ctrl+F` opens tsesh |
| `nvim` | `~/.config/nvim/` | Full Neovim config: `Ctrl+F` opens tsesh, Telescope and Oil keys, no indent guides, bottom-line command mode, word highlights, side tree or top file bar, no which-key popups, manual completion, no inline diagnostic text, highlighted current diagnostic in the Trouble list, see-through Trouble window |
| `local-scripts` | `~/.local/scripts/tsesh` | Fuzzy-pick a project and open it in a tmux session |
| `local-scripts` | `~/.local/scripts/nightlight-sun` | Writes `~/.config/hypr/hyprsunset.conf` so night light turns on at sunset and off at sunrise |
| `systemd` | `~/.config/systemd/user/nightlight-sun.{service,timer}` | Runs `nightlight-sun` at login and daily at 00:05 |
| `claude` | `~/.claude/skills/omarchy-dots/SKILL.md`, `~/.claude/CLAUDE.md` | Teaches Claude Code to keep new configs in this repo, plus hard rules for every session |
| `omarchy` | `~/.config/omarchy/hooks/theme-set.d/20-tmux-see-through` | After each theme switch, clears the solid background Omarchy gives tmux windows and panes so foot's see-through background shows |
| `omarchy` | `~/.config/omarchy/shell.json` | Bar layout and widgets (NetCaptain, world clocks in Celsius, short date), idle timers, and the omacast launcher plugin. See [Notes](#notes) |
| `cliamp` | `~/.config/cliamp/config.toml` | Starts the cliamp music player in the free Radio provider |
| `themes` (copied, not stowed) | `~/.config/omarchy/themes/vague/shell.toml` | Popup, menu, and notification opacity. Solid (`1.0`) for now; see [Glass effect](#glass-effect) |

## Keybinds (Only the changed ones)

| Keys | Action |
|---|---|
| `Super + H/J/K/L` | Focus window |
| `Super + Shift + H/J/K/L` | Swap window |
| `Alt + Shift + H/L` | Shrink / grow window width |
| `Alt + Shift + K/J` | Shrink / grow window height |
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

## Glass effect

Glass (see-through windows and shell surfaces with blur behind them) is off by default. These configs are ready
for it: the tmux hook and the `nvim.trouble` change keep tmux and Neovim from painting over a see-through
terminal, so only the steps below are needed.

To turn it on:

1. Windows and terminals: `omarchy hyprland window transparency glassy`. This turns on Hyprland's blur
   and gives terminals a see-through background (Omarchy's default is `0.65`).
2. Popups, menus, and notifications: in `themes/vague/shell.toml`, set `background-alpha` under
   `[popups]`, `[notifications]`, and `[menu]` to `0.85` (lower is more see-through), then run
   `make rice`, or copy the file to `~/.config/omarchy/themes/vague/` and run `omarchy theme set vague`.
3. Bar: double-click it, or run `omarchy bar background glassy`.
4. Optional, terminal opacity other than `0.65`: add this to `foot/.config/foot/foot.ini` after the
   `[main]` section. It applies in every Window Opacity mode, so remove it when turning glass off.

   ```ini
   [colors-dark]
   alpha=0.9
   ```

Open a new foot window afterwards, since foot reads its opacity only at launch.

To turn it off, run `omarchy hyprland window transparency transparent` (or `opaque`), set those
`background-alpha` values back to `1.0` and apply them the same way, run `omarchy bar background
opaque`, and remove any foot `alpha` override.
