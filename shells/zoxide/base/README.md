# Zoxide - Smarter cd Command

Zoxide is a smarter `cd` command that learns your habits. It keeps track of directories you visit and uses a ranking algorithm to jump to the most likely directory.

## Features

### Core Features
- **Smart Jumping** - Jump to frequently used directories
- **Fuzzy Matching** - Find directories with partial names
- **Database** - SQLite database for fast lookups
- **Cross-Shell** - Works with bash, zsh, fish, nushell
- **Priority System** - Ranks by frequency and recency
- **Auto-Learning** - Tracks directories automatically
- **FZF Integration** - Interactive selection with fzf
- **Fast** - Written in Rust, very fast

### Advantages Over cd
- Jump to any directory with partial name
- No need to remember full paths
- Learns your workflow
- Cross-machine database (can sync)
- Works with any shell

## Installation

### Prerequisites

```bash
# Install Zoxide
# macOS
brew install zoxide

# Fedora
sudo dnf install zoxide

# Ubuntu
cargo install zoxide

# Arch
sudo pacman -S zoxide

# Gentoo
sudo emerge app-shells/zoxide

# Void
sudo xbps-install zoxide

# Alpine
sudo apk add zoxide

# FreeBSD
sudo pkg install zoxide

# Windows (11)
winget install ajeetdsouza.zoxide
# Or use scoop:
scoop install zoxide

# Cargo (Rust)
cargo install zoxide
```

### Setup

```bash
# Add to shell configuration
# See below for shell-specific instructions
```

## Shell Integration

### Zsh

Add to `~/.config/zsh/base/.zshrc`:

```bash
# Zoxide initialization
eval "$(zoxide init zsh)"
```

### Bash

Add to `~/.bashrc`:

```bash
# Zoxide initialization
eval "$(zoxide init bash)"
```

### Fish

Add to `~/.config/fish/config.fish`:

```fish
# Zoxide initialization
zoxide init fish | source
```

### Nushell

Add to `~/.config/nushell/env.nu`:

```nu
# Zoxide initialization
# Add to config.nu
# Note: Nushell support is built-in
```

## Usage

### Basic Usage

```bash
# Jump to directory (partial name match)
z projects        # Goes to ~/projects or highest-ranked "projects"
z dot             # Goes to ~/dotfiles or ~/Documents/dots
z down            # Goes to ~/Downloads

# Jump to subdirectory
z proj web        # Goes to ~/projects/web

# Jump with multiple path components
z src main        # Goes to ~/projects/src/main

# Go to parent directory
z ..              # Goes to parent (like cd ..)
z ...             # Goes to grandparent (cd ../..)
```

### Interactive Mode (with FZF)

```bash
# Interactive directory selection
zi               # Shows interactive menu with fzf
zi proj          # Filter directories matching "proj"

# Search with preview
# Requires fzf configuration
```

### Database Management

```bash
# Add directory to database
zoxide add ~/projects

# Remove directory from database
zoxide remove ~/projects

# Query database
zoxide query -l     # List all directories
zoxide query -ls    # List with scores

# Import from autojump
zoxide import /path/to/autojump/db

# Import from z
zoxide import /path/to/z/db

# Clear database
zoxide clear
```

## Configuration

### Environment Variables

```bash
# Database location
export _ZO_DATA_DIR="$HOME/.local/share/zoxide"

# Maximum entries in database (default: 10000)
export _ZO_MAXAGE=10000

# Resolve symlinks (default: false)
export _ZO_RESOLVE_SYMLINKS=1

# Prioritize by frequency and recency (default: recent)
export _ZO_PRIORITIZE="recent,frequent"

# Exclude directories (colon-separated)
export _ZO_EXCLUDE_DIRS="$HOME:$HOME/old"

# Auto-add directories (default: true)
export _ZO_AUTO_ADD=1

# Echo directory after cd (default: false)
export _ZO_ECHO=1

# Define command name (default: z)
export _ZO_CMD="z"

# Define interactive command (default: zi)
export _ZO_FZF_CMD="zi"

# FZF options
export _ZO_FZF_OPTS="--preview 'ls -la {}'"
```

### Priority System

```bash
# Recent only (default)
export _ZO_PRIORITIZE="recent"

# Frequent only
export _ZO_PRIORITIZE="frequent"

# Mixed (recommended)
export _ZO_PRIORITIZE="recent,frequent"
```

### Exclusions

```bash
# Exclude directories from database
export _ZO_EXCLUDE_DIRS="$HOME:$HOME/old:$HOME/temp"

# Exclude by pattern (in shell)
z --exclude "$HOME/temp"
```

## Practical Examples

### Daily Workflow

```bash
# Jump to common directories
z proj        # ~/projects
z docs        # ~/Documents
z down        # ~/Downloads
z dot         # ~/dotfiles

# Jump to subdirectories
z proj web    # ~/projects/web
z src rust    # ~/projects/src/rust

# Go to parent
z ..          # cd ../..
```

### Web Development

