# pigz (Parallel Implementation of GZip)

pigz is a parallel implementation of gzip that compresses files using multiple cores.

## Features

### Core Features
- **Multi-threaded** - Use all CPU cores for compression
- **GZIP Compatible** - Creates standard gzip files
- **Fast Compression** - Significantly faster than gzip
- **Same Compression Ratio** - Identical to gzip
- **Decompression** - Compatible with gzip for decompression
- **Cross-platform** - Works on Linux, macOS, Windows

### Advantages over gzip
- Uses all CPU cores (gzip is single-threaded)
- Much faster compression on multi-core systems
- Creates standard gzip files (fully compatible)
- Can be used as drop-in replacement

## Installation

### Prerequisites

```bash
# Install pigz
# macOS
brew install pigz

# Fedora
sudo dnf install pigz

# Ubuntu
sudo apt install pigz

# Arch
sudo pacman -S pigz

# Gentoo
sudo emerge app-arch/pigz

# Void
sudo xbps-install pigz

# Alpine
sudo apk add pigz

# FreeBSD
sudo pkg install pigz

# Windows (11)
# Download from: https://zlib.net/pigz/
# Or use WSL on Windows
```

### Setup

```bash
# No configuration needed
pigz is ready to use after installation

# Create alias to replace gzip (optional)
alias gzip=pigz
alias gunzip=pigz
```

## Usage

### Basic Compression

```bash
# Compress file (replaces original with .gz)
pigz file.txt

# Keep original file
pigz -k file.txt

# Compress to stdout
pigz -c file.txt > file.txt.gz

# Force overwrite
pigz -f file.txt

# Compress multiple files
pigz file1.txt file2.txt file3.txt

# Compress all files
pigz *.txt

# Recursive directory
pigz -r directory/

# Show compression ratio
pigz -v file.txt
```

### Decompression

```bash
# Decompress file
pigz -d file.txt.gz

# Keep compressed file
pigz -dk file.txt.gz

# Decompress to stdout
pigz -dc file.txt.gz > file.txt

# Force overwrite
pigz -df file.txt.gz

# Decompress multiple files
pigz -d *.gz

# Test archive (don't decompress)
pigz -t file.txt.gz

# Decompress with gzip (pigz creates standard gzip)
gzip -d file.txt.gz
gunzip file.txt.gz
```

### Compression Levels

```bash
# Fastest compression (level 1)
pigz -1 file.txt

# Fast compression (level 3)
pigz -3 file.txt

# Default compression (level 6)
pigz file.txt

# Best compression (level 9)
pigz -9 file.txt

# Custom level (0-9)
pigz -5 file.txt

# Level 0 = no compression (just store)
pigz -0 file.txt
```

### Multi-threading

```bash
# Use all CPU cores (default)
pigz file.txt

# Use specific number of processes
pigz -p4 file.txt

# Use 8 processes
pigz -p8 file.txt

# Single-threaded (like gzip)
pigz -p1 file.txt

# Auto-detect (default)
pigz file.txt
```

### File Operations

```bash
# Write to specific file
pigz -c file.txt > output.gz

# Read from file
pigz -d -c file.txt.gz > file.txt

# Compress and remove original (default)
pigz file.txt

# Keep original
pigz -k file.txt

# Recursive directory compression
pigz -r directory/

# Recursive with pattern
pigz -r directory/ -e "*.log"

# Don't recurse into symlinks
pigz -r --no-symlinks directory/
```

### Advanced Options

```bash
# Compress tar output (fast!)
tar cf - directory/ | pigz > directory.tar.gz

# Better compression with tar
tar cf - directory/ | pigz -9 > directory.tar.gz

# Decompress tar.gz
pigz -dc directory.tar.gz | tar xf -

# Test archive integrity
pigz -t file.txt.gz

# List files (like gzip -l)
pigz -l file.txt.gz

# Verbose output
pigz -v file.txt

# Quiet mode
pigz -q file.txt

# Process file list
pigz -f files.txt
```

### Stream Processing

