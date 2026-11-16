#!/bin/bash
# Install the Vague theme from a local clone, so reruns don't need a fresh clone.
# The clone lives in ~/.cache and is updated when the network is up. Without a
# network, the cached copy is used as-is.
# Usage: install-theme.sh <git-url> <name> [shell.toml]
set -euo pipefail

url=$1
name=$2
shell_toml=${3:-}
cache="${XDG_CACHE_HOME:-$HOME/.cache}/omarchy-dots/themes/$name"
theme="$HOME/.config/omarchy/themes/$name"

if [[ -d $cache/.git ]]; then
  git -C "$cache" pull --ff-only --quiet || echo "Couldn't update $name, using the cached copy"
else
  mkdir -p "$(dirname "$cache")"
  git clone --quiet -- "$url" "$cache"
fi

rm -rf -- "$theme"
mkdir -p "$(dirname "$theme")"
cp -a -- "$cache" "$theme"
[[ -n $shell_toml ]] && cp -- "$shell_toml" "$theme/shell.toml"

omarchy theme set "$name"
