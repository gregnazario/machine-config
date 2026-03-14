# Zstandard (zstd) Compression

Zstandard (zstd) is a fast lossless compression algorithm with real-time compression speed and better compression ratio.

## Features

### Core Features
- **Fast Compression** - Real-time compression speed
- **High Compression Ratio** - Better than gzip
- **Fast Decompression** - Extremely fast decompression
- **Adaptive** - Adjusts compression level dynamically
- **Dictionary Compression** - Improve compression with trained dictionaries
- **Streaming** - Stream compression and decompression
- **Multi-threaded** - Parallel compression
- **Checksums** - Data integrity verification

### Compression Levels
- **1-3** - Fastest (real-time)
- **4-9** - Good balance
- **10-18** - High compression
- **19-22** - Maximum compression (slowest)

## Installation

### Prerequisites

```bash
# Install zstd
# macOS
brew install zstd

# Fedora
sudo dnf install zstd

# Ubuntu
sudo apt install zstd

# Arch
sudo pacman -S zstd

# Gentoo
sudo emerge app-arch/zstd

# Void
sudo xbps-install zstd

# Alpine
sudo apk add zstd

# FreeBSD
sudo pkg install zstd

# Windows (11)
winget install gilles.zstandard
# Or use scoop:
scoop install zstd
```

### Setup

```bash
# No configuration needed
zstd is ready to use after installation

# Create symlinks for gzip compatibility (optional)
ln -s /usr/bin/zstd ~/.local/bin/gzip
ln -s /usr/bin/zstd ~/.local/bin/gunzip
```

## Usage

### Basic Compression

```bash
# Compress file
zstd file.txt

# Output to specific file
zstd -o file.txt.zst file.txt

# Keep original file
zstd -k file.txt

# Compress to stdout
zstd -c file.txt > file.txt.zst

# Force overwrite
zstd -f file.txt

# Multiple files
zstd file1.txt file2.txt file3.txt

# All files in directory
zstd *.txt

# Recursive directory
zstd -r directory/
```

### Decompression

```bash
# Decompress file
zstd -d file.txt.zst

# Output to specific file
zstd -d -o file.txt file.txt.zst

# Decompress to stdout
zstd -dc file.txt.zst > file.txt

# Keep compressed file
zstd -dk file.txt.zst

# Force overwrite
zstd -df file.txt.zst

# Multiple files
zstd -d *.zst

# Test archive (don't decompress)
zstd -t file.txt.zst
```

### Compression Levels

```bash
# Fastest compression (level 1)
zstd -1 file.txt

# Fast compression (level 3)
zstd -3 file.txt

# Default compression (level 3)
zstd file.txt

# Good compression (level 9)
zstd -9 file.txt

# High compression (level 15)
zstd -15 file.txt

# Maximum compression (level 19)
zstd -19 file.txt

# Ultra compression (level 22, very slow)
zstd -22 --ultra file.txt

# Custom level (1-22)
zstd -10 file.txt
```

### Multi-threading

```bash
# Use all cores
zstd -T0 file.txt

# Use specific number of threads
zstd -T4 file.txt

# Auto-detect threads
zstd file.txt  # Default: uses available threads

# Single-threaded
zstd -T1 file.txt
```

### File Operations

```bash
# Compress and remove original
zstd --rm file.txt

# Same as (default)
zstd file.txt

# Keep original
zstd -k file.txt

# Write to file
zstd -o output.zst input.txt

# Read from file
zstd -o file.txt.zst input.txt

# Recursive directory compression
zstd -r directory/

# Recursive with pattern
zstd -r directory/ -d "*.log"
```

### Advanced Options

```bash
# Adaptive compression (adjusts level based on data)
zstd --adapt file.txt

# Dictionary compression
zstd -D dictionary.zst file.txt

# Train dictionary
zstd --train *.txt -o dictionary.zst

# Add checksum
zstd --check file.txt

# No progress indicator
zstd -q file.txt

# Show compression ratio
zstd -v file.txt

# Show file information
zstd -lv file.txt.zst

# Test archive integrity
zstd -t file.txt.zst

# List archive contents
zstd -l file.txt.zst
```

### Stream Processing

```bash
# Compress stdout to file
echo "hello" | zstd > output.zst

# Decompress to stdout
zstd -dc output.zst

# Pipe to decompression
cat file.txt.zst | zstd -d | less

# Compress tar output
tar cf - directory/ | zstd > directory.tar.zst

# Decompress tar.zst
zstd -dc directory.tar.zst | tar xf -

# Network transfer
tar cf - directory/ | zstd | ssh server "zstd -d | tar xf -"
```

### File Info

```bash
# List compressed file info
zstd -l file.txt.zst

# Verbose info
zstd -lv file.txt.zst

# Detailed info
zstd -lv -- file.txt.zst

# Shows:
# - Compression ratio
# - File size (compressed/uncompressed)
# - Compression level used
# - Checksum
```

## Practical Examples

### Backup

```bash
# Compress backup
tar cf - /home/user | zstd -19 > backup.tar.zst

# Compress with date
tar cf - /home/user | zstd -19 > "backup-$(date +%Y%m%d).tar.zst"

# Compress directory
zstd -r -19 --rm backup/

# Incremental backup
tar cf - /home/user | zstd -3 > incremental.tar.zst
```

