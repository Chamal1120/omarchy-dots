#!/bin/bash
# Move aside any file stow would refuse to replace, such as Omarchy's stock
# configs on a fresh install. Files already linked to this repo are left alone.
# Usage: backup-conflicts.sh <target> <package>...
set -euo pipefail

target=$1
shift
repo=$(pwd -P)
backup="$target/.local/state/omarchy-dots/backup-$(date +%Y%m%d-%H%M%S)"

for package in "$@"; do
  while IFS= read -r -d '' path; do
    dest="$target/$path"
    [[ -e $dest || -L $dest ]] || continue
    [[ $(readlink -f "$dest") == "$repo/$package/$path" ]] && continue

    mkdir -p "$(dirname "$backup/$path")"
    mv "$dest" "$backup/$path"
    echo "Backed up $dest to $backup/$path"
  done < <(cd "$package" && find . -type f -printf '%P\0')
done