```bash
# Compress stdout
echo "hello" | pigz > output.gz

# Decompress to stdout
pigz -dc output.gz

# Pipe commands
cat file.txt | pigz > file.txt.gz

# Network transfer
tar cf - directory/ | pigz | nc receiver 1234

# Receive and decompress
nc -l 1234 | pigz -d | tar xf -

# SSH transfer
tar cf - directory/ | pigz | ssh server "pigz -d | tar xf -"
```

## Practical Examples

### Backup

```bash
# Compress backup (fast!)
tar cf - /home/user | pigz > backup.tar.gz

# Compress with better compression
tar cf - /home/user | pigz -9 > backup.tar.gz

# Compress directory
pigz -r backup/

# Backup with date
tar cf - /home/user | pigz > "backup-$(date +%Y%m%d).tar.gz"

# Incremental backup
tar cf - /home/user | pigz -3 > incremental.tar.gz
```

### Log Files

```bash
# Compress logs (fast)
pigz *.log

# Compress and keep original
pigz -k application.log

# Compress with date
pigz application.log -o "application-$(date +%Y%m%d).log.gz"

# Rotate logs
mv app.log app-$(date +%Y%m%d).log
pigz app-$(date +%Y%m%d).log --rm

# Decompress log for viewing
pigz -dc app-20250314.log.gz | less

# Search compressed logs
pigz -dc app-20250314.log.gz | grep "ERROR"

# Monitor log while decompressing
pigz -dc app.log.gz | tail -f
```

### Database Dumps

```bash
# Compress database dump (fast!)
pg_dump database | pigz > database.sql.gz

# Compress with better compression
pg_dump database | pigz -9 > database.sql.gz

# Compress mysqldump
mysqldump database | pigz > database.sql.gz

# Decompress and restore
pigz -dc database.sql.gz | psql database

# Compress all databases
pg_dumpall | pigz > all_databases.sql.gz

# Compress with encryption
pg_dump database | pigz | gpg -e > database.sql.gz.gpg
```

### File Transfer

```bash
# Compress before transfer
tar cf - directory/ | pigz | nc receiver 1234

# Receive and decompress
nc -l 1234 | pigz -d | tar xf -

# SSH transfer (faster with pigz!)
tar cf - directory/ | pigz | ssh server "pigz -d | tar xf -"

# Compress file for SCP
pigz largefile.txt
scp largefile.txt.gz server:/path/

# Compress directory for transfer
tar cf - directory/ | pigz > directory.tar.gz
```

### Web Server

```bash
# Compress web assets
pigz -k *.css *.js *.html

# Pre-compress for nginx
pigz -r -k /var/www/html/

# Create .gz versions for web
find /var/www/html -name "*.html" -exec pigz -k {} \;
```

## Aliases

Add to shell config:

```bash
# Replace gzip with pigz
alias gzip=pigz
alias gunzip='pigz -d'

# Compression aliases
alias pigz1='pigz -1'         # Fastest
alias pigz3='pigz -3'         # Fast
alias pigz6='pigz -6'         # Default
alias pigz9='pigz -9'         # Best

# Decompression
alias unpigz='pigz -d'

# Tar with pigz
alias tpigz='tar cf - | pigz'       # Create
alias utpigz='pigz -dc | tar xf -'  # Extract

# Quick compress
alias pzc='pigz -3'
alias pzd='pigz -d'
```

## Tips

### When to Use pigz vs gzip

```bash
# Use pigz for compression (faster)
pigz file.txt

# Decompression: use either
pigz -d file.txt.gz  # Faster on multi-core
gzip -d file.txt.gz  # Slower, single-threaded

# For maximum compatibility with decompression:
# Use pigz for compression, gunzip for decompression
pigz file.txt
gunzip file.txt.gz
```

### Best Compression Settings

```bash
# Fastest compression (level 1)
pigz -1 file.txt

# Good balance (level 6, default)
pigz file.txt

# Best compression (level 9, slowest)
pigz -9 file.txt

# For backup/archives (level 9)
tar cf - directory/ | pigz -9 > backup.tar.gz

# For logs (level 6, default)
pigz -k *.log
```

### Process Control

