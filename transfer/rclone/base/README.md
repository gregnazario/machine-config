# Rclone - Sync Files to Cloud Storage

Rclone is a command-line program to sync files and directories to and from various cloud storage services.

## Features

### Core Features
- **Multiple Providers** - 70+ cloud storage providers
- **Sync** - Bidirectional synchronization
- **Crypt** - Encrypt data before uploading
- **Mount** - Mount remotes as filesystem
- **Serve** - Serve files over HTTP/WebDAV
- **Check** - Verify file integrity
- **Filters** - Include/exclude patterns
- **Bandwidth Limit** - Control transfer speed
- **Progress** - Real-time progress display
- **Dry Run** - Preview changes before executing

### Supported Providers
Amazon S3, Google Drive, Dropbox, OneDrive, Backblaze B2, Wasabi, Google Cloud Storage, Azure Blob, Mega, pCloud, WebDAV, FTP, SFTP, HTTP, and many more.

## Installation

### Prerequisites

```bash
# Install Rclone
# macOS
brew install rclone

# Fedora
sudo dnf install rclone

# Ubuntu
curl https://rclone.org/install.sh | sudo bash

# Arch
sudo pacman -S rclone

# Gentoo
sudo emerge net-misc/rclone

# Void
sudo xbps-install rclone

# Alpine
sudo apk add rclone

# FreeBSD
sudo pkg install rclone

# Windows (11)
# Download from GitHub releases
# Or use scoop:
scoop install rclone

# Go (any OS)
go install github.com/rclone/rclone@latest
```

### Setup

```bash
# Initialize configuration
rclone config

# List remotes
rclone listremotes

# Show config
rclone config show
```

## Usage

### Configuration

```bash
# Interactive configuration
rclone config

# Options:
# n) New remote
# s) Show configuration
# q) Quit config
# e/n/d/r) Edit, new, delete, rename remote
# l) List remotes
```

### Basic Operations

```bash
# List files
rclone ls remote:path
rclone lsl remote:path  # With sizes and times

# Copy files
rclone copy source remote:path

# Sync files (bidirectional)
rclone sync source remote:path

# Move files
rclone move source remote:path

# Delete files
rclone delete remote:path
rclone purge remote:path  # Delete all
```

### Sync

```bash
# Sync local to remote (make remote match local)
rclone sync ~/Documents remote:backup

# Sync remote to local (make local match remote)
rclone sync remote:backup ~/Documents

# Dry-run (preview changes)
rclone sync --dry-run ~/Documents remote:backup

# Sync with exclusions
rclone sync ~/Documents remote:backup \
  --exclude ".DS_Store" \
  --exclude "node_modules/"

# Sync from exclusion file
rclone sync ~/Documents remote:backup \
  --exclude-from exclude.txt
```

### Copy

```bash
# Copy single file
rclone copy file.txt remote:path/

# Copy directory
rclone copy ~/Photos remote:photos/

# Copy with progress
rclone copy ~/Documents remote:backup --progress

# Copy with bandwidth limit
rclone copy ~/Videos remote:videos --bwlimit 10M

# Copy specific files
rclone copy ~/Documents remote:backup \
  --include "*.pdf" \
  --include "*.doc*"
```

### Mount

```bash
# Mount remote as filesystem
rclone mount remote:path /mnt/remote

# Mount with specific options
rclone mount remote:path /mnt/remote \
  --vfs-mode cached \
  --allow-other

# Mount in background
rclone mount remote:path /mnt/remote --daemon

# Unmount
fusermount -u /mnt/remote  # Linux
umount /mnt/remote          # macOS/BSD
```

### Crypt (Encryption)

```bash
# Configure encrypted remote
rclone config
# New remote -> crypt
# Select underlying remote
# Set encryption parameters

# Use encrypted remote
rclone copy ~/secrets cryptremote:path

# Encrypt filename and content
# Choose encryption options:
# - Encrypt filenames
# - Encrypt content
# - Don't encrypt directory names
```

### Check

```bash
# Check files match
rclone check remote:path /local/path

# Check with hashes
rclone check --one-way remote:path /local/path

# Check and delete missing files
rclone check remote:path /local/path --missing-on-src delete
```

### Serve

```bash
# Serve files over HTTP
rclone serve http remote:path

# Serve on specific port
rclone serve http remote:path --addr 0.0.0.0:8080

# Serve with authentication
rclone serve http remote:path \
  --user user \
  --pass password

# Serve WebDAV
rclone serve webdav remote:path --addr 0.0.0.0:8080
```

### Filters

```bash
# Include/exclude patterns
rclone sync ~/Documents remote:backup \
  --exclude "*.tmp" \
  --include "*.pdf"

# Exclude from file
rclone sync ~/Documents remote:backup \
  --exclude-from exclude.txt

# Include from file
rclone sync ~/Documents remote:backup \
  --include-from include.txt

# Filter by size
rclone sync ~/Documents remote:backup \
  --max-size 100M \
  --min-size 1K

# Filter by age
rclone sync ~/Documents remote:backup \
  --max-age 30d \
  --min-age 7d
```

## Practical Examples

### Backup to S3