```bash
# Jump to project
z webshop     # ~/projects/webshop

# Jump to specific directory
z web src     # ~/projects/webshop/src
z web public  # ~/projects/webshop/public
```

### System Administration

```bash
# Jump to system directories
z sys         # /etc or ~/sysadmin
z log         # /var/log or ~/logs
z www         # /var/www or ~/www
```

### Interactive Selection

```bash
# Show all directories
zi

# Filter by pattern
zi web

# With preview
export _ZO_FZF_OPTS="--preview 'tree -C {}'"
zi
```

### Database Management

```bash
# Show database
zoxide query -l

# Show with scores
zoxide query -ls

# Check if directory is tracked
zoxide query ~/projects

# Remove directory
zoxide remove ~/old-project
```

## Tips

### Performance

```bash
# Limit database size
export _ZO_MAXAGE=5000

# Exclude temporary directories
export _ZO_EXCLUDE_DIRS="$HOME/tmp:/tmp"

# Resolve symlinks for consistency
export _ZO_RESOLVE_SYMLINKS=1
```

### Productivity

```bash
# Use short aliases
alias z='zoxide'
alias zi='zoxide -i'

# Echo directory for confirmation
export _ZO_ECHO=1

# Use mixed priority for best results
export _ZO_PRIORITIZE="recent,frequent"
```

### Integration

```bash
# Works with fzf for interactive selection
# Install fzf first
brew install fzf

# Then use zi command

# Works with other tools
# e.g., use with exa/ls
z proj && exa -la
```

### Cross-Machine

```bash
# Sync database across machines
# Add to dotfiles:
cp ~/.local/share/zoxide/db ~/dotfiles/

# Or use git:
git add ~/.local/share/zoxide/db
git commit -m "Update zoxide database"
```

## Aliases

Add to shell config:

```bash
# Zoxide aliases
alias z='zoxide'
alias zi='zoxide -i'
alias za='zoxide add'
alias zr='zoxide remove'
alias zq='zoxide query'
```

## Troubleshooting

### "Command not found: zoxide"

```bash
# Check installation
which zoxide

# Reinstall with cargo
cargo install zoxide

# Check PATH
echo $PATH | grep zoxide
```

### "z: command not found"

```bash
# Check shell integration
echo $PROMPT_COMMAND | grep zoxide

# For Bash, check .bashrc
grep "zoxide init" ~/.bashrc

# For Zsh, check .zshrc
grep "zoxide init" ~/.zshrc

# Restart shell
exec $SHELL
```

### Database issues

```bash
# Clear database
zoxide clear

# Rebuild database
# Just use zoxide normally, it will learn again

# Check database location
echo $_ZO_DATA_DIR
```

### Wrong directory selected

```bash
# Check database
zoxide query -ls

# Remove incorrect entry
zoxide remove ~/wrong/path

# Add correct path manually
zoxide add ~/correct/path
```

## Comparison

**Zoxide:**
- Rust-based (fast)
- SQLite database
- Fuzzy matching
- FZF integration
- Cross-platform

**z (jump):**
- Bash script
- Plain text database
- Regex matching
- Simpler
- More mature

**autojump:**
- Python-based
- Database file
- Fuzzy matching
- Older
- Slower

**fasd:**
- Shell script
- Plain text
- Frequency-based
- Simpler
- Less active

**goto:**
- Shell script
- Very simple
- No database
- Fast
- Minimal

## Migration

### From autojump

```bash
# Import autojump database
zoxide import ~/.local/share/autojump/autojump.txt

# Remove autojump
# Ubuntu/Debian:
sudo apt remove autojump

# macOS:
brew remove autojump
```

### From z (jump)

```bash
# Import z database
zoxide import ~/.z

# Remove z
# Usually just remove from shell config
```

### From fasd

```bash
# fasd uses different format
# Manually rebuild database with zoxide
# Just use directories normally
```

## Advanced Usage

### Custom Scoring

```bash
# Adjust priority calculation
export _ZO_PRIORITIZE="recent,frequent"

# Recent only - recently used directories
export _ZO_PRIORITIZE="recent"

# Frequent only - most used directories
export _ZO_PRIORITIZE="frequent"
```

### Interactive Mode

```bash
# With fzf preview
export _ZO_FZF_OPTS="--preview 'exa -la {}'"

# With custom height
export _ZO_FZF_OPTS="--height 50%"

# With border
export _ZO_FZF_OPTS="--border"
```

### Directory Aliases

```bash
# Use zoxide for quick access
z docs        # ~/Documents
z proj        # ~/projects
z dot         # ~/dotfiles

# Combine with other commands
z proj && git status
z web && npm start
```

## Resources

- [Zoxide GitHub](https://github.com/ajeetdsouza/zoxide)
- [Zoxide Documentation](https://github.com/ajeetdsouza/zoxide#readme)
- [Comparison with autojump](https://github.com/ajeetdsouza/zoxide#comparison)

---

**Last Updated**: 2025-03-14
