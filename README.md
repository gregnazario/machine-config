# Greg's Dotfiles & Configuration

Personal dotfiles and configuration for CLI tools across multiple operating systems.

## Supported Operating Systems

This dotfiles repository supports the following operating systems:
- macOS
- Fedora
- RaspberryPi (Raspberry Pi OS)
- Arch Linux
- Gentoo
- Ubuntu
- Void Linux
- Oracle Linux
- Rocky Linux
- Alpine Linux
- Windows 11 (WSL2/PowerShell)
- FreeBSD

## Organization Structure

```
.
├── terminals/          # Terminal multiplexers (zellij, tmux, screen)
├── editors/            # Text editors (neovim, helix, emacs)
├── shells/             # Shell configurations (zsh, fish, nushell)
├── navigation/         # File navigation tools (yazi, fd, ripgrep, fzf)
├── monitoring/         # System monitoring (btop, glances, modern-utils)
├── version-control/    # Git and VCS tools (git, gh, lazygit)
├── network/            # Network tools (gping, httpie, speedtest, bandwhich)
├── productivity/       # Productivity tools (presenterm, todotxt, jira-cli)
├── transfer/           # Download/transfer tools (aria2, curlie, wget2)
├── development/        # Language tools (python, rust, nodejs, templates)
├── containers/         # Container tools (nix, docker, kubernetes)
├── security/           # Security tools (age, ssh, vault, totp)
├── archive/            # Compression tools (compressors, parallel, unar)
├── documentation/      # Documentation tools (tldr, man, cheat, docuum)
├── fun/                # Fun utilities (fetch tools, qalc, etc)
├── templates/          # Generic project templates
└── scripts/            # Installation and utility scripts
    ├── install/        # Installation scripts
    ├── utils/          # Helper utilities
    └── tests/          # Configuration tests
```

## Configuration Strategy: Layered Approach

Each tool directory uses a **layered configuration system**:

```
<tool>/
├── base/              # Base configuration (applies to all OSes)
│   └── config.file
└── os/                # OS-specific overrides
    ├── macos/
    │   └── config.override
    ├── fedora/
    │   └── config.override
    ├── arch/
    │   └── config.override
    └── ... (one for each supported OS)
```

**How it works**:
1. Base configuration is always loaded
2. OS-specific overrides are layered on top
3. Installer detects your OS and applies appropriate layers
4. You can have common defaults + OS-specific paths/commands

## Quick Start

### Interactive Installation

Run the interactive installer:

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/greg-config/main/scripts/install/install.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/yourusername/greg-config.git ~/.local/share/greg-config
cd ~/.local/share/greg-config
./scripts/install/install.sh
```

The installer will:
1. Detect your operating system
2. Ask which tools you want to configure
3. Install tools if needed (optional)
4. Create symlinks in your home directory
5. Apply OS-specific configuration layers

### Manual Installation

For individual tools:

```bash
# Example: Install Zellij configuration
stow -R -d ~/.local/share/greg-config -t ~ zellij

# Or use the provided installer scripts
./scripts/install/install-tool.sh zellij
```

## Tool Categories

### Terminal Multiplexers
- **zellij**: Modern Rust-based terminal workspace
- **tmux**: Classic terminal multiplexer
- **screen**: Universal terminal multiplexer

### Editors
- **neovim**: Modern, extensible editor (Lua-configured)
- **helix**: Modern modal editor with tree-sitter
- **emacs**: Extensible editor with Org-mode

### Shells
- **zsh**: Feature-rich with Oh My Zsh ecosystem
- **fish**: Modern with smart autosuggestions
- **nushell**: Modern structured data approach

### File Navigation
- **yazi**: Modern Rust-based file manager
- **fd**: Fast, user-friendly alternative to find
- **ripgrep**: Fast, recursive search
- **fzf**: Command-line fuzzy finder

### System Monitoring
- **btop**: Modern, colorful resource monitor
- **glances**: Advanced monitoring with alerts
- **modern-utils**: du-dust and other modern replacements

### Version Control
- **git**: Core Git configuration and aliases
- **gh**: GitHub CLI for PRs and issues
- **lazygit**: Interactive Git TUI
- **git-fuzzy**: Fuzzy finder for Git operations

### Network Tools
- **gping**: Modern ping with graphs
- **httpie/xh**: User-friendly HTTP clients
- **speedtest-cli**: Bandwidth speed testing
- **bandwhich**: Network bandwidth monitoring

### And Many More...

See individual tool directories for configuration details.

## Secrets Management

**Important**: This repository contains NO secrets.

- API keys, tokens, passwords go in `~/.config/secrets/` or your preferred vault
- Configuration files reference secrets via environment variables
- Use `age` for encrypting sensitive config (see `security/age/`)

## Contributing

This is a personal dotfiles repository, but suggestions and improvements are welcome!

## License

MIT License - Feel free to reuse and adapt for your own setup.

## Resources

- [Managing Your Dotfiles With GNU Stow](https://www.systutorials.com/managing-your-dotfiles-with-gnu-stow/)
- [The Best Way to Store Your Dotfiles: A Bare Git Repository](https://www.atlassian.com/git/tutorials/dotfiles)
- [An Introduction to GNU Stow](https://linuxhandbook.com/gnu-stow/)

---

**Last Updated**: 2025-03-14
