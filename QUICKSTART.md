# Greg's Dotfiles - Quick Start Guide

Welcome to your personal dotfiles repository! This document will help you get started with your new configuration system.

## What's Included

### Shells ✅
- **ZSH** - Pure ZSH with Starship prompt, safe aliases, modern replacements
- **Fish** - Pure Fish with Starship, abbreviations, smart completions
- **Nushell** - Modern shell with structured data, custom commands, prompt theme

### Editors
- **Neovim** - Lazy.nvim-based, LSP, Telescope, Git integration (TODO)
- **Emacs** - Doom Emacs configuration (TODO)
- **Helix** - Modern modal editor, LSP, themes (TODO)

### Terminal Multiplexers ✅
- **Zellij** - Modern Rust-based workspace, layered configs
- **Tmux** - TPM plugins, Powerline, Vim mode, Ctrl+a leader
- **Screen** - Basic configuration (TODO)

### Navigation ✅
- **Yazi** - Modern file manager (TODO)
- **fd** - Fast find alternative, smart ignores
- **ripgrep** - Fast grep, case-insensitive, hidden files
- **fzf** - Fuzzy finder, shell integration, preview

### Monitoring ✅
- **btop** - Dracula theme, modern system monitor
- **glances** - Advanced monitoring (TODO)
- **modern-utils** - du-dust, etc (TODO)

### Version Control ✅
- **Git** - Semantic aliases, signed commits, smart config
- **Lazygit** - Dracula theme, keybindings, OS-specific settings
- **gh** - GitHub CLI (TODO)

### Development ✅
- **Python** - pyproject.toml, Black, Ruff, MyPy, Pytest
- **Rust** - Cargo config, rust-analyzer, rustfmt, Clippy
- **Node.js** - Bun as primary, ASDF version management
- **ASDF** - Multi-language version manager, tool-versions

### Containers ✅
- **Docker** - CLI aliases, Compose helpers, cleanup scripts
- **Podman** - Docker alternative (TODO)
- **Kubernetes** - k9s, Krew plugins (TODO)

### Security ✅
- **SSH** - Connection keepalive, host aliases, jump hosts
- **age** - Modern encryption (TODO)
- **Vault** - Secrets management (TODO)

## Installation

### Quick Install

```bash
# Clone the repository
git clone https://github.com/yourusername/greg-config.git ~/.local/share/greg-config

# Run the interactive installer
cd ~/.local/share/greg-config
./scripts/install/install.sh
```

### Manual Installation

1. **Symlink configurations** to your home directory:
   ```bash
   # Example: Symlink ZSH config
   ln -s ~/.local/share/greg-config/shells/zsh/base/.zshrc ~/.config/zsh/.zshrc

   # Symlink Starship config
   ln -s ~/.local/share/greg-config/shells/zsh/base/starship.toml ~/.config/starship.toml
   ```

2. **Install tools** using your package manager:
   ```bash
   # macOS
   brew install starship zellij tmux btop bat exa fd ripgrep fzf gh lazygit

   # Fedora/Ubuntu/Arch
   # Use your package manager
   ```

3. **Restart your shell** to apply changes:
   ```bash
   exec zsh  # or exec fish
   ```

## First-Time Setup

### 1. Install Starship Prompt

```bash
# Install Starship
cargo install starship

# Or via package manager
# macOS: brew install starship
# Ubuntu: cargo install starship
```

### 2. Install TPM (Tmux Plugin Manager)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then in tmux, press `prefix + I` (Ctrl-a + I) to install plugins.

### 3. Configure Git Identity

Edit `~/.gitconfig` and add your name and email:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

### 4. Set Up SSH Keys

```bash
# Generate ed25519 key (recommended)
ssh-keygen -t ed25519 -C "you@example.com"

# Copy to GitHub/GitLab
cat ~/.ssh/id_ed25519.pub
# Paste into SSH keys settings on GitHub/GitLab
```

### 5. Install ASDF Plugins

```bash
# Add and install plugins
asdf plugin add python
asdf plugin add nodejs
asdf plugin add rust

# Install versions
asdf install
```

## Tool-Specific Setup

### Zellij Terminal Multiplexer

```bash
# Install Zellij
# macOS: brew install zellij
# Others: See terminals/zellij/README.md

# Start Zellij
zellij
```

