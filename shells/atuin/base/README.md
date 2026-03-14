# Atuin - Magical Shell History

Atuin replaces your existing shell history with a SQLite database, and records additional context for your commands. It also provides optional and fully encrypted synchronisation of your history between machines, via Atuin's sync server.

## Features

### Core Features
- **SQLite Database** - Fast, searchable history storage
- **Context Recording** - Stores exit code, duration, directory, command
- **Sync** - Encrypted cross-machine history sync
- **Full-Text Search** - Search commands by content, directory, etc.
- **Fuzzy Matching** - Find commands even with typos
- **Statistics** - Command usage analytics
- **Filtering** - Filter by session, directory, exit code
- **Encryption** - End-to-end encryption for sync

### Advantages Over Default History
- Persistent across terminals
- Sync between machines
- Rich context (exit codes, timing)
- Better search (fuzzy, regex)
- Statistics and insights
- Faster queries

## Installation

### Prerequisites

```bash
# Install Atuin
# macOS
brew install atuin

# Fedora
sudo dnf install atuin

# Ubuntu
curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | sh
# Or with cargo:
cargo install atuin

# Arch
sudo pacman -S atuin

# Gentoo
sudo emerge app-shells/atuin

# Void
sudo xbps-install atuin

# Alpine
sudo apk add atuin

# FreeBSD
sudo pkg install atuin

# Windows (11)
winget install atuin.atuin
# Or use scoop:
scoop install atuin
```

### Setup

```bash
# Register account (optional, for sync)
atuin register

# Login
atuin login

# Sync history
atuin sync

# Or use self-hosted server
atuin server register
```

## Shell Integration

### Zsh

Add to `~/.config/zsh/base/.zshrc`:

```bash
# Atuin initialization
eval "$(atuin init zsh)"
```

### Bash

Add to `~/.bashrc`:

```bash
# Atuin initialization
eval "$(atuin init bash)"
```

### Fish

Add to `~/.config/fish/config.fish`:

```fish
# Atuin initialization
atuin init fish | source
```

### Nushell

Add to `~/.config/nushell/env.nu`:

```nu
# Atuin initialization
# Add to your config.nu
# Note: Nushell support is experimental
```

## Usage

### Basic Search

```bash
# Open interactive search (Ctrl+R)
# Press Ctrl+R in your shell

# Search for command
# Just start typing!

# Exit search
# Ctrl+C or Esc
```

### Command Line

```bash
# Search history
atuin search git

# Search with fuzzy match
atuin search "git cm"  # Matches "git commit"

# Search for exact phrase
atuin search "systemctl restart"

# List recent commands
atuin history

# Show statistics
atuin stats

# Show command count
atuin stats count
```

### Sync

```bash
# Sync history
atuin sync

# Sync automatically (on shell exit)
# Configured in config.toml

# Manual sync
atuin sync --force
```

### Management

```bash
# Delete specific command
atuin delete

# Delete all history
atuin delete --all

# Import from existing history
atuin import

# Import from zsh history
atuin import zsh

# Import from bash history
atuin import bash

# Export history
atuin export > backup.json

# Import from backup
atuin import backup.json
```

## Configuration

### config.toml

```toml
# Location: ~/.config/atuin/config.toml

# Search mode
# Options: "full", "prefix", "fuzzy", "skim"
search_mode = "fuzzy"

# Search filter
# Options: "global", "session", "directory"
search_filter = "global"

# Sync address
# For self-hosted:
sync_address = "https://atuin.example.com"

# Auto-sync
auto_sync = true

# Sync frequency (seconds)
# 0 = manual only
sync_frequency = 0

# Update check
update_check = true

# Keybindings
keymap_ctrl_r = false

# Filter mode
filter_mode_shell_up_key = "directory"
```

### History Filters

```toml
# Prevent recording certain commands
history_filter = [
  "^ls$",
  "^ll$",
  "^cd$",
  "^pwd$",
  "^exit$",
  "^clear$",
]

# Filter sensitive commands
secret_filter = [
  "password*",
  "apikey*",
  "*password*",
  "secret*",
]
```

### Search Modes

```toml
# Full search - search entire command
search_mode = "full"

# Prefix search - match from start
search_mode = "prefix"

# Fuzzy search - fuzzy matching
search_mode = "fuzzy"

# Skim search - skim-like fuzzy
search_mode = "skim"
```

## Practical Examples

### Daily Workflow