```bash
# Use all cores
pigz file.txt

# Use specific number of cores
pigz -p4 file.txt

# Leave one core free
pigz -p$(($(nproc)-1)) file.txt

# Use half of cores
pigz -p$(($(nproc)/2)) file.txt
```

### Recursive Compression

```bash
# Compress directory recursively
pigz -r directory/

# Keep original files
pigz -r -k directory/

# Only compress specific files
pigz -r directory/ -e "*.log"

# Don't follow symlinks
pigz -r --no-symlinks directory/
```

### Monitoring Progress

```bash
# Show compression ratio
pigz -v file.txt

# Use pv for progress bar
pv file.txt | pigz > file.txt.gz

# Multiple files with progress
for f in *.txt; do
  echo "Compressing $f"
  pigz "$f"
done
```

## Performance

### Speed Comparison (on same file)
- **pigz -p8**: ~2.5x faster than gzip
- **pigz -p4**: ~1.8x faster than gzip
- **pigz -p2**: ~1.3x faster than gzip
- **pigz -p1**: ~same as gzip (single-threaded)

### Compression Ratio
- **pigz** vs **gzip**: Identical (same algorithm)
- Level 1: Fastest, lowest ratio
- Level 6: Default, good balance
- Level 9: Slowest, best ratio

### When to Use pigz
- Large files (>100MB)
- Multiple files
- Multi-core systems
- Backup operations
- Log rotation
- File transfers

### When to Use gzip Instead
- Single-core systems
- Maximum compatibility needed
- Very small files (<1MB)
- Systems without pigz

## Comparison

**pigz:**
- Multi-threaded compression
- Creates standard gzip files
- Much faster on multi-core
- Same compression ratio
- Drop-in replacement

**gzip:**
- Single-threaded
- Universally available
- Slower compression
- Same compression ratio
- More compatible

**xz:**
- Better compression ratio
- Slower compression
- Single-threaded (mostly)
- Not gzip-compatible

**zstd:**
- Better compression ratio
- Faster compression (multi-threaded)
- Not gzip-compatible
- Modern algorithm

**bzip2:**
- Better compression ratio
- Slower compression
- Single-threaded
- Not gzip-compatible

## Integration

### With tar

```bash
# Fast tar.gz creation
tar cf - directory/ | pigz > directory.tar.gz

# Decompress tar.gz
pigz -dc directory.tar.gz | tar xf -

# Single command (if tar supports --use-compress-program)
tar --use-compress-program=pigz -cf archive.tar.gz directory/
```

### With find

```bash
# Find and compress
find /logs -name "*.log" -exec pigz {} \;

# Find and compress with confirmation
find /logs -name "*.log" -exec pigz -k {} \;

# Find old logs and compress
find /logs -name "*.log" -mtime +7 -exec pigz {} \;
```

### With rsync

```bash
# Compress before rsync (for slow networks)
tar cf - directory/ | pigz | rsync -av server:/path/

# Or use rsync's compression (less efficient)
rsync -avz directory/ server:/path/
```

## Troubleshooting

### "pigz: command not found"

```bash
# Install pigz
# Ubuntu/Debian
sudo apt install pigz

# Fedora/RHEL
sudo dnf install pigz

# Arch
sudo pacman -S pigz

# macOS
brew install pigz
```

### "Cannot write to output"

```bash
# Check disk space
df -h

# Use -k to keep original
pigz -k file.txt

# Check permissions
ls -la file.txt
```

### Compression slower than expected

```bash
# Check number of processes
pigz -p$(nproc) file.txt

# Use faster compression level
pigz -1 file.txt

# Verify using multiple cores
top -p $(pgrep pigz)
```

### Compatibility Issues

```bash
# pigz creates standard gzip files
# Can be decompressed with:
gzip -d file.txt.gz
gunzip file.txt.gz
pigz -d file.txt.gz

# All produce same result
```

## Resources

- [pigz Website](https://zlib.net/pigz/)
- [pigz Documentation](https://zlib.net/pigz/pigz.pdf)
- [pigz GitHub (mirror)](https://github.com/madler/pigz)

---

**Last Updated**: 2025-03-14
