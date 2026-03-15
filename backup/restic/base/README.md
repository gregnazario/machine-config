# Restic - Modern Backup Tool

Restic is a modern backup program that can save data from many different kinds of storage and is easy to use.

## Features

### Core Features
- **Deduplication** - Only stores new data, saves space
- **Encryption** - AES-256 encryption by default
- **Multiple Backends** - S3, B2, Azure, local, SFTP, etc.
- **Snapshots** - Point-in-time backups
- **Incremental** - Only changes are stored
- **Compression** - Optional data compression
- **Cross-Platform** - Works on Linux, macOS, Windows, BSD
- **Fast** - Written in Go, very efficient
- **Checksums** - Data integrity verification
- **Mounting** - Mount snapshots as filesystem
- **Restore** - Easy restore to any point in time

### Advantages Over Traditional Tools
- Built-in encryption
- Deduplication saves space
- Multiple storage backends
- No server required
- Open source and audited
- Cross-platform

## Installation

### Prerequisites

```bash
# Install Restic
# macOS
brew install restic

# Fedora
sudo dnf install restic

# Ubuntu
sudo apt install restic

# Arch
sudo pacman -S restic

# Gentoo
sudo emerge app-backup/restic

# Void
sudo xbps-install restic

# Alpine
sudo apk add restic

# FreeBSD
sudo pkg install restic

# Windows (11)
# Download from GitHub releases
# scoop:
scoop install restic

# Go (any OS)
go install github.com/restic/restic/cmd/restic@latest
```

### Setup

```bash
# Initialize repository
restic init --repo /path/to/repo

# Or with environment variable
export RESTIC_REPOSITORY=/path/to/repo
restic init
```

## Usage

### Basic Backup

```bash
# Initialize repository (first time only)
restic init --repo /path/to/repo

# Backup directory
restic backup ~/Documents

# Backup with tag
restic backup ~/Documents --tag "documents"

# Backup multiple directories
restic backup ~/Documents ~/Pictures ~/Projects

# Backup with exclusion
restic backup ~/Projects --exclude "node_modules" --exclude ".git"

# Backup from exclusion file
restic backup ~/Projects --exclude-file .resticignore
```

### Repository Backends

```bash
# Local repository
restic -r /backup/repo backup ~/data

# SFTP repository
restic -r sftp:user@server:/backup/repo backup ~/data

# S3 repository
restic -r s3:s3.amazonaws.com/bucket_name backup ~/data

# Backblaze B2
restic -r b2:bucket_name:path backup ~/data

# Azure
restic -r azure:container_name:/path backup ~/data

# Google Cloud Storage
restic -r gs:bucket_name:/path backup ~/data

# REST server (rest-server)
restic -r rest:http://server:8000/repo backup ~/data
```

### Snapshots

```bash
# List all snapshots
restic snapshots

# List snapshots for specific host
restic snapshots --host myhostname

# List snapshots with specific tag
restic snapshots --tag documents

# Show snapshot details
restic snapshots <snapshot-id>

# List snapshots in JSON
restic snapshots --json
```

### Restore

```bash
# Restore latest snapshot
restic restore latest --target ~/restore

# Restore specific snapshot
restic restore <snapshot-id> --target ~/restore

# Restore specific directory
restic restore latest --target ~/restore --path "/Documents"

# Restore to original location
restic restore latest --target /

# Dry-run (preview)
restic restore latest --target ~/restore --dry-run
```

### Mounting

```bash
# Mount snapshots as filesystem
restic mount /mnt/restic

# Browse snapshots
ls /mnt/restic/snapshots/
cd /mnt/restic/snapshots/latest/

# Unmount
# Press Ctrl+C or use:
fusermount -u /mnt/restic  # Linux
umount /mnt/restic          # macOS/BSD
```

### Forget (Cleanup)

```bash
# Show what would be deleted
restic forget --dry-run --keep-daily 7 --keep-weekly 4 --keep-monthly 6

# Keep policy:
# - 7 daily snapshots
# - 4 weekly snapshots
# - 6 monthly snapshots
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6

# Keep last 10 snapshots
restic forget --keep-last 10

# Keep snapshots by time
restic forget --keep-within 30d

# Remove snapshots by host
restic forget --host old-hostname

# Remove snapshots by tag
restic forget --tag old-tag
```

