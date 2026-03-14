# Zellij Configuration

[Zellij](https://zellij.dev) is a modern terminal workspace and multiplexer written in Rust.

## What is Zellij?

Zellij is a terminal workspace that doesn't sacrifice simplicity for power. It features:
- Floating panes with native UI elements
- Multi-layout support with automatic session resurrection
- Plugin system for extensibility
- Modern, intuitive default keybindings

## Configuration Files

- **Base Config**: `base/config.kdl` - Common configuration for all OSes
- **OS Overrides**: `os/<os>/config.kdl` - OS-specific adjustments

Installation location: `~/.config/zellij/config.kdl`

## Quick Start

### Installation

#### macOS
```bash
brew install zellij
```

#### Fedora/Oracle/Rocky Linux
```bash
sudo dnf install zellij
```

#### Arch Linux
```bash
sudo pacman -S zellij
```

#### Ubuntu/Debian/Raspberry Pi
```bash
sudo apt install zellij
```

#### Void Linux
```bash
sudo xbps-install -Sy zellij
```

#### Gentoo
```bash
sudo emerge zellij
```

#### Alpine Linux
```bash
sudo apk add zellij
```

#### FreeBSD
```bash
sudo pkg install zellij
```

#### Windows (WSL)
```bash
# Via cargo
cargo install zellij

# Or download from GitHub releases
# https://github.com/zellij-org/zellij/releases
```

### First Run

Zellij will launch a setup wizard on first run. Choose the **default** preset since this config provides custom keybindings.

### Basic Usage

```bash
# Start Zellij
zellij

# Start with a specific layout
zellij --layout dev

# List sessions
zellij list-sessions

# Attach to existing session
zellij attach <session-name>

# Run command in new session
zellij run -- zellij run -- ls -la
```

## Keybindings

This configuration uses a **non-colliding** preset with the following leader keys:

### Normal Mode
- `Ctrl g` - Enter locked mode
- `Ctrl t` - New tab
- `Ctrl p` - Open file picker
- `Alt h/j/k/l` - Navigate panes
- `Alt n` - New pane
- `Alt q` - Close pane
- `Alt 1-9` - Switch to tab 1-9

### Pane Mode (entered automatically)
- `h/j/k/l` - Move focus
- `n` - New pane
- `q` - Close pane
- `Ctrl p` - Return to normal mode

### Resize Mode
- `h/j/k/l` - Resize in direction
- `=/-` - Increase/decrease size
- `Ctrl r` - Return to normal mode

## OS-Specific Notes

### macOS
- `Cmd` key is used instead of `Ctrl` for major operations
- Adjusts for macOS Terminal.app behavior
- Some keybindings may differ for Terminal.app compatibility

### Windows/WSL
- `Ctrl` keybindings (Windows Terminal handles these well)
- Disables rounded corners (better rendering on some Windows terminals)
- Shell defaults to `bash` (WSL default)

### FreeBSD
- Uses package from `sysutils/zellij` port
- All features supported

## Configuration Structure

```
zellij/
├── base/
│   └── config.kdl           # Base configuration
└── os/
    ├── macos/
    │   └── config.kdl       # macOS overrides
    ├── windows/
    │   └── config.kdl       # Windows/WSL overrides
    └── ...                  # Other OS-specific configs
```

The installer merges the base configuration with OS-specific overrides to create the final `~/.config/zellij/config.kdl`.

## Features Included

### Session Resurrection
Zellij automatically saves your session state and restores it on restart. Your pane layout, running commands, and working directories are preserved.

### Layouts
Custom layouts can be added to `~/.config/zellij/layouts/`. Example layouts:
- `dev.kdl` - Development environment (editor + terminal + tests)
- `monitor.kdl` - System monitoring layout
- `split.kdl` - Split pane layout

### Plugins
Configuration includes:
- **compact-bar** - Minimal status bar
- **file-picker** (strider) - Built-in file navigator
- **session-manager** - Manage multiple sessions

### Themes
Includes Solarized Dark theme. Can be customized in the `themes` section of config.kdl.

## Integration with Other Tools

### Neovim/Helix
Zellij is designed to work well with modal editors:
- Use `Ctrl` and `Alt` as leaders (doesn't conflict with Vim keybindings)
- Smart pane detection for clipboard operations

### Tmux Emulation
If migrating from tmux:
- Similar pane/tab management
- Session resurrection works like tmux-resurrect
- `Ctrl` as leader (like tmux's `Ctrl+b`)

### Yazi File Manager
Can launch yazi in a floating pane:
```bash
zellij run --floating -- yazi
```

## Troubleshooting

### Mouse not working?
Ensure mouse support is enabled in your terminal emulator settings.

### Keybindings not working?
1. Check if another tool is capturing the key
2. Try Zellij's configuration screen: `Ctrl o` then `c`
3. Verify you're not in locked mode (press `Ctrl g` to unlock)

### Session not restoring?
1. Check session serialization is enabled: `session_serialization` in config
2. Verify Zellij has write permissions to `~/.local/share/zellij/`

### Performance issues?
1. Reduce scrollback buffer size
2. Disable plugins you don't use
3. Check for runaway processes in panes

## Resources

- [Official Documentation](https://zellij.dev/documentation)
- [GitHub Repository](https://github.com/zellij-org/zellij)
- [Configuration Guide](https://zellij.dev/documentation/configuration.html)
- [Keybinding Reference](https://zellij.dev/documentation/keybindings.html)

## Contributing

This is a personal configuration, but suggestions for improvements are welcome!

---

**Last Updated**: 2025-03-14
