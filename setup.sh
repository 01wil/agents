#!/usr/bin/env bash
# Symlink this repo into the opencode config dir (Linux/macOS/WSL).
# The repo is canonical; ~/.config/opencode just points at it.
#
# Usage:  ./setup.sh
# Re-runnable. Existing non-symlink files are backed up to <name>.bak-<timestamp>.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cfg="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
mkdir -p "$cfg"

link() {
  local src="$repo/$1" dst="$cfg/$1"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    mv "$dst" "$dst.bak-$(date +%Y%m%d%H%M%S)"
    echo "backed up existing $dst"
  fi
  ln -s "$src" "$dst"
  echo "linked $dst -> $src"
}

link AGENTS.md
link wiki
link skills

echo "Done. opencode will now read AGENTS.md, wiki/, and skills/ from $repo."
