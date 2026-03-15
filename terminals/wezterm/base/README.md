# WezTerm - GPU-Accelerated Terminal Emulator

WezTerm is a powerful GPU-accelerated terminal emulator and multiplexer written in Rust.

## Features

### Core Features
- **GPU Acceleration** - Hardware-accelerated rendering
- **High Performance** - Fast and responsive
- **Cross-Platform** - Works on Linux, macOS, Windows, BSD
- **Multiplexer** - Built-in tab/split pane support
- **Configurable** - Lua configuration
- **Unicode Support** - Excellent emoji and font support
- **True Color** - 24-bit color support
- **Scrollback** - Large scrollback buffer
- **Hyperlinks** - Terminal hyperlink support
- **Domains** - SSH, local, serial, and more

### Advantages Over Other Terminals
- GPU-accelerated (faster)
- Cross-platform (same config everywhere)
- Built-in multiplexer (no tmux needed)
- Lua configuration (powerful)
- Regular updates
- Actively developed

## Installation

### Prerequisites

```bash
# Install WezTerm
# macOS
brew install --cask wezterm

# Fedora
sudo dnf install wezterm

# Ubuntu
# Add WezTerm PPA
sudo add-apt-repository ppa:wezterm/wezterm
sudo apt update
sudo apt install wezterm

# Arch
sudo pacman -S wezterm

# Gentoo
sudo emerge x11-terms/wezterm

# Void
sudo xbps-install wezterm

# Alpine
sudo apk add wezterm

# FreeBSD
sudo pkg install wezterm

# Windows (11)
# Download from GitHub releases
# winget:
winget install wezterm.wezterm
# Or use scoop:
scoop bucket add extras
scoop install wezterm

# Cargo (any OS)
cargo install wezterm
```

### Setup

```bash
# Create config directory
mkdir -p ~/.config/wezterm

# Config location
# ~/.wezterm.lua or ~/.config/wezterm/wezterm.lua
```

## Usage

### Basic Usage

```bash
# Start WezTerm
wezterm

# Start with specific program
wezterm start nvim

# Start with command
wezterm start -- bash -c "echo hello"

# Connect to SSH
wezterm ssh user@host

# Start new tab
wezterm cli split-pane --horizontal
wezterm cli split-pane --vertical
```

### Tabs and Panes

```bash
# New tab
Ctrl+Shift+T

# Close tab
Ctrl+Shift+W

# Next tab
Ctrl+Tab

# Previous tab
Ctrl+Shift+Tab

# Split pane (horizontal)
Ctrl+Shift+Alt+H

# Split pane (vertical)
Ctrl+Shift+Alt+V

# Close pane
Ctrl+Shift+W

# Move between panes
Ctrl+Shift+Arrow Keys

# Resize panes
Ctrl+Shift+Alt+Arrow Keys
```

### Copy Mode

```bash
# Enter copy mode
Ctrl+Shift+X

# Navigation in copy mode:
# - Arrow keys or vim keys
# - Space to start selection
# - Enter to copy

# Paste
Ctrl+Shift+V

# Copy to clipboard
Ctrl+Shift+C
```

### Scrollback

```bash
# Scroll up
Ctrl+Shift+Up

# Scroll down
Ctrl+Shift+Down

# Scroll to top
Ctrl+Shift+Home

# Scroll to bottom
Ctrl+Shift+End

# Clear scrollback
Ctrl+Shift+K
```

### Fonts

```bash
# Increase font size
Ctrl+Shift+=

# Decrease font size
Ctrl+Shift+-

# Reset font size
Ctrl+Shift+0
```

## Configuration

### ~/.wezterm.lua

```lua
local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- Color scheme
config.color_scheme = 'Dracula'

-- Font
config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })
config.font_size = 11.0

-- Window padding
config.window_padding = {
  left = 2,
  right = 2,
  top = 0,
  bottom = 0,
}

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

-- Scrollback
config.scrollback_lines = 10000

return config
```

### Keybindings

```lua
-- Leader key (like tmux)
config.leader = { key = 'b', mods = 'CTRL', timeout_ms = 1000 }

-- Custom keys
config.keys = {
  -- Split horizontal
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- Split vertical
  {
    key = '=',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- Copy mode
  {
    key = 'Enter',
    mods = 'LEADER',
    action = wezterm.action.ActivateCopyMode,
  },
}
```

### Color Schemes

```lua
-- Built-in schemes
config.color_scheme = 'Dracula'
config.color_scheme = 'Catppuccin Mocha'
config.color_scheme = 'Nord'
config.color_scheme = 'Solarized Dark'
config.color_scheme = 'Tokyo Night'

-- Custom colors
config.colors = {
  foreground = '#f8f8f2',
  background = '#282a36',
  cursor_bg = '#f8f8f2',
  cursor_fg = '#282a36',
  selection_bg = '#44475a',
  selection_fg = '#f8f8f2',
}
```

