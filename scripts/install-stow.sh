#!/bin/bash
# Install GNU Stow. A fresh Omarchy install has no pacman sync databases until
# its first update, so fetch them first or pacman can't find the package.
set -euo pipefail

command -v stow &>/dev/null && exit 0

if [[ ! -f /var/lib/pacman/sync/extra.db ]]; then
  sudo pacman -Sy
fi

omarchy pkg add stow
