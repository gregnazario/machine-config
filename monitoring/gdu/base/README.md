# gdu - Disk Usage Analyzer

gdu is a disk usage analyzer written in Go, with fast TUI interface.

## Features

### Core Features
- **Fast** - Written in Go, very fast
- **TUI** - Interactive terminal interface
- **Cross-Platform** - Linux, macOS, Windows, BSD
- **Colors** - Color-coded by usage
- **Sorting** - Sort by size, name, etc.
- **Filtering** - Filter files and directories
- **Deletion** - Delete files from TUI
- **Mount Points** - Show all mounted filesystems
- **Interactive** - Navigate with keyboard
- **JSON Output** - Machine-readable output
- **Follow Symlinks** - Follow or not follow symlinks

### Advantages Over ncdu
- Faster (Go vs C)
- More features
- Better UI
- Cross-platform
- Active development

## Installation

### Prerequisites

```bash
# Install gdu
# macOS
brew install gdu

# Fedora
sudo dnf install gdu

# Ubuntu
# Download .deb from GitHub releases
# https://github.com/dundee/gdu/releases

# Arch
sudo pacman -S gdu

# Gentoo
sudo emerge app-admin/gdu

# Void
sudo xbps-install gdu

# Alpine
sudo apk add gdu

# FreeBSD
sudo pkg install gdu

# Windows (11)
# Download from GitHub releases
# scoop:
scoop install gdu

# Go (any OS)
go install github.com/dundee/gdu@latest
```

### Setup

```bash
# No configuration needed
gdu is ready to use after installation

# Create config directory (optional)
mkdir -p ~/.config/gdu
```

## Usage

### Basic Usage

```bash
# Analyze current directory
gdu

# Analyze specific directory
gdu /home/user

# Analyze directory with path
gdu ~/Documents

# Analyze root filesystem
gdu /

# Analyze multiple directories
gdu ~/Documents ~/Pictures ~/Downloads
```

### TUI Navigation

```bash
# Navigation:
# - Arrow keys or hjkl (vim-style)
# - Enter: Open directory
# - Backspace/Escape: Go up
# - l: Open directory (like vim)
# - h: Go to parent directory
# - q: Quit
# - d: Delete selected file/directory
# - r: Rescan current directory
# - s: Sort by size
# - S: Sort by size (descending)
# - n: Sort by name
# - N: Sort by name (reverse)
# - c: Sort by item count
# - C: Sort by item count (descending)
# - /: Filter/search
# - a: Toggle show hidden files
# - e: Toggle apparent size
# - m: Toggle mtime (modification time)
# - b: Show mounted filesystems
# - i: Show item information
# - ?: Show help
```

### Output Formats

```bash
# Interactive TUI (default)
gdu

# List format (no TUI)
gdu -l ~/Documents

# JSON output
gdu -json ~/Documents

# CSV output
gdu -csv ~/Documents
```

### Filtering

```bash
# Analyze with pattern filter
gdu -f "*.log" /var/log

# Analyze with max depth
gdu -d 2 ~/Documents

# Show hidden files
gdu -a ~/Documents

# Follow symlinks
gdu -L ~/Documents
```

### Deletion

```bash
# In TUI:
# Navigate to file/directory
# Press 'd' to delete
# Confirm deletion

# Delete without prompt (dangerous!)
gdu -d ~/Documents
```

### Analysis Options

```bash
# Count duplicates
gdu -c ~/Documents

# Show apparent size (not disk usage)
gdu -e ~/Documents

# Show modification time
gdu -m ~/Documents

# Max depth
gdu -d 3 ~/Documents

# Use specific device
# Only analyze filesystem containing path
```

## Practical Examples

### Disk Cleanup

```bash
# Analyze home directory
gdu ~/

# Find large directories
# Navigate to largest dirs
# Delete unnecessary files (press 'd')

# Find old files
# Press 'm' to show modification time
# Sort by time
# Delete old backups
```

### System Administration

```bash
# Analyze root filesystem
sudo gdu /

# Show mounted filesystems
# Press 'b' in TUI

# Analyze /var
sudo gdu /var

# Find large log files
# Navigate to /var/log
# Sort by size (press 's')
# Rotate or delete old logs
```

### Project Cleanup

```bash
# Analyze project directory
cd ~/projects/myproject
gdu

# Find node_modules
gdu -d 1 ~/projects

# Find build artifacts
# Look for dist/, build/, target/
# Delete if needed
```

