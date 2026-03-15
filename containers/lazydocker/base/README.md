# LazyDocker - Terminal UI for Docker

LazyDocker is a terminal UI for Docker and Docker Compose, making it easy to manage containers, images, volumes, and logs.

## Features

### Core Features
- **Interactive TUI** - Terminal UI for all Docker operations
- **Manage Containers** - Start, stop, restart, remove containers
- **View Logs** - Real-time log viewing with color
- **Attach Shells** - Open bash/sh in containers
- **Docker Compose** - Full Docker Compose support
- **Stats** - CPU, memory, network I/O statistics
- **Image Management** - View, prune, remove images
- **Volume Management** - Inspect and remove volumes
- **Service Management** - Manage Docker Compose services
- **Custom Commands** - Define custom shell commands
- **Themes** - Multiple color themes (Dracula, Catppuccin, etc.)

### Advantages Over Docker CLI
- Interactive interface
- Visual statistics
- Log streaming
- Multi-container management
- Faster workflows
- Less typing
- Easier navigation

## Installation

### Prerequisites

```bash
# Install LazyDocker
# macOS
brew install lazydocker

# Fedora
sudo dnf install lazydocker

# Ubuntu
sudo snap install lazydocker
# Or download binary:
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# Arch
sudo pacman -S lazydocker

# Gentoo
sudo emerge app-misc/lazydocker

# Void
sudo xbps-install lazydocker

# Alpine
sudo apk add lazydocker

# FreeBSD
sudo pkg install lazydocker

# Windows (11)
# Use WSL or download from GitHub releases
# scoop:
scoop bucket add extras
scoop install lazydocker

# Go (any OS)
go install github.com/jesseduffield/lazydocker@latest
```

### Setup

```bash
# No configuration needed
lazydocker is ready to use after installation

# Create config directory
mkdir -p ~/.config/lazydocker
```

## Usage

### Basic Usage

```bash
# Start lazydocker
lazydocker

# With specific docker compose file
lazydocker --compose-files docker-compose.yml

# With specific docker compose directory
lazydocker --project-dir /path/to/project
```

### Keybindings

#### Global Keybindings
```
q          # Quit
x          # Remove selected item
enter      # View details (logs, stats, etc.)
e          # Edit config
[          # Previous panel
]          # Next panel
```

#### Container Keybindings
```
c          # View CPU/memory stats
l          # View logs
f          # Filter logs
enter      # Attach to logs
b          # Open shell (bash)
s          # Stop container
r          # Restart container
a          # Start all stopped containers
d          # Remove container
D          # Remove all stopped containers
+          # Add new service
```

#### Service Keybindings
```
up         # Start service
down       # Stop service
restart    # Restart service
logs       # View service logs
D          # Remove all stopped containers for service
```

#### Image Keybindings
```
i          # Inspect image
f          # Remove image
d          # Remove selected image
D          # Remove all unused images (prune)
b          # Build image
```

#### Volume Keybindings
```
i          # Inspect volume
d          # Remove selected volume
D          # Remove all unused volumes (prune)
```

#### Bulk Actions
```
:          # Show custom commands menu
```

### Navigation

```bash
# Panel navigation
[           # Go to previous panel
]           # Go to next panel
↑↓          # Navigate up/down in list

# View details
Enter       # View logs/stats for selected item
Esc         # Return to list
```

### Container Management

```bash
# In LazyDocker:
# Select container
# Press actions:
s           # Stop container
r           # Restart container
d           # Remove container
b           # Open bash shell
e           # Edit container config
c           # View CPU/memory stats
l           # View logs
```

### Log Viewing

```bash
# View logs
# Select container and press: l

# Filter logs
# Press: f
# Type filter text

# Scroll in logs
# Arrow keys or PageUp/PageDown

# Follow logs
# Auto-follows new logs (tail -f)

# Copy logs
# Space to mark text
# Enter to copy

# Clear logs
# Press: x
```

### Stats Viewing

```bash
# View statistics
# Select container and press: c

# Shows:
# - CPU percentage
# - Memory usage
# - Network I/O
# - Block I/O

# Auto-refreshes
```

