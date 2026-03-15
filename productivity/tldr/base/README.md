# tldr - Simplified Man Pages

tldr is a collection of simplified and community-driven man pages. It provides practical examples for commands.

## Features

### Core Features
- **Simplified Pages** - Practical examples, not exhaustive reference
- **Community-Driven** - Crowdsourced content
- **Multiple Clients** - Official clients in many languages
- **Fast** - Quick lookup of common commands
- **Color-Coded** - Syntax highlighting
- **Offline Cache** - Download pages for offline use
- **Multi-Platform** - Works everywhere
- **Regular Updates** - Pages updated by community

### Advantages Over man
- Easier to understand
- Example-focused
- Quick reference
- Less overwhelming
- Better for beginners
- Faster to read

## Installation

### Prerequisites

```bash
# Install tldr (tealdeer is recommended)
# macOS
brew install tealdeer

# Fedora
sudo dnf install tealdeer

# Ubuntu
cargo install tealdeer

# Arch
sudo pacman -S tealdeer

# Gentoo
sudo emerge app-text/tealdeer

# Void
sudo xbps-install tealdeer

# Alpine
sudo apk add tealdeer

# FreeBSD
sudo pkg install tealdeer

# Python version (alternative)
pip install tldr

# Node version (alternative)
npm install -g tldr

# Go version (alternative)
go install github.com/navidys/tldr-pages@latest
```

### Setup

```bash
# Download pages cache
tldr --update

# Create config directory
mkdir -p ~/.config/tealdeer

# Set pager (optional)
export PAGER=less
export LESS="-R"
```

## Usage

### Basic Usage

```bash
# Show tldr page for command
tldr tar

# Show page for specific subcommand
tldr git checkout

# Update pages cache
tldr --update

# Clear cache
tldr --clear-cache

# Show pager configuration
tldr --config-paths
```

### Examples

```bash
# tar examples
tldr tar

# Output:
# > Archive and extract files.

# - Create an archive from files:
# tar cf archive.tar file1 file2 ...

# - Extract an archive:
# tar xf archive.tar

# - Create a gzipped archive:
# tar czf archive.tar.gz file1 file2 ...

# - Extract a gzipped archive:
# tar xzf archive.tar.gz

# git examples
tldr git commit

# Output:
# > Record changes to the repository.

# - Commit staged changes:
# git commit -m "message"

# - Commit all changes:
# git commit -a -m "message"

# - Amend last commit:
# git commit --amend
```

### Search

```bash
# Search for command
tldr docker

# Search with multiple words
tldr docker container

# Fuzzy search
tldr doc  # Matches docker, doctor, etc.
```

### Output Options

```bash
# Plain text (no colors)
tldr tar --color never

# Markdown output
tldr tar --markdown

# Render with specific width
tldr tar --width 80

# Without pager
tldr tar --raw
```

### Cache Management

```bash
# Update cache
tldr --update

# Clear cache
tldr --clear-cache

# Show cache location
tldr --config-paths

# Force update
tldr --update --force
```

## Configuration

### ~/.config/tealdeer/config.toml

```toml
[updates]
# Auto-update interval (in hours)
# Set to 0 to disable
auto_update = 168  # 1 week

# Auto-update on page view if cache is old
auto_update_interval_hours = 168

[display]
# Maximum line width
max_width = 100

# Compact mode (less whitespace)
compact = false

# Use pager
use_pager = true

# Show pager warning
show_pager_warning = true

[directories]
# Cache directory
cache_dir = "~/.cache/tealdeer"

# Pages directory
pages_dir = "~/.local/share/tealdeer/tldr-pages"

[style]
# Color scheme
# Options: default, solarized, ocean, simple
color_scheme = "default"

# Syntax highlighting
syntax_highlight = true

# Command name style
command_name = "bold underline"

# Example code style
example_code = "bold"

# Comments style
comments = "gray"
```

### Color Schemes

```toml
# Solarized theme
[style]
command_name = "bold cyan"
example_code = "bold green"
comments = "dim gray"

# Ocean theme
[style]
command_name = "bold blue"
example_code = "bold cyan"
comments = "dim white"

# Simple theme
[style]
command_name = "bold"
example_code = ""
comments = "dim"
```