### Prune

```bash
# Reclaim space (after forget)
restic prune

# Optimized prune (faster, restic 0.12+)
restic prune --max-unused 50%

# Dry-run
restic prune --dry-run
```

### Check

```bash
# Check repository integrity
restic check

# Check with full data read (slower, thorough)
restic check --read-data

# Check specific snapshots
restic check --read-data-subset=5%  # Check 5% of data
```

### Stats

```bash
# Repository statistics
restic stats

# Stats for specific snapshot
restic stats <snapshot-id>

# Count mode (faster)
restic stats --mode count-raw
```

## Environment Variables

```bash
# Repository location
export RESTIC_REPOSITORY=/path/to/repo

# Repository password
export RESTIC_PASSWORD=mypassword
# Or use file:
export RESTIC_PASSWORD_FILE=/path/to/password-file

# Backup options
export RESTIC_COMPRESSION=auto  # auto, max, off
export RESTIC_PACK_SIZE=16MiB
```

## Configuration Files

### Environment Variables File

```bash
# ~/.config/restic/env
# or /etc/restic/env

export RESTIC_REPOSITORY=/backup/restic
export RESTIC_PASSWORD_FILE=~/.config/restic/password

# AWS S3
export AWS_ACCESS_KEY_ID=your_key
export AWS_SECRET_ACCESS_KEY=your_secret
export AWS_DEFAULT_REGION=us-east-1

# Backblaze B2
export B2_ACCOUNT_ID=account_id
export B2_ACCOUNT_KEY=secret_key

# For SFTP
export RESTIC_REPOSITORY=sftp:user@server:/backup/repo
```

### Exclusion File

```bash
# .resticignore
# Similar to .gitignore

node_modules/
*.log
*.tmp
.cache/
.DS_Store
.vscode/
.idea/
*.pyc
__pycache__/
target/
build/
dist/
```

## Practical Examples

### Daily Backup Script

```bash
#!/bin/bash
# ~/.local/bin/daily-backup.sh

set -euo pipefail

# Source environment
source ~/.config/restic/env

# Backup directories
restic backup ~/Documents ~/Pictures ~/Projects \
  --exclude "node_modules" \
  --exclude ".git" \
  --tag "daily"

# Keep 7 daily, 4 weekly, 6 monthly
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6

# Prune unused data
restic prune

# Check repository (weekly)
# restic check

echo "Backup completed: $(date)"
```

### Automated Backup with Cron

```bash
# Daily backup at 2 AM
0 2 * * * ~/.local/bin/daily-backup.sh >> /var/log/restic-backup.log 2>&1

# Weekly check (Sundays at 3 AM)
0 3 * * 0 /usr/bin/restic check >> /var/log/restic-check.log 2>&1
```

### Backup to S3

```bash
# ~/.config/restic/s3-env
export RESTIC_REPOSITORY=s3:s3.amazonaws.com/my-backup-bucket/restic
export RESTIC_PASSWORD_FILE=~/.config/restic/password
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

# Backup
source ~/.config/restic/s3-env
restic backup ~/Documents
```

### Backup to B2

```bash
# ~/.config/restic/b2-env
export RESTIC_REPOSITORY=b2:my-bucket:restic
export RESTIC_PASSWORD_FILE=~/.config/restic/password
export B2_ACCOUNT_ID=account_id
export B2_ACCOUNT_KEY=secret_key

# Backup
source ~/.config/restic/b2-env
restic backup ~/Documents
```

### Restore Specific Files

```bash
# List files in snapshot
restic ls latest

# Restore specific file
restic restore latest --target ~/restore --path "/Documents/file.txt"

# Find file in snapshots
restic find file.txt

# Restore to stdout
restic dump latest Documents/file.txt > file.txt
```

### Mount and Browse