```bash
# Configure S3
rclone config
# New remote -> s3 -> Enter details

# Backup to S3
rclone sync ~/Documents s3:mybucket/backup \
  --exclude ".DS_Store" \
  --progress

# Schedule with cron
0 2 * * * rclone sync ~/Documents s3:mybucket/backup --quiet
```

### Backup to Google Drive

```bash
# Configure Google Drive
rclone config
# New remote -> drive -> OAuth

# Backup photos
rclone sync ~/Photos gdrive:Photos \
  --progress \
  --exclude ".DS_Store"

# Backup documents
rclone sync ~/Documents gdrive:Documents \
  --exclude "node_modules/" \
  --exclude ".git/"
```

### Sync Between Clouds

```bash
# Sync Dropbox to Google Drive
rclone sync dropbox:Documents gdrive:DropboxBackup

# Sync S3 to B2
rclone sync s3:mybucket b2:mybucket

# One-way sync (copy, don't delete)
rclone copy s3:source b2:dest
```

### Download from Cloud

```bash
# Download from S3
rclone copy s3:mybucket/file.txt ~/

# Download entire directory
rclone copy s3:mybucket ~/Downloads

# Download with filter
rclone copy gdrive:Photos ~/Pictures \
  --include "*.jpg" \
  --include "*.png"
```

### Mount Cloud Storage

```bash
# Mount Google Drive
rclone mount gdrive: ~/gdrive \
  --vfs-mode cached \
  --daemon

# Mount S3 bucket
rclone mount s3:mybucket ~/s3 \
  --vfs-mode cached \
  --daemon

# Mount encrypted remote
rclone mount cryptremote:path ~/secure \
  --daemon
```

### Automated Backup Script

```bash
#!/bin/bash
# ~/.local/bin/cloud-backup.sh

set -euo pipefail

# Backup documents
rclone sync ~/Documents gdrive:Documents \
  --exclude ".DS_Store" \
  --exclude "node_modules/" \
  --exclude ".git/" \
  --progress \
  --log-file=/var/log/rclone-backup.log

# Backup photos
rclone sync ~/Photos gdrive:Photos \
  --exclude ".DS_Store" \
  --progress \
  --log-file=/var/log/rclone-backup.log

echo "Backup completed: $(date)"
```

## Tips

### Security

```bash
# Use encrypted remotes for sensitive data
rclone config
# New remote -> crypt

# Set up two-factor authentication
# Use OAuth where possible

# Never commit rclone.conf
echo "rclone.conf" >> .gitignore
```

### Performance

```bash
# Increase transfers (default: 4)
rclone sync ~/Documents remote:backup \
  --transfers 8

# Increase checkers
rclone sync ~/Documents remote:backup \
  --checkers 16

# Use bandwidth limit
rclone sync ~/Documents remote:backup \
  --bwlimit 10M
```

### Automation

```bash
# Dry-run first
rclone sync --dry-run ~/Documents remote:backup

# Use in cron
0 2 * * * /usr/bin/rclone sync ~/Documents remote:backup --quiet

# Use with systemd
# /etc/systemd/system/rclone-backup.service
# /etc/systemd/system/rclone-backup.timer
```

### Monitoring

```bash
# Show progress
rclone sync ~/Documents remote:backup --progress

# Log to file
rclone sync ~/Documents remote:backup \
  --log-file=/var/log/rclone.log \
  --log-level INFO

# Stats at end
rclone sync ~/Documents remote:backup --stats 1s
```

## Aliases

Add to shell config:

```bash
# Rclone aliases
alias rc='rclone'                # Short alias
alias rcc='rclone copy'          # Copy
alias rcs='rclone sync'          # Sync
alias rcm='rclone mount'         # Mount
alias rccfg='rclone config'      # Config
alias rcls='rclone ls'           # List
alias rccheck='rclone check'     # Check
```

## Troubleshooting

### "Permission denied"

```bash
# Check remote permissions
rclone lsd remote:path

# Check configuration
rclone config show remote:

# Re-authenticate
rclone config reconnect remote:
```

### "Connection timeout"

```bash
# Increase timeout
rclone copy ~/file remote:path \
  --timeout 0  # No timeout

# Check network
ping remote.host
```

### "Out of memory"

```bash
# Reduce transfers
rclone sync ~/Documents remote:backup \
  --transfers 2 \
  --checkers 4

# Disable buffering
rclone sync ~/Documents remote:backup \
  --no-check-certificate
```

## Comparison

**Rclone:**
- 70+ providers
- Sync (bidirectional)
- Built-in encryption
- Mount support
- Filtering
- Bandwidth control

**rclone vs rdiff-backup:**
- rclone: Cloud-focused
- rdiff-backup: Local backup

**rclone vs Restic:**
- rclone: Cloud sync (no encryption by default)
- Restic: Backup (encryption by default)

**rclone vs rsync:**
- rclone: Cloud storage + local
- rsync: Local/SSH only
- Similar syntax

## Resources

- [Rclone Website](https://rclone.org/)
- [Rclone GitHub](https://github.com/rclone/rclone)
- [Rclone Documentation](https://rclone.org/docs/)
- [Rclone Filters](https://rclone.org/filtering/)
- [Rclone Crypt](https://rclone.org/crypt/)

---

**Last Updated**: 2025-03-14