### Log Files

```bash
# Compress logs (fast)
zstd -3 *.log --rm

# Compress with date
zstd -3 application.log -o "application-$(date +%Y%m%d).log.zst"

# Rotate logs
mv app.log app-$(date +%Y%m%d).log
zstd -3 app-$(date +%Y%m%d).log --rm

# Decompress log for viewing
zstd -dc app-20250314.log.zst | less

# Search compressed logs
zstd -dc app-20250314.log.zst | grep "ERROR"
```

### Database Dumps

```bash
# Compress database dump
pg_dump database | zstd -15 > database.sql.zst

# Compress mysqldump
mysqldump database | zstd -15 > database.sql.zst

# Decompress and restore
zstd -dc database.sql.zst | psql database

# Compress all databases
pg_dumpall | zstd -15 > all_databases.sql.zst
```

### File Transfer

```bash
# Compress before transfer
tar cf - directory/ | zstd -3 | nc receiver 1234

# Receive and decompress
nc -l 1234 | zstd -d | tar xf -

# SSH transfer
tar cf - directory/ | zstd -3 | ssh server "zstd -d | tar xf -"

# Compressed SCP (use rsync with zstd)
rsync -avz --rsync-path="zstd -d | rsync" file.txt.zst server:/path/
```

### Database Backups

```bash
# Fast backup (low compression)
pg_dump database | zstd -3 > backup.sql.zst

# High compression (archive)
pg_dump database | zstd -19 > backup.sql.zst

# Restore from backup
zstd -dc backup.sql.zst | psql database

# Backup with encryption
pg_dump database | zstd -15 | gpg -e > backup.sql.zst.gpg
```

## Aliases

Add to shell config:

```bash
# Compression aliases
alias zstd1='zstd -1'         # Fastest
alias zstd3='zstd -3'         # Fast
alias zstd9='zstd -9'         # Good
alias zstd15='zstd -15'       # High
alias zstd19='zstd -19'       # Ultra

# Decompression
alias uzstd='zstd -d'

# Tar with zstd
alias tzstd='tar caf'         # Create tar.zst
alias utzstd='tar xaf'        # Extract tar.zst

# Quick compress
alias zc='zstd -3 --rm'

# Quick decompress
alias zd='zstd -d --rm'
```

## Tips

### Best Compression Settings

```bash
# Real-time (fastest, good ratio)
zstd -3 file.txt

# Archive (slow, best ratio)
zstd -19 file.txt

# Backup (medium speed, good ratio)
zstd -9 file.txt

# Network (fast compression, fast transfer)
zstd -1 file.txt
```

### Memory Usage

```bash
# Low memory (limited RAM)
zstd -10 --memory=32M file.txt

# High memory (better compression)
zstd -19 --memory=256M file.txt

# Decompress with limited memory
zstd -d --memory=32M file.txt.zst
```

### Progress Monitoring

```bash
# Show progress
zstd -v file.txt

# Progress for large files
pv file.txt | zstd > file.txt.zst

# Show compression ratio
zstd -lv file.txt.zst
```

### Compression Dictionary

```bash
# Train dictionary for similar files
zstd --train file1.txt file2.txt file3.txt -o dictionary.zst

# Compress with dictionary
zstd -D dictionary.zst file.txt -o file.txt.zst

# Better compression for similar files
# Good for logs, database dumps, etc.
```

## Comparison

**zstd:**
- Best balance of speed and ratio
- Real-time compression possible
- Fast decompression
- Modern algorithms
- Multi-threaded by default

**gzip:**
- Slower compression
- Good compatibility
- Lower compression ratio
- Single-threaded
- Universally available

**bzip2:**
- Slower compression
- Better ratio than gzip
- Slower decompression
- Older algorithm
- Less features

**xz:**
- Slowest compression
- Best compression ratio
- Fast decompression
- Higher memory usage
- Good for archives

**pigz:**
- Parallel gzip
- Compatible with gzip
- Faster compression
- Same ratio as gzip

## Performance

### Compression Speed (fastest to slowest)
1. zstd -1 (real-time)
2. zstd -3
3. pigz
4. gzip
5. zstd -9
6. bzip2
7. zstd -15
8. xz
9. zstd -19 (slowest)

### Compression Ratio (worst to best)
1. gzip
2. pigz (same as gzip)
3. zstd -1
4. zstd -3
5. bzip2
6. zstd -9
7. zstd -15
8. xz
9. zstd -19 (best)

## Troubleshooting

### "Cannot write to output"

```bash
# Check disk space
df -h

# Use -f to force
zstd -f file.txt

# Check permissions
ls -la file.txt
```

### "Memory allocation failed"

```bash
# Reduce memory usage
zstd -10 --memory=32M file.txt

# Or use lower compression level
zstd -3 file.txt
```

### "Corrupted compressed file"

```bash
# Test archive
zstd -t file.txt.zst

# Check checksum
zstd -lv file.txt.zst

# Try partial recovery
zstd -d --keep file.txt.zst
```

## Resources

- [Zstandard GitHub](https://github.com/facebook/zstd)
- [Zstandard Website](https://facebook.github.io/zstd/)
- [Zstandard Documentation](https://github.com/facebook/zstd/blob/dev/README.md)

---

**Last Updated**: 2025-03-14
