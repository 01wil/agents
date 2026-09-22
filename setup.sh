#!/usr/bin/env bash
# Install this repo for every agent harness on this machine (Linux/macOS/WSL).
#
# Usage:  ./setup.sh
#
# Skills are linked into ~/.claude/skills: Claude Code reads that as its personal skills dir, and
# opencode reads the same path as its Claude-compatible global location, so one link serves both.
# The instruction file is linked into each harness's config dir under the name it looks for.
#
# Re-runnable. Existing non-symlink files are backed up to <name>.bak-<timestamp>.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$repo" != "$HOME/agents" ]; then
  echo "WARNING: this clone is at $repo, but AGENTS.md resolves wiki/ and skills/ paths"
  echo "         against ~/agents. Either clone to ~/agents, or edit the path rule at the"
  echo "         top of AGENTS.md to match."
  echo
fi

link() {   # link <target> <linkpath>
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    mv "$dst" "$dst.bak-$(date +%Y%m%d%H%M%S)"
    echo "backed up existing $dst"
  fi
  ln -s "$src" "$dst"
  echo "linked $dst -> $src"
}

# Legacy links from the opencode-only layout. wiki/ is now reached by absolute path, and a second
# skills location would register every skill twice. Only ever removes a symlink, never real files.
for legacy in "$HOME/.config/opencode/wiki" "$HOME/.config/opencode/skills"; do
  if [ -L "$legacy" ]; then rm "$legacy"; echo "removed legacy link $legacy"; fi
done

# Universal: the one skills location both Claude Code and opencode read.
link "$repo/skills"    "$HOME/.claude/skills"
link "$repo/AGENTS.md" "$HOME/.claude/CLAUDE.md"

# Per-harness instruction file, only where that harness is already set up.
if [ -d "$HOME/.config/opencode" ]; then link "$repo/AGENTS.md" "$HOME/.config/opencode/AGENTS.md"; fi
if [ -d "$HOME/.codex" ];           then link "$repo/AGENTS.md" "$HOME/.codex/AGENTS.md"; fi
if [ -d "$HOME/.gemini" ];          then link "$repo/AGENTS.md" "$HOME/.gemini/GEMINI.md"; fi

echo
echo "Done. Instructions and skills now come from $repo."
