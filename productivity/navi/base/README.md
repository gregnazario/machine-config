# Navi - Interactive Cheatsheets

Navi is an interactive cheatsheet tool for the command line. It provides a quick way to access command examples and snippets.

## Features

### Core Features
- **Interactive** - FZF-based interactive selection
- **Cheat Sheets** - Community-driven cheat sheets
- **Shell Integration** - Works with bash, zsh, fish
- **Auto-Suggestions** - Suggests commands as you type
- **Variable Replacement** - Interactive variable input
- **Multiple Sources** - Custom cheat sheets
- **Fast** - Instant access to commands
- **Learning Tool** - Great for discovering new commands

### Advantages Over tldr/man
- Interactive selection
- Shell integration
- Variable replacement
- Custom cheat sheets
- Faster workflow
- Context-aware

## Installation

### Prerequisites

```bash
# Install Navi
# macOS
brew install navi

# Fedora
sudo dnf install navi

# Ubuntu
curl https://raw.githubusercontent.com/denisid/navi/master/scripts/install | bash
# Or with cargo:
cargo install navi

# Arch
sudo pacman -S navi

# Gentoo
sudo emerge app-shells/navi

# Void
sudo xbps-install navi

# Alpine
sudo apk add navi

# FreeBSD
sudo pkg install navi

# Windows (11)
# Use WSL or install via Go:
go install github.com/denisid/navi@latest

# Go (any OS)
go install github.com/denisid/navi@latest
```

### Setup

```bash
# Download cheat sheets
navi repo add denisid/cheats

# Create custom cheatsheets
mkdir -p ~/.config/navi/cheats
```

## Usage

### Basic Usage

```bash
# Open interactive cheatsheet
navi

# Search for specific tag
navi query git

# Print command without executing
navi --print git

# Best command (fzf-style)
navi best "docker ps"
```

### Shell Integration

#### Bash

```bash
# Add to ~/.bashrc
eval "$(navi widget bash)"

# Press Ctrl+G in bash to open navi
# Type to search, select command, edit variables, press enter
```

#### Zsh

```bash
# Add to ~/.zshrc
eval "$(navi widget zsh)"

# Press Ctrl+G in zsh to open navi
```

#### Fish

```bash
# Add to ~/.config/fish/config.fish
navi widget fish | source

# Press Ctrl+G in fish to open navi
```

### Interactive Mode

```bash
# Open navi
navi

# Search:
# - Type to filter
# - Use arrow keys to navigate
# - Press Tab to select
# - Press Enter to insert

# Variables:
# - Navi prompts for variable values
# - Type values or select from suggestions
# - Press Enter to continue

# Execute:
# - Press Enter to execute command
# - Press Ctrl+C to cancel
```

### Query Mode

```bash
# Search by tag
navi query docker

# Search by tag and filter
navi query git "commit"

# Query multiple tags
navi query kubernetes "pod delete"
```

### Best Mode

```bash
# Find best matching command
navi best "git commit"

# Use in pipeline
echo "compress directory" | navi best

# Print command only
navi best --print "docker container remove"
```

### Filtering

```bash
# Search for specific cheatsheet
navi --path ~/cheats/docker.cheats

# Search multiple paths
navi --path ~/cheats --path ~/.config/navi/cheats
```

## Cheatsheet Format

### Basic Structure

```bash
# ~/.config/navi/cheats/mycheats.cheats

# Tag
% git, git commit

# Description
# Commit changes with message

# Command
git commit -m "{{message}}"

# Tags
% docker, docker ps

# Description
# List running containers

# Command
docker ps

# Variables
docker logs --follow "{{container_name}}"
```

### Advanced Features

```bash
# Multiple variables
% docker, docker logs

# View container logs

docker logs --follow "{{container}}" --tail "{{lines:=100}}"

# Options
% git, git push

# Push to remote

git push {{remote:=origin}} {{branch:=main}}

# Commands with options
% ffmpeg, video to gif

# Convert video to GIF

ffmpeg -i "{{input}}" -vf "fps={{fps:=10}},scale={{width:=320}}:-1" "{{output}}.gif"

# Dependencies
% kubectl, kubectl logs

# View pod logs

kubectl logs -f {{pod}} --namespace {{namespace:=default}}
```

## Configuration

### ~/.config/navi/config.yaml

```yaml
# Cheatsheet paths
files:
  - ~/.config/navi/cheats
  - /usr/share/navi/cheats

# FZF options
finder:
  fzf:
    overrides: --height 80% --layout reverse --border

# Style
style:
  tag:
    color: cyan
    width: 30
  comment:
    color: gray
    width: 60
  snippet:
    color: white
```

