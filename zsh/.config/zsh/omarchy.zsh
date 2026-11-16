# Omarchy's Bash defaults ($OMARCHY_PATH/default/bash) ported to zsh, plus the
# vi-mode setup from ~/.inputrc. Omarchy ships no zsh config, so this file does
# not follow upstream changes to aliases, init, or the inputrc. Compare it with
# those files after an `omarchy update`. The fns/ files are sourced from upstream
# directly, so they do stay current.

: "${OMARCHY_PATH:=/usr/share/omarchy}"
_omarchy_bash="$OMARCHY_PATH/default/bash"

# --- envs: EDITOR, BROWSER, bat man pages, locale (plain POSIX sh) -----------
source "$_omarchy_bash/envs"

# --- shell: history and completion ------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=32768
SAVEHIST=$HISTSIZE
setopt append_history inc_append_history  # histappend
setopt hist_ignore_space hist_ignore_dups # HISTCONTROL=ignoreboth
setopt interactive_comments
unsetopt hash_cmds hash_dirs              # set +h, so mise switches take effect

mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # completion-ignore-case
zstyle ':completion:*' menu select                         # Tab / Shift+Tab cycle
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # colored-stats
LISTMAX=200                                                # completion-query-items
# Hide the individual omarchy-* binaries; `omarchy <group> <action>` is the entry point.
zstyle ':completion:*:*:-command-:*:commands' ignored-patterns 'omarchy-*'

# --- aliases -----------------------------------------------------------------
if (( $+commands[eza] )); then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

if [[ $TERM == xterm-kitty ]]; then
  alias ff="fzf --preview 'case \$(file --mime-type -b {}) in image/*) kitty icat --clear --transfer-mode=memory --stdin=no --place=\${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES}@0x0 {} ;; *) bat --style=numbers --color=always {} ;; esac'"
else
  alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
