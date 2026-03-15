# Ghostty - Modern Terminal Emulator

Ghostty is a modern, fast, and feature-rich terminal emulator written in Zig.

## Features

### Core Features
- **GPU Acceleration** - Hardware-accelerated rendering
- **Fast** - Written in Zig, very performant
- **Cross-Platform** - macOS and Linux
- **Modern** - Latest terminal features
- **Simple Config** - Easy-to-read config format
- **True Color** - 24-bit color support
- **Unicode** - Excellent emoji and font support
- **Tabs** - Built-in tab support
- **Splits** - Split panes support
- **Sessions** - Session management

### Advantages
- Modern and actively developed
- Fast startup time
- Low memory usage
- GPU-accelerated
- Clean configuration
- Good macOS integration
- Excellent font rendering

## Installation

### Prerequisites

```bash
# Install Ghostty
# macOS
brew install --cask ghostty

# Fedora
# Download from GitHub releases or use COPR
# https://github.com/mitchellh/ghostty

# Ubuntu
# Download .deb from GitHub releases
# https://github.com/mitchellh/ghostty/releases

# Arch
sudo pacman -S ghostty

# Gentoo
# Ebuild available or manual install
# https://github.com/mitchellh/ghostty

# Void
sudo xbps-install ghostty

# Windows
# Not supported (WSL2 only)
```

### Setup

```bash
# Create config directory
mkdir -p ~/.config/ghostty

# Config location
# macOS: ~/.config/ghostty/config
# Linux: ~/.config/ghostty/config
```

## Usage

### Basic Usage

```bash
# Start Ghostty
ghostty

# Open new tab
Ctrl+Shift+T

# Close tab
Ctrl+Shift+Q

# Next tab
Ctrl+Tab

# Previous tab
Ctrl+Shift+Tab

# Split horizontal
Ctrl+Shift+H

# Split vertical
Ctrl+Shift+V

# Close split
Ctrl+Shift+W
```

### Font Size

```bash
# Increase font size
Ctrl+Shift+=

# Decrease font size
Ctrl+Shift+-

# Reset font size
Ctrl+Shift+0
```

### Copy/Paste

```bash
# Copy selection
# Select text, then Ctrl+Shift+C

# Paste
Ctrl+Shift+V

# Copy entire buffer
Ctrl+Shift+S
```

### Scrollback

```bash
# Scroll up
Shift+PageUp

# Scroll down
Shift+PageDown

# Scroll to top
Shift+Home

# Scroll to bottom
Shift+End
```

### Fullscreen

```bash
# Toggle fullscreen
F11

# Or on macOS:
Cmd+Enter
```

## Configuration

### ~/.config/ghostty/config

```
# Font
font-family = JetBrains Mono
font-size = 11

# Colors (Dracula)
background = 282a36
foreground = f8f8f2
cursor-background = f8f8f2
cursor-foreground = 282a36

# Palette
palette = 0=#21222c
palette = 1=#ff5555
palette = 2=#50fa7b
palette = 3=#f1fa8c
palette = 4=#bd93f9
palette = 5=#ff79c6
palette = 6=#8be9fd
palette = 7=#f8f8f2

# Scrolling
scrollback-limit = 10000

# Window
window-opacity = 0.95
padding = 2

# Confirm close
confirm-close-surface = false
```

### Color Schemes

```
# Dracula (default in base config)
# Tokyo Night
background = 1a1b26
foreground = c0caf5
palette = 0=#1a1b26
palette = 1=#f7768e
palette = 2=#9ece6a
palette = 3=#e0af68
palette = 4=#7aa2f7
palette = 5=#bb9af7
palette = 6=#7dcfff
palette = 7=#c0caf5

# Nord
background = 2e3440
foreground = d8dee9
palette = 0=#3b4252
palette = 1=#bf616a
palette = 2=#a3be8c
palette = 3=#ebcb8b
palette = 4=#5e81ac
palette = 5=#b48ead
palette = 6=#88c0d0
palette = 7=#e5e9f0

# Catppuccin Mocha
background = 1e1e2e
foreground = cdd6f4
palette = 0=#45475a
palette = 1=#f38ba8
palette = 2=#a6e3a1
palette = 3=#f9e2af
palette = 4=#89b4fa
palette = 5=#f5c2e7
palette = 6=#94e2d5
palette = 7=#bac2de
```