## Practical Examples

### Daily Development

```bash
# Start WezTerm
wezterm

# Create splits for development:
# - Left: Code editor (nvim)
# - Top Right: Running server
# - Bottom Right: Logs/commands

# Use leader key (Ctrl+b) + actions:
# Ctrl+b - : Split horizontal
# Ctrl+b = : Split vertical
# Ctrl+b h/j/k/l : Move between panes
```

### SSH Sessions

```bash
# SSH to remote host
wezterm ssh user@host

# Split pane for local work
Ctrl+Shift+Alt+H

# Run command in remote pane
# Use local pane for reference
```

### Multiple Projects

```bash
# Tab 1: Project 1
# Tab 2: Project 2
# Tab 3: Monitoring

# Switch tabs
Ctrl+Tab / Ctrl+Shift+Tab

# Rename tabs (via config)
```

### Monitoring

```bash
# Split panes for monitoring:
# - Top left: Application logs
# - Bottom left: Database logs
# - Right: System monitor (htop/btop)

# Use scrollback to review history
Ctrl+Shift+Up
```

## Tips

### Productivity

```lua
-- Use leader key for tmux-like workflow
config.leader = { key = 'b', mods = 'CTRL' }

-- Use pane navigation similar to vim
config.keys = {
  { key = 'h', mods = 'LEADER|SHIFT', action = wezterm.action.ActivatePaneDirection('Left') },
  { key = 'j', mods = 'LEADER|SHIFT', action = wezterm.action.ActivatePaneDirection('Down') },
  { key = 'k', mods = 'LEADER|SHIFT', action = wezterm.action.ActivatePaneDirection('Up') },
  { key = 'l', mods = 'LEADER|SHIFT', action = wezterm.action.ActivatePaneDirection('Right') },
}
```

### Appearance

```lua
-- Window opacity
config.window_background_opacity = 0.95

-- Fancy tab bar
config.use_fancy_tab_bar = true

-- Hide scrollbar
config.enable_scroll_bar = false
```

### Performance

```lua
-- Enable GPU acceleration (default)
-- Already enabled by default

-- Adjust scrollback for performance
config.scrollback_lines = 10000

-- Disable unused features
config.enable_scroll_bar = false
```

### Cross-Platform

```lua
-- Same config works on all platforms
-- Use platform detection if needed

local act = wezterm.action
if wezterm.target_triple == 'x86_64-apple-darwin' then
  -- macOS-specific
  config.font_size = 12.0
elseif wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
  -- Linux-specific
  config.font_size = 11.0
end
```

## Aliases

Add to shell config:

```bash
# WezTerm aliases
alias wz='wezterm'               # Start WezTerm
alias wzz='wezterm start'        # Start with command
alias wzs='wezterm ssh'          # SSH via WezTerm

# SSH with WezTerm
alias ssh='wezterm ssh'
```

## Troubleshooting

### "Font not found"

```bash
# Install font
# Update font cache
fc-cache -fv

# Check installed fonts
fc-list | grep -i "JetBrains"

# Use different font in config
config.font = wezterm.font('monospace')
```

### "Config not loading"

```bash
# Check config location
# Linux: ~/.config/wezterm/wezterm.lua
# macOS: ~/.wezterm.lua

# Test config
wezterm --config-file /path/to/config

# Check Lua syntax
lua -e "dofile('/path/to/config')"
```

### "Performance issues"

```bash
# Reduce scrollback
config.scrollback_lines = 5000

-- Disable unused features
config.enable_scroll_bar = false

-- Check GPU acceleration
wezterm cli get-var "gpu_driver"
```

## Comparison

**WezTerm:**
- GPU-accelerated
- Lua config
- Cross-platform
- Built-in multiplexer
- Active development
- Regular updates

**Alacritty:**
- GPU-accelerated
- YAML config
- Cross-platform
- No multiplexer
- Simpler
- Faster

**Kitty:**
- GPU-accelerated
- Python config
- Cross-platform
- Has multiplexer
- More features
- Older

**Terminal.app/iTerm2 (macOS):**
- Native
- macOS only
- Feature-rich
- Proprietary
- Polished

## Resources

- [WezTerm Website](https://wezfurlong.org/wezterm/)
- [WezTerm GitHub](https://github.com/wez/wezterm)
- [WezTerm Documentation](https://wezfurlong.org/wezterm/config/files.html)
- [WezTerm Config Examples](https://github.com/wez/wezterm/wiki/Config-Examples)

---

**Last Updated**: 2025-03-14
