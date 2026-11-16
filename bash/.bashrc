# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# Flutter (stable SDK in ~/development/flutter) and the Android SDK from Android Studio
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$HOME/development/flutter/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
alias vim='nvim'

# Ctrl+F opens tsesh. Bound in both keymaps so it works in vi insert and normal mode.
bind -m vi-insert -x '"\C-f": "$HOME/.local/scripts/tsesh"'
bind -m vi-command -x '"\C-f": "$HOME/.local/scripts/tsesh"'