### Keybindings

```
# Splits
keybind = ctrl+shift+h=split:left
keybind = ctrl+shift+v=split:bottom
keybind = ctrl+shift+w=close_surface

# Tabs
keybind = ctrl+shift+t=new_tab
keybind = ctrl+shift+q=close_tab

# Font size
keybind = ctrl+shift+equal=increase_font_size:1
keybind = ctrl+shift+minus=decrease_font_size:1
keybind = ctrl+shift+0=reset_font_size

# Clipboard
keybind = ctrl+shift+c=copy_to_clipboard
keybind = ctrl+shift+v=paste_from_clipboard
```

### Font Configuration

```
# Font family
font-family = JetBrains Mono

# Fallback fonts
font-family = Fira Code
font-family = monospace

# Font size
font-size = 11

# Font ligatures
font-feature = +calt -zero

# Font features
font-feature = +ss01
font-feature = +ss02
```

## Practical Examples

### Daily Development

```
# Use splits for development:
# Ctrl+Shift+H - Split horizontally
# Ctrl+Shift+V - Split vertically
# Ctrl+Shift+W - Close split

# Use tabs for projects:
# Ctrl+Shift+T - New tab per project
```

### Custom Theme

```
# Custom Dracula variant
background = 1e1f29
foreground = f8f8f2
cursor-background = bd93f9
selection-background = 44475a
selection-foreground = f8f8f2

# Custom palette
palette = 0=#21222c
palette = 1=#ff5555
palette = 2=#50fa7b
palette = 3=#f1fa8c
palette = 4=#bd93f9
palette = 5=#ff79c6
palette = 6=#8be9fd
palette = 7=#f8f8f2
```

### macOS Integration

```
# Option key as Alt
macos-option-as-alt = true

# Non-native fullscreen
macos-non-native-fullscreen = false

# Theme (dark/light/auto)
theme = dark
```

## Tips

### Performance

```
# Adjust scrollback for performance
scrollback-limit = 5000

# Disable unused features
confirm-close-surface = false
```

### Productivity

```
# Enable copy on select
copy-on-select = true

# Visual bell instead of audio
visual-bell = true
audible-bell = false
```

### Appearance

```
# Window transparency
window-opacity = 0.95

# Padding for visual comfort
padding = 4

# Hide decorations
window-decoration = false
```

### Cross-Platform

```
# Platform-specific settings
# Ghostty uses same config on macOS and Linux

# macOS-specific
macos-option-as-alt = true
macos-non-native-fullscreen = true
```

## Aliases

Add to shell config:

```bash
# Ghostty aliases
alias gh='ghostty'               # Start Ghostty
alias ghs='ghostty --'           # Start with command
```

## Troubleshooting

### "Font not found"

```bash
# Install font
# Update font cache
fc-cache -fv

# Use system default
# Comment out font-family in config
```

### "Config not loading"

```bash
# Check config location
ls -la ~/.config/ghostty/config

# Test config syntax
# Lines should be key = value

# Restart Ghostty
```

### "Performance issues"

```bash
# Reduce scrollback
scrollback-limit = 5000

# Disable transparency
window-opacity = 1.0

# Disable visual bell
visual-bell = false
```

## Comparison

**Ghostty:**
- Written in Zig
- GPU-accelerated
- Modern features
- Simple config
- Fast startup
- Active development
- macOS + Linux

**WezTerm:**
- Written in Rust
- GPU-accelerated
- Lua config
- More features
- More mature
- Cross-platform

**Alacritty:**
- Written in Rust
- GPU-accelerated
- YAML config
- Minimal features
- Very fast
- Cross-platform

**Kitty:**
- Written in Python/C
- GPU-accelerated
- Python config
- Many features
- Older
- Cross-platform

**iTerm2 (macOS only):**
- Native macOS
- Feature-rich
- Proprietary
- Very polished
- macOS only

## Resources

- [Ghostty Website](https://ghostty.org/)
- [Ghostty GitHub](https://github.com/mitchellh/ghostty)
- [Ghostty Documentation](https://ghostty.org/config)
- [Ghostty Config](https://ghostty.org/config#list-of-config)

---

**Last Updated**: 2025-03-14
