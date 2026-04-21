#!/usr/bin/env bash
# Symlink dotfiles into $HOME. Backs up existing files.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HOME"

link() {
  local src="$1" dest="$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "backup: $dest → $dest.bak"
    mv "$dest" "$dest.bak"
  elif [ -L "$dest" ]; then
    rm "$dest"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "linked: $dest → $src"
}

link "$DOTFILES/.config/aerospace"  "$HOME/.config/aerospace"
link "$DOTFILES/.config/sketchybar" "$HOME/.config/sketchybar"
link "$DOTFILES/.config/nvim"       "$HOME/.config/nvim"
link "$DOTFILES/.hammerspoon"       "$HOME/.hammerspoon"
link "$DOTFILES/.wezterm.lua"       "$HOME/.wezterm.lua"

echo "done. restart AeroSpace / Hammerspoon / SketchyBar."