fi
# EDITOR holds a command plus flags, and zsh doesn't word-split, hence ${=EDITOR}.
alias eff='${=EDITOR} "$(ff)"'
sff() { if [ $# -eq 0 ]; then echo "Usage: sff <destination> (e.g. sff host:/tmp/)"; return 1; fi; local file; file=$(find . -type f -printf '%T@\t%p\n' | sort -rn | cut -f2- | ff) && [ -n "$file" ] && scp "$file" "$1"; }

if (( $+commands[zoxide] )); then
  alias cd="zd"
  zd() {
    if (( $# == 0 )); then
      builtin cd ~ || return
    elif [[ -d $1 ]]; then
      builtin cd "$1" || return
    else
      if ! z "$@"; then
        echo "Error: Directory not found"
        return 1
      fi

      printf "\U000F17A9 "
      pwd
    fi
  }
fi

open() (
  xdg-open "$@" >/dev/null 2>&1 &
)

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias a='omarchy-agent --inline'
alias c='opencode --auto'
alias cx='printf "\033[2J\033[3J\033[H" && claude --permission-mode auto'
alias cy='codex --approve-for-me'
alias d='docker'
alias r='rails'
alias t='tmux attach || tmux new -s Work'
alias h='herdr'
alias ic='tdl c'
alias ix='tdl cx'
alias icx='tdl c cx'
alias mup='MISE_MINIMUM_RELEASE_AGE=0 mise up'
n() { if [ "$#" -eq 0 ]; then command nvim . ; else command nvim "$@"; fi; }

alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

# --- functions ---------------------------------------------------------------
# Sourced straight from Omarchy under ksh emulation, which gives Bash-like
# 0-based arrays and word splitting. The emulation sticks to each function.
for _omarchy_fn in "$_omarchy_bash"/fns/*(N); do
  emulate ksh -c 'source "$_omarchy_fn"'
done
unset _omarchy_fn

# Bash-only bits in those files, rewritten for zsh.
format-drive() {
  if (( $# != 2 )); then
    echo "Usage: format-drive <device> <name>"
    echo "Example: format-drive /dev/sda 'My Stuff'"
    echo -e "\nAvailable drives:"
    lsblk -d -o NAME -n | awk '{print "/dev/"$1}'
  else
    echo "WARNING: This will completely erase all data on $1 and label it '$2'."
    local confirm partition
    read -r "confirm?Are you sure you want to continue? (y/N): "

    if [[ $confirm =~ ^[Yy]$ ]]; then
      sudo wipefs -a "$1"
      sudo dd if=/dev/zero of="$1" bs=1M count=100 status=progress
      sudo parted -s "$1" mklabel gpt
      sudo parted -s "$1" mkpart primary 1MiB 100%
      sudo parted -s "$1" set 1 msftdata on

      partition="$([[ $1 == *"nvme"* ]] && echo "${1}p1" || echo "${1}1")"
      sudo partprobe "$1" || true
      sudo udevadm settle || true

      sudo mkfs.exfat -n "$2" "$partition"

      echo "Drive $1 formatted as exFAT and labeled '$2'."
    fi
  fi
}

# `argv` is zsh's name for "$@", so upstream's `local argv=("$@")` can't work.
_ssh_interactive() {
  emulate -L ksh
  local value_opts="BbcDEeFIiJLlmOoPpQRSWw"
  local -a ssh_args=("$@")
  local arg letters i dest="" opts_done=""

  while (($#)); do
    arg="$1"
    shift

    if [[ -z $opts_done && $arg == "--" ]]; then
      opts_done=1
    elif [[ -z $opts_done && $arg == -?* ]]; then
      letters="${arg#-}"
      for ((i = 0; i < ${#letters}; i++)); do
        if [[ $value_opts == *"${letters:$i:1}"* ]]; then
          (( i == ${#letters} - 1 )) && shift
          break
        fi
      done
    elif [[ -z $dest ]]; then
      dest="$arg"
    else
      return 1
    fi
  done

  [[ -n $dest ]] || return 1

  local resolved
  resolved=$(command ssh -G "${ssh_args[@]}" 2>/dev/null) || return 1
  ! grep -i '^remotecommand ' <<<"$resolved" | grep -qvi '^remotecommand none$'
}

# --- completion for `omarchy <group> <action> [args]` ------------------------
# Port of $OMARCHY_PATH/default/bash/completions.
_omarchy() {
  local omarchy_bin=${commands[omarchy]:-}
  [[ -n $omarchy_bin ]] || return 1
  local bin_dir=${omarchy_bin:A:h}

  local prefix=omarchy part f rest
  local -aU candidates
  for part in ${words[2,CURRENT-1]}; do
    [[ -z $part || $part == -* ]] && continue
    prefix+="-$part"
  done

  for f in "$bin_dir/$prefix"-*(N-*); do
    rest=${${f:t}#$prefix-}
    [[ -n ${rest%%-*} ]] && candidates+=(${rest%%-*})
  done

  (( CURRENT == 2 )) && candidates+=(commands)
  [[ ${words[2]} == commands ]] && (( CURRENT >= 3 )) && candidates+=(--all --json --markdown --check)

  if (( ! $#candidates )); then
    # Find the longest typed prefix that names a command, then read its
    # "# omarchy:args=" line for the values the next argument can take.
    local n cmd_path="" first_arg
    for (( n = CURRENT - 2; n >= 0; n-- )); do
      prefix=omarchy
      for part in ${words[2,n+1]}; do
        [[ -z $part || $part == -* ]] && continue
        prefix+="-$part"
      done
      if [[ -x $bin_dir/$prefix ]]; then
        cmd_path=$bin_dir/$prefix
        first_arg=$(( n + 2 ))
        break
      fi
    done

    if [[ -n $cmd_path ]]; then
      local args alt token actual value match j
      local -a spec
      args=$(grep -m 1 '^# omarchy:args=' "$cmd_path" 2>/dev/null)
      args=${args#*omarchy:args=}
      local arg_index=$(( CURRENT - first_arg ))

      for alt in "${(@s: | :)args}"; do
        spec=(${=alt})
        match=1
        for (( j = 1; j <= arg_index; j++ )); do
          token=${spec[j]:-}
          actual=${words[first_arg + j - 1]:-}
          if [[ -z $token ]]; then match=0; break; fi
          if [[ $token == \<*\> || $token == \[*\] ]]; then
            value=${${token#[<\[]}%[>\]]}
            [[ $value == *"|"* && " ${value//|/ } " != *" $actual "* ]] && match=0
          elif [[ $token != "$actual" ]]; then
            match=0
          fi
        done
        (( match )) || continue

        token=${spec[arg_index + 1]:-}
        [[ -n $token ]] || continue
        if [[ $token == \<*\> || $token == \[*\] ]]; then
          value=${${token#[<\[]}%[>\]]}
          [[ $value == *"|"* ]] && candidates+=(${(s:|:)value})
        else
          candidates+=($token)
        fi
      done
    fi
  fi

  if (( $#candidates )); then
    compadd -a candidates
  else
    _files
  fi
}
compdef _omarchy omarchy

# --- inputrc: vi mode at the prompt ------------------------------------------
bindkey -v
KEYTIMEOUT=5 # Leave insert mode on Esc after 50ms, like keyseq-timeout 50

# Arrow keys match what you've typed so far against your command history.
for _km in viins vicmd; do
  bindkey -M $_km '^[[A' history-beginning-search-backward
  bindkey -M $_km '^[OA' history-beginning-search-backward
  bindkey -M $_km '^[[B' history-beginning-search-forward
  bindkey -M $_km '^[OB' history-beginning-search-forward
  # Foot sends Ctrl+Shift+Space and Ctrl+Shift+I as CSI-u for tmux's copy mode.
  # Swallow them at a plain prompt instead of reading them as Esc plus keys.
  bindkey -M $_km '^[[32;6u' redisplay
  bindkey -M $_km '^[[105;6u' redisplay
done
unset _km

bindkey -M viins '^L' clear-screen
bindkey -M viins '^[[Z' reverse-menu-complete # Shift+Tab
# Let Backspace and Ctrl+W delete past where insert mode began, as in Bash.
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^W' backward-kill-word

# --- init: mise, starship, zoxide, try, fzf ----------------------------------
(( $+commands[mise] )) && eval "$(mise activate zsh)"

if [[ ${TERM:-} != dumb ]] && (( $+commands[starship] )); then
  eval "$(starship init zsh)"
  # [I] / [N] vi mode indicator at the start of the prompt's last line, where
  # readline draws it in Bash. Starship already redraws on every keymap change.
  _omarchy_starship_prompt=$PROMPT
  _omarchy_vi_prompt() {
    local p=${(e)_omarchy_starship_prompt} mode='%{%F{cyan}%}[I]%{%f%} '
    [[ ${KEYMAP:-} == vicmd ]] && mode='%{%B%F{yellow}%}[N]%{%f%b%} '
    if [[ $p == *$'\n'* ]]; then
      print -rn -- "${p%$'\n'*}"$'\n'"$mode${p##*$'\n'}"
    else
      print -rn -- "$mode$p"
    fi
  }
  PROMPT='$(_omarchy_vi_prompt)'
fi

(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

if (( $+commands[try] )); then
  try() {
    unfunction try
    eval "$(SHELL=/bin/zsh command try init ~/Work/tries)"
    try "$@"
  }
fi

# Only the key bindings (Ctrl-R, Ctrl-T, Alt-C), as Omarchy does for Bash.
[[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh

unset _omarchy_bash
