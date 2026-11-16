# Interactive zsh. Environment lives in ~/.zshenv.

# All the default Omarchy aliases and functions, ported from its Bash config
# (don't mess with that file for personal changes, just overwrite them here!)
source "$HOME/.config/zsh/omarchy.zsh"

# Foot starts zsh, but SHELL still names the login shell (bash). Point it at zsh
# so tmux panes and other programs that read SHELL open zsh too.
export SHELL="${commands[zsh]:-/usr/bin/zsh}"

# Add your own exports, aliases, and functions here.
alias vim='nvim'

tsesh() { "$HOME/.local/scripts/tsesh" "$@"; }

# Ctrl+F opens tsesh, in both vi insert and normal mode. It runs tsesh as a
# normal command line, not inside the widget: tmux attached from inside a zle
# widget freezes foot. Anything already typed is kept and comes back after.
# The leading space keeps it out of history (hist_ignore_space).
_tsesh_widget() {
  zle push-input
  BUFFER=' tsesh'
  zle accept-line
}
zle -N _tsesh_widget
bindkey -M viins '^F' _tsesh_widget
bindkey -M vicmd '^F' _tsesh_widget

# Syntax highlighting. Keep it last so it wraps every widget defined above.
[[ -r /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]] &&
  source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
