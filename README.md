# dotfiles

macOS keyboard-driven workstation — tiling WM, glowing focus borders, searchable cheatsheet, Neovim IDE with Claude Code, Catppuccin Mocha everywhere.

Built for people who want a **Hyprland / Omarchy feel on a Mac** without killing productivity.

![macOS](https://img.shields.io/badge/macOS-15+-000?logo=apple)
![License](https://img.shields.io/badge/license-MIT-blue)

---

## What's inside

| Tool | Role | Config |
|---|---|---|
| **[AeroSpace](https://github.com/nikitabobko/AeroSpace)** | i3-style tiling window manager (no SIP disable) | `.config/aerospace/` |
| **[SketchyBar](https://github.com/FelixKratz/SketchyBar)** | Top bar — workspace indicators, clock, battery, volume | `.config/sketchybar/` |
| **[JankyBorders](https://github.com/FelixKratz/JankyBorders)** | Glowing rounded border on the focused window | `.config/borders/` |
| **[Hammerspoon](https://www.hammerspoon.org/)** | Window hint letters + **searchable keybind cheatsheet overlay** | `.hammerspoon/` |
| **[Neovim](https://neovim.io)** | Editor — Lazy.nvim, Claude Code, Catppuccin | `.config/nvim/` |
| **[WezTerm](https://wezfurlong.org/wezterm/)** | Terminal — Catppuccin Mocha | `.wezterm.lua` |

---

## Highlights

**Searchable keybind overlay.** `cmd+alt+ctrl+/` → floating rounded panel, type anything (`switch monitor`, `fullscreen`, `next workspace`) — fuzzy matches across bindings. Auto-parses `aerospace.toml` so it stays in sync with your live config.

**Window hints.** `cmd+alt+ctrl+E` → letter appears on every visible window. Press the letter → focus that window. Works system-wide, not per-app.

**Auto-assign apps to workspaces.** New windows land on the right workspace by bundle ID (browsers → WS1, terminals → WS2, code → WS3, notes → WS4, comms → WS5, media → WS6, work → WS7). Run `alt+shift+a` to reassign drifted windows.

**Claude Code in Neovim.** Ctrl+, toggles a Claude split pane. Claude's edits surface as diffs inside the editor — accept with `<leader>ca`, deny with `<leader>cd`.

**Glowing focus border.** Catppuccin blue (`#89b4fa`) glow around the focused window. Instant visual scan.

---

## Keybinds

### Window focus / move

| Key | Action |
|---|---|
| `alt + h/j/k/l` | focus window (direction) |
| `alt + shift + h/j/k/l` | move window |
| `alt + shift + minus/equal` | resize −50 / +50 |
| `alt + f` | fullscreen toggle |
| `alt + e` | reset to tile layout |
| `alt + comma` | accordion layout (stack view) |
| `cmd + alt + ctrl + E` | window hint mode (letters) |

### Workspaces

| Key | Action |
|---|---|
| `alt + 1..7` | switch to workspace N |
| `alt + shift + 1..7` | send window to workspace N + follow |
| `alt + ctrl + h / l` | prev / next workspace |
| `alt + tab` | last 2 workspaces (back-and-forth) |
| `alt + m` | focus next monitor |

### App launchers

| Key | App |
|---|---|
| `alt + b` | Brave |
| `alt + c` | Cursor |
| `alt + i` | Ghostty |
| `alt + w` | Obsidian |
| `alt + n` | Notion |
| `alt + a` | ChatGPT |
| `alt + s` | Slack |
| `alt + d` | Discord |
| `alt + o` | OBS |
| `alt + p` | Premiere |
| `cmd + g` | Ghostty |

### System

| Key | Action |
|---|---|
| `alt + /` | searchable cheatsheet |
| `cmd + alt + ctrl + /` | cheatsheet (hyper fallback) |
| `alt + shift + r` | reload SketchyBar |
| `alt + shift + c` | reload AeroSpace config |
| `alt + shift + a` | reassign all windows to rule workspaces |
| `alt + shift + ;` | enter service mode (then `r` flatten, `f` float toggle, `backspace` close-all-but-current, `esc` exit) |

### Neovim

| Key | Action |
|---|---|
| `Ctrl + ,` | toggle Claude Code split |
| `space + c + c` | toggle Claude |
| `space + c + f` | focus Claude pane |
| `space + c + r` | resume Claude session |
| `space + c + C` | continue last Claude conversation |
| `space + c + b` | add current buffer as Claude context |
| `space + c + s` (visual) | send selection to Claude |
| `space + c + a` | accept Claude diff |
| `space + c + d` | deny Claude diff |
| `Ctrl + h/j/k/l` | switch nvim splits (no `Ctrl+w` prefix) |
| `space + e + e` | toggle nvim-tree file explorer |
| `space + f + f` | telescope find files |
| `space + f + g` | telescope live grep |

---

## Install

### Prerequisites

```bash
# Install deps via Homebrew
brew install --cask aerospace hammerspoon alt-tab wezterm
brew install sketchybar borders neovim
```

### Symlink configs

```bash
git clone https://github.com/reddynsk/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` backs up any existing file at the target path to `<file>.bak`, then symlinks the repo versions into `$HOME`.

### Post-install

1. **Grant Accessibility permission** to AeroSpace, Hammerspoon, AltTab
   (System Settings → Privacy & Security → Accessibility)
2. **Start services:**
   ```bash
   brew services start sketchybar
   brew services start borders
   open -a AeroSpace
   open -a Hammerspoon
   open -a AltTab
   ```
3. **Disable macOS Mission Control arrow shortcuts** — System Settings → Keyboard → Keyboard Shortcuts → Mission Control → uncheck `Ctrl+←/→/↑/↓`
4. **Enable auto-hide menu bar** (optional):
   ```bash
   defaults write NSGlobalDomain _HIHideMenuBar -bool true
   killall SystemUIServer Finder
   ```
5. **Delete extra macOS Spaces** so AeroSpace workspaces don't fight macOS Spaces (F3 → hover extra desktops → X).

### Open Neovim → Lazy auto-installs plugins

First launch will take ~30s while Lazy installs: catppuccin, claudecode.nvim, nvim-tree, telescope, treesitter, etc.

---

## Customize

### Add an app to workspace auto-assign

1. Get app bundle ID: `osascript -e 'id of app "AppName"'`
2. Append to `.config/aerospace/aerospace.toml`:
   ```toml
   [[on-window-detected]]
   if.app-id ='com.example.app'
   run = ['move-node-to-workspace 3']
   ```
3. `alt+shift+c` to reload.

### Change borders color

Edit `.config/borders/bordersrc` → `active_color=0xff<rrggbb>`.
Restart: `brew services restart borders`.

### Edit the cheatsheet

AeroSpace bindings auto-appear (parsed from `aerospace.toml` — section comments become categories). Nvim / Hammerspoon / system entries: edit `SHORTCUTS` table in `.hammerspoon/cheatsheet.lua`. Hammerspoon auto-reloads on save.

---

## Theme

Catppuccin Mocha across the stack:

| Role | Hex |
|---|---|
| base | `#1e1e2e` |
| mantle | `#181825` |
| text | `#cdd6f4` |
| blue (focus) | `#89b4fa` |
| mauve | `#cba6f7` |
| surface1 (inactive) | `#45475a` |

---

## Credits

- [@nikitabobko](https://github.com/nikitabobko) — AeroSpace
- [@FelixKratz](https://github.com/FelixKratz) — SketchyBar, JankyBorders
- [@Hammerspoon](https://github.com/Hammerspoon) — Hammerspoon
- [@catppuccin](https://github.com/catppuccin) — theme
- [@coder](https://github.com/coder) — claudecode.nvim
- Structure inspired by [@omerxx/dotfiles](https://github.com/omerxx/dotfiles)

---

MIT license. Steal freely.