## Practical Examples

### Custom Cheatsheets

```bash
# Development
% git, git commit amend

# Amend last commit

git commit --amend --no-edit

% npm, npm script

# Run npm script

npm run {{script}}

# Docker
% docker, docker compose up

# Start docker compose

docker compose up -d {{service:=}}

# System
% systemd, restart service

# Restart systemd service

sudo systemctl restart {{service}}
```

### Daily Workflow

```bash
# Press Ctrl+G to open navi
# Search for git commands
# Select "git commit"
# Enter commit message
# Press Enter to execute

# Search for docker commands
# Select "docker compose up"
# Enter service name
# Press Enter to execute

# Search for kubectl commands
# Select "kubectl get pods"
# Enter namespace
# Press Enter to execute
```

### Learning New Commands

```bash
# Open navi
navi

# Browse git commands
navi query git

# Browse docker commands
navi query docker

# Browse kubernetes commands
navi query kubernetes
```

### Shell Scripting

```bash
# Use navi in scripts
#!/bin/bash

# Get command from navi
command=$(navi best --print "docker container remove")

# Execute command
eval $command

# Or with variables
container=$(navi best --print "docker container name")
docker logs "$container"
```

## Tips

### Productivity

```bash
# Use shell integration (Ctrl+G)
eval "$(navi widget bash)"

# Create aliases for common queries
alias navi-git='navi query git'
alias navi-docker='navi query docker'
alias navi-k8s='navi query kubernetes'

# Use best mode for quick commands
navi best "git commit"
```

### Custom Cheatsheets

```bash
# Organize by topic
# ~/.config/navi/cheats/git.cheats
# ~/.config/navi/cheats/docker.cheats
# ~/.config/navi/cheats/work.cheats

# Use descriptive names
# Include tags for easy searching
# Add variables for flexibility
```

### Team Sharing

```bash
# Share cheatsheets via git
cd ~/cheats
git init
git add .
git commit -m "Add team cheatsheets"

# Clone team cheatsheets
git clone https://github.com/team/cheats ~/.config/navi/cheats/team
```

### Variable Defaults

```bash
# Set default values with :=
docker logs {{container}} --tail {{lines:=100}}

# Use with navi
# navi prompts for container
# lines defaults to 100
```

## Aliases

Add to shell config:

```bash
# Navi aliases
alias n='navi'                  # Short alias
alias nq='navi query'           # Query mode
alias nb='navi best'            # Best mode
alias np='navi --print'         # Print only

# Topic-specific
alias navi-git='navi query git'
alias navi-docker='navi query docker'
alias navi-k8s='navi query kubernetes'
```

## Troubleshooting

### "No cheatsheets found"

```bash
# Download official cheatsheets
navi repo add denisid/cheats

# Check path
navi --path ~/.config/navi/cheats

# Create custom cheatsheets
mkdir -p ~/.config/navi/cheats
```

### "Ctrl+G not working"

```bash
# Check shell integration
echo $PROMPT_COMMAND | grep navi  # Bash
grep "navi widget" ~/.zshrc        # Zsh

# Add to shell config
# Reload shell
exec $SHELL
```

### "Variable prompt not working"

```bash
# Check FZF is installed
which fzf

# Install FZF
brew install fzf  # macOS
sudo apt install fzf  # Ubuntu

# Check cheatsheet format
# Variables must be in {{var}} format
```

## Comparison

**Navi:**
- Interactive
- FZF-based
- Shell integration
- Variable replacement
- Custom cheat sheets
- Context-aware

**tldr:**
- Static pages
- Community-driven
- Example-focused
- Read-only
- Simple

**cheat:**
- Community-driven
- More examples
- Less interactive
- Simple format

**man:**
- Comprehensive
- Reference-style
- Not interactive
- Universal

## Cheatsheet Repositories

```bash
# Official cheatsheets
navi repo add denisid/cheats

# Custom repository
navi repo add https://github.com/user/cheats

# List repositories
navi repo list

# Remove repository
navi repo remove denisid/cheats
```

## Resources

- [Navi Website](https://navi.cli.fi/)
- [Navi GitHub](https://github.com/denisid/navi)
- [Navi Documentation](https://github.com/denisid/navi/blob/master/README.md)
- [Example Cheatsheets](https://github.com/denisid/cheats)

---

**Last Updated**: 2025-03-14
