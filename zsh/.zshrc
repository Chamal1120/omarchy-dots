# Interactive zsh. Environment lives in ~/.zshenv.

# All the default Omarchy aliases and functions, ported from its Bash config
# (don't mess with that file for personal changes, just overwrite them here!)
source "$HOME/.config/zsh/omarchy.zsh"

# Foot starts zsh, but SHELL still names the login shell (bash). Point it at zsh
# so tmux panes and other programs that read SHELL open zsh too.
export SHELL="${commands[zsh]:-/usr/bin/zsh}"

# Add your own exports, aliases, and functions here.
alias vim='nvim'

# Ctrl+F opens tsesh, in both vi insert and normal mode.
_tsesh_widget() {
  zle -I
  "$HOME/.local/scripts/tsesh" </dev/tty
  zle reset-prompt
}
zle -N _tsesh_widget
bindkey -M viins '^F' _tsesh_widget
bindkey -M vicmd '^F' _tsesh_widget

# Syntax highlighting. Keep it last so it wraps every widget defined above.
[[ -r /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]] &&
  source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