```bash
# Open search with Ctrl+R
# Type "deploy" to find deploy commands
# Use arrow keys to navigate
# Press enter to execute

# Quick statistics
atuin stats

# Most used commands
atuin stats count
```

### Cross-Machine Sync

```bash
# On first machine
atuin register
atuin sync

# On second machine
atuin login
atuin sync

# Now both machines have same history!
```

### Team History

```bash
# Self-host Atuin for team history
# Set up Atuin server
atuin server register

# All team members join
atuin register
atuin sync

# Search team command history
# Useful for shared deployment commands!
```

### Context-Aware Search

```bash
# Search commands in current directory
atuin search "git commit"

# Filter by exit code
atuin search "exit:1"

# Filter by duration
atuin search "duration:>10"

# Filter by session
atuin search "session:12345"
```

### Statistics

```bash
# Show command statistics
atuin stats

# Most used commands
atuin stats count

# Commands by directory
atuin stats directory

# Commands by hour
atuin stats hour

# Commands by day
atuin stats day
```

## Tips

### Privacy

```bash
# Don't record sensitive commands
# Add to secret_filter in config.toml

# Disable sync for sensitive commands
atuin sync --exclude

# Disable statistics
send_stats = false
```

### Performance

```bash
# For large history, use fuzzy search
search_mode = "fuzzy"

# Limit history size
atuin prune --days 365

# Optimize database
atuin store optimize
```

### Productivity

```bash
# Use directory-aware search
search_filter = "directory"

# Filter common commands
history_filter = ["^ls$", "^cd$", "^pwd$"]

# Use prefix mode for exact matches
search_mode = "prefix"
```

### Integration

```bash
# Works with all shells
# Zsh, Bash, Fish, Nushell

# Works with tmux/zellij
# Just install in shell

# Works with starship prompt
# Load atuin before starship
```

## Aliases

Add to shell config:

```bash
# Aliases for atuin
alias at='atuin'           # Short alias
alias ats='atuin search'   # Search
alias ath='atuin history'  # History
alias atst='atuin stats'   # Stats
# sync is already short!
```

## Troubleshooting

### "Command not found: atuin"

```bash
# Check installation
which atuin

# Reinstall
cargo install atuin

# Check PATH
echo $PATH | grep atuin
```

### History not syncing

```bash
# Check login status
atuin status

# Manually sync
atuin sync --force

# Check server address
grep sync_address ~/.config/atuin/config.toml
```

### Ctrl+R not working

```bash
# Check shell integration
echo $PROMPT_COMMAND | grep atuin

# For Bash, check .bashrc
grep "atuin init" ~/.bashrc

# For Zsh, check .zshrc
grep "atuin init" ~/.zshrc

# Restart shell
exec $SHELL
```

### Database locked

```bash
# Atuin uses SQLite, can be locked
# Kill other atuin processes
pkill atuin

# Restart shell
exec $SHELL
```

## Advanced Usage

### Self-Hosting

```bash
# Run Atuin server
docker run -d \
  --name atuin \
  -p 8888:8888 \
  -v atuin-data:/data \
  ghcr.io/atuinsh/atuin:server

# Configure client
sync_address = "http://your-server:8888"

# Register with self-hosted server
atuin server register
```

### Custom Scripts

```bash
# Command to show most used commands
atuin stats count | head -20

# Command to show history by hour
atuin stats hour

# Command to export history
atuin export > history.json

# Command to prune old history
atuin prune --days 90
```

### Filtering

```bash
# Search by exit code
atuin search "exit:0"   # Successful commands
atuin search "exit:1"   # Failed commands

# Search by duration
atuin search "duration:>60"  # Commands > 60s

# Search by directory
atuin search "cwd:/home/user/project"

# Combine filters
atuin search "git exit:0 cwd:/home/user/project"
```

## Comparison

**Atuin:**
- SQLite database (fast)
- Sync with encryption
- Rich context (exit code, duration)
- Cross-platform
- Modern and actively developed

**Default Shell History:**
- Simple text file
- No sync
- No context
- Limited search
- Works everywhere

**fzf + Ctrl-R:**
- Fuzzy search
- No database
- No sync
- Simple to use
- Less features

**McFly:**
- Neural network suggestions
- No sync
- Ruby-based
- Less active
- Simpler

## Resources

- [Atuin Website](https://atuin.sh)
- [Atuin GitHub](https://github.com/atuinsh/atuin)
- [Atuin Documentation](https://atuin.sh/docs/)
- [Self-Hosting Guide](https://atuin.sh/docs/self-hosting)

---

**Last Updated**: 2025-03-14