### Storage Analysis

```bash
# Analyze disk usage by type
gdu ~/Documents
gdu ~/Pictures
gdu ~/Videos
gdu ~/Downloads

# Compare sizes
# Make decisions about what to archive
```

### Server Cleanup

```bash
# SSH to server
ssh server

# Run gdu
sudo gdu /

# Find large directories
# Clean up logs, temp files, old backups

# Delete from TUI
# Press 'd' on selected item
```

## Tips

### Productivity

```bash
# Use max depth for quick overview
gdu -d 1 ~/

# Sort by different criteria
# 's' - size
# 'n' - name
# 'c' - count

# Use filter to find specific files
# Press '/' in TUI
# Type pattern
```

### Safety

```bash
# Always use list mode first
gdu -l ~/Documents

# Check what will be deleted
# Don't use 'd' without reviewing

# Use -n for dry-run (if available)
# Or just look before pressing 'd'
```

### Performance

```bash
# Limit depth for large filesystems
gdu -d 3 /

# Don't follow symlinks (default)
# Faster analysis

# Count duplicates slower
# Only use -c when needed
```

### Automation

```bash
# Export to JSON for analysis
gdu -json ~/Documents > usage.json

# Process with jq
gdu -json ~/Documents | jq '.[] | select(.size > 1000000000)'

# Export to CSV
gdu -csv ~/Documents > usage.csv
```

## Aliases

Add to shell config:

```bash
# gdu aliases
alias du='gdu'                   # Replace du
alias gdus='gdu -l'              # List mode
alias gdua='gdu -a'              # Show hidden
alias gdud='gdu -d 2'            # Depth 2
alias gduj='gdu -json'           # JSON output
alias gduc='gdu -csv'            # CSV output
```

## Troubleshooting

### "Permission denied"

```bash
# Some directories need root
sudo gdu /

# Or analyze specific user directory
gdu ~/Documents
```

### "Too slow"

```bash
# Limit depth
gdu -d 2 ~/

# Don't count duplicates
# Don't use -c flag

# Use list mode for quick view
gdu -l ~/
```

### "Can't delete"

```bash
# Check permissions
ls -la file.txt

# Use sudo for deletion
sudo gdu /path
# Then press 'd' in TUI
```

## Comparison

**gdu:**
- Written in Go
- Very fast
- Modern TUI
- Cross-platform
- Actively developed
- More features

**ncdu:**
- Written in C
- Fast
- Simple TUI
- Cross-platform
- Older
- Simpler

**du:**
- Built-in
- No TUI
- Basic
- Universal
- Slow on large trees

**baobab:**
- GUI tool
- GNOME-focused
- Graphical
- Linux only
- Easier for beginners

## Advanced Usage

### Scripting

```bash
# Find large files
gdu -json ~/Documents | \
  jq -r '.[] | select(.size > 100000000) | .name'

# Analyze multiple directories
for dir in ~/Documents ~/Pictures ~/Videos; do
  echo "=== $dir ==="
  gdu -d 1 "$dir"
done

# Compare sizes before/after
gdu -json ~/before > before.json
gdu -json ~/after > after.json
diff <(jq '.[].size' before.json) \
     <(jq '.[].size' after.json)
```

### Scheduled Analysis

```bash
# Daily disk usage report
0 0 * * * /usr/bin/gdu -json ~/Documents > ~/usage-$(date +\%Y\%m\%d).json

# Weekly cleanup reminder
0 9 * * 1 /usr/bin/gdu -d 1 ~/Documents | mail -s "Disk usage" user@example.com
```

### Monitoring

```bash
# Watch directory size
watch -n 3600 'gdu -l ~/Documents | head -20'

# Alert if size exceeds threshold
size=$(gdu -json ~/Documents | jq '[.[].size] | add')
threshold=$((100*1024*1024*1024))  # 100GB
if [ $size -gt $threshold ]; then
  echo "Disk usage exceeds 100GB"
fi
```

## Resources

- [gdu Website](https://github.com/dundee/gdu)
- [gdu GitHub](https://github.com/dundee/gdu)
- [gdu Documentation](https://github.com/dundee/gdu#flags)
- [gdu Releases](https://github.com/dundee/gdu/releases)

---

**Last Updated**: 2025-03-14