### Docker Compose

```bash
# View services
# Services panel shows all Docker Compose services

# Actions:
up          # Start service
down        # Stop service
restart     # Restart service
logs        # View service logs
config      # View service config
```

## Configuration

### ~/.config/lazydocker/config.yml

```yaml
# Theme configuration
gui:
  theme:
    activeBorderColor:
      - green
      - bold
    inactiveBorderColor:
      - white
    optionsTextColor:
      - blue

# Command settings
commands:
  docker:
    bin: docker
  dockerCompose:
    bin: docker compose

# OS-specific commands
os:
  openCommand: xdg-open {{path}}  # Linux
  # openCommand: open {{path}}     # macOS

# Custom shell commands
customCommand:
  container:
    - name: bash
      attach: true
      command: docker exec -it {{.Container.ID}} /bin/bash
```

### Themes

```yaml
# Dracula theme
gui:
  theme:
    activeBorderColor:
      - magenta
      - bold
    inactiveBorderColor:
      - white
    optionsTextColor:
      - cyan

# Catppuccin theme
gui:
  theme:
    activeBorderColor:
      - blue
      - bold
    inactiveBorderColor:
      - white
    optionsTextColor:
      - green
```

### Custom Commands

```yaml
customCommand:
  # Container commands
  container:
    - name: zsh
      attach: true
      command: docker exec -it {{.Container.ID}} /bin/zsh

    - name: fish
      attach: true
      command: docker exec -it {{.Container.ID}} /bin/fish

    - name: logs-tail
      attach: false
      command: docker logs --tail 100 --follow {{.Container.ID}}

    - name: inspect
      attach: false
      command: docker inspect {{.Container.ID}}

  # Service commands
  service:
    - name: restart-all
      attach: false
      command: docker compose restart {{.Service.Name}}

    - name: rebuild
      attach: false
      command: docker compose up -d --build {{.Service.Name}}
```

## Practical Examples

### Daily Development

```bash
# Start lazydocker
lazydocker

# View all containers
# Check their status

# View logs
# Select container, press 'l'

# Restart container
# Select container, press 'r'

# Open shell
# Select container, press 'b'
```

### Docker Compose Project

```bash
# Navigate to project directory
cd ~/projects/myapp

# Start lazydocker
lazydocker

# View services
# See all services from docker-compose.yml

# Start all services
# Press: 'a' or use 'up' on services

# View service logs
# Select service, press 'l'

# Restart service
# Select service, press 'r'

# Rebuild service
# Press: ':' (custom commands) or use rebuild
```

### Log Analysis

```bash
# View logs
lazydocker

# Select container
# Press 'l' for logs

# Filter logs
# Press 'f'
# Type: "ERROR"

# Search in logs
# Use '/' to search

# Copy logs
# Mark text with Space
# Copy with Enter
```

### Resource Monitoring

```bash
# View stats
lazydocker

# Select container
# Press 'c' for stats

# See:
# - CPU usage
# - Memory usage
# - Network I/O
# - Block I/O

# Monitor multiple containers
# Navigate between them
```

### Image Management

```bash
# View images
lazydocker

# Go to images panel

# Remove unused images
# Press 'D' to prune

# Remove specific image
# Select image, press 'd'

# View image details
# Select image, press 'i'
```

### Volume Cleanup

```bash
# View volumes
lazydocker

# Go to volumes panel

# Remove unused volumes
# Press 'D' to prune

# Inspect volume
# Select volume, press 'i'
```

## Tips

### Productivity

```bash
# Use bulk actions
# Press 'x' to remove multiple items

# Custom commands
# Define frequently used commands in config

# Quick access
# Lazydocker remembers your last panel

# Shell access
# Press 'b' for bash, define custom shells in config
```

### Docker Compose

```bash
# Use project directory
lazydocker --project-dir /path/to/project

# Multiple compose files
lazydocker --compose-files docker-compose.yml --compose-files docker-compose.dev.yml

# View service logs
# Services panel shows all compose services
```

### Troubleshooting