## Practical Examples

### Daily Commands

```bash
# Look up tar command
tldr tar

# Look up git command
tldr git log

# Look up ffmpeg
tldr ffmpeg

# Look up systemctl
tldr systemctl
```

### Learning New Tools

```bash
# Learn Docker
tldr docker
tldr docker run
tldr docker-compose

# Learn kubectl
tldr kubectl
tldr kubectl get
tldr kubectl apply

# Learn tmux
tldr tmux
tldr tmux new-session
tldr tmux attach
```

### Quick Reference

```bash
# Check tar options
tldr tar

# Check git commands
tldr git

# Check ffmpeg conversion
tldr ffmpeg

# Check jq usage
tldr jq
```

### Common Commands

```bash
# System commands
tldr systemctl
tldr journalctl
tldr useradd
tldr crontab

# Development
tldr git
tldr npm
tldr docker
tldr make

# Utilities
tldr tar
tldr rsync
tldr ssh
tldr find
```

## Tips

### Offline Usage

```bash
# Download cache first
tldr --update

# Use offline
tldr tar

# Update regularly (cron job)
0 0 * * * tldr --update >/dev/null 2>&1
```

### Productivity

```bash
# Create alias for quick lookup
alias h='tldr'

# Or use function
h() {
  tldr "$@" || man "$@"
}

# First try tldr, fallback to man
```

### Custom Pages

```bash
# Add custom pages
mkdir -p ~/.local/share/tealdeer/pages

# Add your own pages
# Format: https://github.com/tldr-pages/tldr/blob/main/CONTRIBUTING.md
```

### Integration

```bash
# With fzf
tldr $(fzf --preview "tldr {}")

# With shell completions
# Bash: Add to .bashrc
eval "$(tldr --bash-completion)"

# Zsh: Add to .zshrc
eval "$(tldr --zsh-completion)"

# Fish: Add to config.fish
tldr --fish-completion | source
```

## Aliases

Add to shell config:

```bash
# tldr aliases
alias h='tldr'                  # Quick lookup
alias tldr-update='tldr --update'  # Update cache
alias tldr-clear='tldr --clear-cache'  # Clear cache

# Fallback to man
man-tldr() {
  tldr "$@" 2>/dev/null || man "$@"
}
alias man='man-tldr'
```

## Troubleshooting

### "Page not found"

```bash
# Update cache
tldr --update

# Check spelling
tldr docker  # Not doker

# Search for similar
tldr doc
```

### "Cache is old"

```bash
# Update cache
tldr --update

# Enable auto-update
# In config.toml:
auto_update = 168  # hours
```

### "No color output"

```bash
# Check if pager is set
echo $PAGER

# Set pager
export PAGER=less
export LESS="-R"

# Or use --raw
tldr tar --raw
```

## Comparison

**tldr:**
- Simplified pages
- Example-focused
- Multiple implementations
- Community-driven
- Fast to read
- Great for beginners

**man:**
- Comprehensive
- Reference-style
- Universal
- Authoritative
- Detailed
- Overwhelming

**cheat:**
- Similar to tldr
- Community-driven
- More examples
- Less structured
- More content

**navi:**
- Interactive cheatsheets
- Shell integration
- Interactive preview
- More complex
# Context-aware

## Contributing

```bash
# tldr is community-driven
# Contribute pages:

# Clone repository
git clone https://github.com/tldr-pages/tldr.git

# Add or edit pages
cd tldr/pages

# Format:
# - Name: command
# - Description
# - Examples with description

# Submit pull request
```

## Resources

- [tldr Pages Website](https://tldr.sh/)
- [tldr GitHub](https://github.com/tldr-pages/tldr)
- [Tealdeer GitHub](https://github.com/dbrgn/tealdeer)
- [tldr Contributing Guide](https://github.com/tldr-pages/tldr/blob/main/CONTRIBUTING.md)

---

**Last Updated**: 2025-03-14
