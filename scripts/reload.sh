#!/bin/bash
# Apply the new configs to anything already running.

if [[ -n ${HYPRLAND_INSTANCE_SIGNATURE:-} ]]; then
  hyprctl reload
  hyprctl configerrors
fi

if tmux list-sessions &>/dev/null; then
  tmux source-file "$HOME/.config/tmux/tmux.conf"
fi

if systemctl --user is-active --quiet graphical-session.target; then
  systemctl --user daemon-reload
  systemctl --user enable --now nightlight-sun.service nightlight-sun.timer
fi

# The shell keeps its config in memory. Reread shell.json so it never runs on,
# and later saves, defaults it fell back to while a link was missing.
if omarchy-shell shell reloadConfig &>/dev/null; then
  echo "Reloaded the shell config"
fi
