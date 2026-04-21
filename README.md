# dotfiles

macOS keyboard-driven setup — Omarchy-like tiling + keybinds.

## Stack

- **AeroSpace** — i3-style tiling WM (`.config/aerospace/`)
- **SketchyBar** — top status bar w/ workspace indicators (`.config/sketchybar/`)
- **Hammerspoon** — window hints + searchable cheatsheet overlay (`.hammerspoon/`)
- **Neovim** — editor w/ Claude Code integration, catppuccin theme (`.config/nvim/`)
- **WezTerm** — terminal, catppuccin mocha (`.wezterm.lua`)

## Key workflow

| Key | Action |
|---|---|
| `alt+h/j/k/l` | focus window |
| `alt+shift+h/j/k/l` | move window |
| `alt+1..7` | workspace N |
| `alt+shift+1..7` | send window to ws N |
| `alt+ctrl+h/l` | prev / next workspace |
| `alt+m` | focus next monitor |
| `alt+f` | fullscreen toggle |
| `alt+e` | tile layout |
| `alt+tab` | last 2 workspaces |
| `alt+slash` | searchable cheatsheet |
| `cmd+alt+ctrl+/` | cheatsheet (hyper) |
| `cmd+alt+ctrl+E` | window hints (letter overlay) |
| `alt+shift+a` | reassign all windows to rule workspaces |
| `alt+shift+;` | service mode (r=flatten, f=float toggle) |

App launchers: `alt+b/c/i/s/d/w/n/a/o/p` → Brave/Cursor/Ghostty/Slack/Discord/Obsidian/Notion/ChatGPT/OBS/Premiere.

## Install

```bash
./install.sh
```

Symlinks configs into `$HOME`. Backs up existing files with `.bak` suffix.

## Requirements

```bash
brew install --cask aerospace hammerspoon alt-tab wezterm
brew install sketchybar neovim
```

Grant Accessibility permission to AeroSpace, Hammerspoon, AltTab in System Settings.
