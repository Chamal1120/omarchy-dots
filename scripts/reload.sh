#!/bin/bash
# Apply the new configs to anything already running.

if [[ -n ${HYPRLAND_INSTANCE_SIGNATURE:-} ]]; then
  hyprctl reload
  hyprctl configerrors
fi

if tmux list-sessions &>/dev/null; then
  tmux source-file "$HOME/.config/tmux/tmux.conf"
fi