```bash
# View container logs
# Select container, press 'l'

# Check stats
# Press 'c' for CPU/memory

# Open shell
# Press 'b' to investigate

# Restart container
# Press 'r' if stuck
```

### Customization

```bash
# Define custom commands
# For common operations

# Set theme
# Use Dracula or Catppuccin for consistency

# Configure shell
# Use your preferred shell (zsh, fish, etc.)
```

## Aliases

Add to shell config:

```bash
# LazyDocker aliases
alias ld='lazydocker'              # Short alias
alias lzd='lazydocker'             # Alternative
alias lzdd='lazydocker --project-dir $(pwd)'  # Current directory
```

## Troubleshooting

### "Docker daemon not running"

```bash
# Start Docker
sudo systemctl start docker

# macOS: Start Docker Desktop
open -a Docker

# Check Docker status
docker info
```

### "Cannot connect to Docker daemon"

```bash
# Check permissions
# Add user to docker group:
sudo usermod -aG docker $USER

# Re-login required
newgrp docker

# Or use sudo
sudo lazydocker
```

### Configuration not loading

```bash
# Check config location
ls -la ~/.config/lazydocker/

# Test config
lazydocker --debug

# Create config if missing
mkdir -p ~/.config/lazydocker
# Add config.yml
```

### Services not showing

```bash
# Check docker-compose.yml exists
ls -la docker-compose.yml

# Check working directory
lazydocker --project-dir /path/to/project

# Check Docker Compose version
docker compose version
```

## Comparison

**LazyDocker:**
- Terminal UI
- Go-based
- Interactive
- Fast
- Docker Compose support
- Custom commands
- Keyboard-driven

**LazyDocker vs Portainer:**
- Portainer: Web UI
- LazyDocker: Terminal UI
- Portainer: More features
- LazyDocker: Faster

**LazyDocker vs Docker CLI:**
- Docker CLI: Native commands
- LazyDocker: Interactive UI
- Docker CLI: More control
- LazyDocker: Easier to use

**LazyDocker vs CTop:**
- CTop: Container monitoring only
- LazyDocker: Full management
- CTop: Stats-focused
- LazyDocker: Feature-rich

## Advanced Usage

### Custom Keybindings

```yaml
keybindings:
  containers:
    - key: m
      context: containers
      description: View memory stats
      command: docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}" {{.Container.ID}}
```

### Bulk Operations

```bash
# Remove all stopped containers
# Go to containers panel
# Press 'D' (bulk remove)

# Prune images
# Go to images panel
# Press 'D'

# Prune volumes
# Go to volumes panel
# Press 'D'
```

### Project Management

```bash
# Add alias for common projects
alias ldweb='lazydocker --project-dir ~/projects/webapp'
alias ldapi='lazydocker --project-dir ~/projects/api'

# Use with docker-compose.override.yml
lazydocker --compose-files docker-compose.yml --compose-files docker-compose.dev.yml
```

### Custom Themes

```yaml
# Solarized theme
gui:
  theme:
    activeBorderColor:
      - cyan
      - bold
    inactiveBorderColor:
      - base0
    optionsTextColor:
      - green

# Nord theme
gui:
  theme:
    activeBorderColor:
      - nord8
      - bold
    inactiveBorderColor:
      - nord3
    optionsTextColor:
      - nord14
```

## Integration

### With tmux

```bash
# Open lazydocker in tmux pane
# In .tmux.conf:
bind l split-window -h -c "#{pane_current_path}" 'lazydocker'
```

### With Docker Compose

```bash
# Use with multi-file projects
lazydocker --compose-files docker-compose.yml \
           --compose-files docker-compose.prod.yml

# Override directory
lazydocker --project-compose-dir docker/
```

## Resources

- [LazyDocker Website](https://lazydocker.github.io/)
- [LazyDocker GitHub](https://github.com/jesseduffield/lazydocker)
- [LazyDocker Documentation](https://github.com/jesseduffield/lazydocker/blob/master/docs/Config.md)
- [Docker Documentation](https://docs.docker.com/)

---

**Last Updated**: 2025-03-14
