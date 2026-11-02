#!/bin/bash
# Delete anything stow would refuse to replace, such as Omarchy's stock configs on
# a fresh install. This is permanent. Links already pointing at this repo are kept.
# Usage: remove-conflicts.sh <target> <package>...
set -euo pipefail

target=${1%/}
shift
repo=$(pwd -P)

remove() {
  rm -rf -- "$1"
  echo "Removed $1"
}

for package in "$@"; do
  while IFS= read -r -d '' path; do
    # A parent that isn't a real folder, like a file or a symlink, blocks the path.
    parent=$target
    IFS=/ read -ra parts <<<"$(dirname "$path")"
    for part in "${parts[@]}"; do
      [[ $part == . ]] && continue
      parent+="/$part"
      if [[ -L $parent || (-e $parent && ! -d $parent) ]]; then
        remove "$parent"
        break
      fi
    done

    dest="$target/$path"
    [[ -e $dest || -L $dest ]] || continue
    [[ $(readlink -f "$dest") == "$repo/$package/$path" ]] && continue

    remove "$dest"
  done < <(cd "$package" && find . -type f -printf '%P\0')
done