```bash
# Mount snapshots
mkdir -p ~/mnt/restic
restic mount ~/mnt/restic

# In another terminal, browse:
cd ~/mnt/restic/snapshots/latest/Documents/
ls -la

# Copy file
cp important.txt ~/restore/

# Unmount
fusermount -u ~/mnt/restic
```

## Tips

### Security

```bash
# Always use password files (not environment variables)
echo "mypassword" > ~/.config/restic/password
chmod 600 ~/.config/restic/password

# Don't commit password files
echo "restic/password" >> .gitignore

# Use RESTIC_PASSWORD_FILE
export RESTIC_PASSWORD_FILE=~/.config/restic/password
```

### Performance

```bash
# Adjust pack size for large files
export RESTIC_PACK_SIZE=32MiB

# Disable compression for already compressed data
restic backup --compression off ~/Videos

# Use read-data-subset for checking
restic check --read-data-subset=10%
```

### Storage

```bash
# Use tags to organize backups
restic backup ~/Documents --tag "documents"
restic backup ~/Projects --tag "projects"

# List by tag
restic snapshots --tag documents

# Use exclusion files
restic backup --exclude-file .resticignore ~/Projects
```

### Automation

```bash
# Use systemd timers (Linux)
# /etc/systemd/system/restic-backup.service
# /etc/systemd/system/restic-backup.timer

# Use launchd (macOS)
# ~/Library/LaunchAgents/com.restic.backup.plist

# Use cron (universal)
# Add to crontab
```

## Aliases

Add to shell config:

```bash
# Restic aliases
alias restic-backup='restic backup'
alias restic-snapshots='restic snapshots'
alias restic-restore='restic restore latest'
alias restic-mount='restic mount'
alias restic-forget='restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6'
alias restic-prune='restic prune'
alias restic-check='restic check'
```

## Troubleshooting

### "repository master key and config already initialized"

```bash
# Repository already exists
# Don't run restic init again

# Just backup
restic backup ~/data
```

### "wrong password"

```bash
# Check password file
cat ~/.config/restic/password

# Reset password
# Unfortunately, you can't reset password
# Must remember original password
```

### "backend not supported"

```bash
# Install required dependencies
# For S3: AWS CLI or credentials
# For B2: B2 command line tool
# For SFTP: ssh client
```

### "lock timeout"

```bash
# Remove stale locks
restic unlock

# Check for other processes
ps aux | grep restic
```

## Comparison

**Restic:**
- Go-based
- Built-in encryption
- Deduplication
- Multiple backends
- Cross-platform
- CLI-only

**Borg:**
- Python-based
- Compression
- Deduplication
- Server required
- Compression options
- More mature

**Duplicati:**
- Web UI
- Built-in scheduler
- Encrypted
- More user-friendly
- Slower

**Rclone:**
- Sync tool (not backup)
- No snapshots
- No deduplication
- Cloud-focused

## Advanced Usage

### Tagging Strategy

```bash
# Backup with multiple tags
restic backup ~/Documents --tag "daily" --tag "documents" --tag "work"

# Forget by tag
restic forget --tag "old-project"
```

### Backup Script with Logging

```bash
#!/bin/bash
LOG_FILE="/var/log/restic-backup.log"

{
  echo "Starting backup at $(date)"

  source ~/.config/restic/env
  restic backup ~/Documents ~/Pictures ~/Projects \
    --exclude "node_modules" \
    --tag "daily"

  restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6
  restic prune

  echo "Backup completed at $(date)"
} >> "$LOG_FILE" 2>&1
```

### Multiple Repositories

```bash
# Local backup
restic -r /backup/local backup ~/data

# Remote backup
restic -r s3:s3.amazonaws.com/bucket backup ~/data

# Use environment file per repository
source ~/.config/restic/local-env
restic backup ~/data

source ~/.config/restic/s3-env
restic backup ~/data
```

## Resources

- [Restic Website](https://restic.net/)
- [Restic GitHub](https://github.com/restic/restic)
- [Restic Documentation](https://restic.readthedocs.io/)
- [Restic Tutorial](https://restic.readthedocs.io/en/stable/020_installation.html)

---

**Last Updated**: 2025-03-14