### Tmux

```bash
# Install tmux
# macOS: brew install tmux
# Others: See terminals/tmux/README.md

# Start tmux
tmux

# Install plugins: Press Ctrl-a + I
```

### Docker

```bash
# Install Docker
# See: https://docs.docker.com/get-docker/

# Verify installation
docker --version
docker compose version

# Use aliases
dlsa    # List all containers
dstop   # Stop all containers
dclean  # Deep clean
```

### btop

```bash
# Install btop
# macOS: brew install btop
# Fedora: sudo dnf install btop
# Ubuntu: sudo apt install btop

# Run btop
btop
```

## Configuration Locations

All configurations are stored in `~/.local/share/greg-config/`:

```
~/.local/share/greg-config/
├── shells/          # ZSH, Fish, Nushell configs
├── terminals/       # Zellij, Tmux, Screen
├── editors/         # Neovim, Helix, Emacs
├── navigation/      # Yazi, fd, ripgrep, fzf
├── monitoring/      # btop, glances, modern-utils
├── version-control/ # Git, Lazygit, gh
├── development/     # Python, Rust, Node.js
├── containers/      # Docker, Kubernetes
└── security/        # SSH, age, Vault
```

Symlinks are created in:
- `~/.config/zsh/`
- `~/.config/fish/`
- `~/.config/nushell/`
- `~/.config/zellij/`
- `~/.config/tmux/`
- `~/.config/btop/`
- `~/.config/git/`
- `~/.config/lazygit/`
- `~/.ssh/`
- etc.

## Customization

### Adding Your Own Config

1. Edit the base config files in `~/.local/share/greg-config/`
2. Create OS-specific overrides in `os/<os>/` subdirectories
3. Test changes
4. Commit to git (if desired)

### Local Overrides

For machine-specific settings, create local override files:
- `~/.config/zsh/.zshrc.local`
- `~/.config/git/config.local`
- `~/.ssh/config.local`

These files are gitignored and won't be committed.

### Changing Themes

**Starship**: Edit `~/.config/starship.toml`

**btop**: Change `color_theme` in `~/.config/btop/btop.conf`

**Tmux**: Edit the theme in `~/.config/tmux/tmux.conf`

**Lazygit**: Change `theme` in `~/.config/lazygit/config.yml`

## Common Tasks

### Update Configurations

```bash
cd ~/.local/share/greg-config
git pull
```

### Add New Tool

1. Create directory in appropriate category
2. Add base configuration
3. Add OS-specific overrides (if needed)
4. Update README in that category
5. Test thoroughly

### Switch Between Tools

For example, to switch from Zellij to Tmux:
```bash
# Stop using Zellij
# Start using Tmux
tmux new -s session-name
```

### Restore Previous Session

**Zellij**: Sessions are automatically restored

**Tmux**: Sessions are restored by tmux-continuum plugin
```bash
tmux
# Press Ctrl-a + Shift-r to restore
```

## Troubleshooting

### ZSH: Command not found

The tool isn't installed or not in PATH. Check with `which <tool>`.

### Tmux: Plugins not working

Install TPM and plugins:
```bash
~/.tmux/plugins/tpm/bin/install_plugins
```

Then in tmux: `Ctrl-a + I`

### Starship not showing

Install Starship:
```bash
cargo install starship
```

### btop: Dracula theme not found

Copy the theme file:
```bash
mkdir -p ~/.config/btop/themes
cp ~/.local/share/greg-config/monitoring/btop/base/themes/Dracula.theme ~/.config/btop/themes/
```

### Git: Commit signing failing

Set up GPG or SSH signing:
```bash
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
```

## Resources

- **Main README**: See `README.md` in repository root
- **AI Guide**: See `CLAUDE.md` for extending configurations
- **Tool Documentation**: Each tool has a README in its directory

## Support

For issues or questions:
1. Check the tool-specific README
2. Check the official documentation for the tool
3. Open an issue on GitHub (if applicable)

## Contributing

This is your personal dotfiles repository! Feel free to:
- Customize everything to your liking
- Add new tools and configurations
- Remove things you don't use
- Share improvements back to the community

---

**Last Updated**: 2025-03-14
**Maintainer**: Greg
