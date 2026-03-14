# 7-Zip (7z) Archiver

7-Zip is a file archiver with high compression ratio. Supports multiple formats.

## Features

### Supported Formats
- **7z** - Native format with highest compression
- **ZIP** - Most common format
- **TAR** - Unix tape archive
- **GZIP** - GNU zip
- **BZIP2** - Block sorting file compressor
- **XZ** - LZMA-based compression
- **WIM** - Windows Imaging format
- **RAR** - Read-only (version 5)

### Compression Formats
- LZMA, LZMA2, PPMd, BZip2, DEFLATE, COPY

### Encryption
- **AES-256** - Strong encryption for 7z and ZIP

## Installation

### Prerequisites

```bash
# Install 7-Zip
# macOS
brew install p7zip

# Fedora
sudo dnf install p7zip p7zip-plugins

# Ubuntu
sudo apt install p7zip-full p7zip

# Arch
sudo pacman -S p7zip

# Gentoo
sudo emerge app-arch/p7zip

# Void
sudo xbps-install p7zip

# Alpine
sudo apk add p7zip

# FreeBSD
sudo pkg install archivers/p7zip

# Windows (11)
# Download from: https://www.7-zip.org/
# Or use winget:
winget install 7zip.7zip
```

### Setup

```bash
# No configuration needed for basic usage

# Create symlinks for better UX (optional)
ln -s /usr/bin/7zz ~/.local/bin/7z
ln -s /usr/bin/7zz ~/.local/bin/7za
```

## Usage

### Archive Operations

```bash
# Create archive (7z format)
7z a archive.7z file1 file2 dir/

# Create ZIP archive
7z a archive.zip file1 file2 dir/

# Create archive with compression level
7z a -t7z -m0=lzma2 -mx=9 archive.7z file1 file2

# Compression levels: 0 (none) to 9 (ultra)

# Create archive with password
7z a -p archive.7z file1 file2
# Enter password (will prompt)

# Create archive with password (inline - insecure!)
7z a -p<password> archive.7z file1 file2

# Create archive with encryption
7z a -p -mhe=on archive.7z file1 file2
# -mhe=on encrypts headers (filenames too)

# Create solid archive (better compression)
7z a -ms=on archive.7z dir/

# Create multi-volume archive
7z a -v100m archive.7z largefile
# Creates 100MB volumes

# Create archive excluding files
7z a archive.7z dir/ -x!*.log -x!*.tmp

# Update existing archive
7z u archive.7z newfile

# Delete files from archive
7z d archive.7z unwanted_file
```

### Extract Operations

```bash
# Extract archive
7z x archive.7z

# Extract to specific directory
7z x archive.7z -odestination/

# Extract without directory structure (flat)
7z e archive.7z

# Extract with password
7z x archive.7z -p

# Extract specific files
7z x archive.7z file1 file2

# Extract to stdout
7z x archive.7z -so file1 > file1

# Overwrite existing files
7z x archive.7z -y

# Keep existing files (don't overwrite)
7z x archive.7z -aos
```

### List Archive

```bash
# List archive contents
7z l archive.7z

# List with technical info
7z l -slt archive.7z

# List specific files
7z l archive.7z file1

# List archive headers only
7z l archive.7z -slt -p
```

### Test Archive

```bash
# Test archive integrity
7z t archive.7z

# Test with password
7z t archive.7z -p
```

### Update Archive

```bash
# Add files to archive
7z u archive.7z newfile

# Update files in archive
7z u archive.7z -up1q0r2x2y2z0w1a1

# Freshen files (update existing)
7z u archive.7z -u fresh files

# Synchronize archive with files
7z u archive.7z -u -up0q1r2x2y2z0w1a1
```

### Benchmark

```bash
# Benchmark compression
7z b

# Benchmark with specific method
7z b -m0=lzma2

# Benchmark with specific threads
7z b -mmt4
```

## Compression Methods

### LZMA2 (Recommended)
```bash
# Default for 7z format
7z a -t7z -m0=lzma2 archive.7z file

# With dictionary size
7z a -t7z -m0=lzma2 -md=32m archive.7z file

# With word size
7z a -t7z -m0=lzma2 -mf=bcj archive.7z file
```

### Copy (No Compression)
```bash
# Store files without compression
7z a -t7z -m0=copy archive.7z file
```

### Deflate (ZIP)
```bash
# Create ZIP with Deflate
7z a -tzip -m0=deflate archive.zip file
```

### BZip2
```bash
# Create archive with BZip2
7z a -t7z -m0=bzip2 archive.7z file
```

## Options

### Compression Level
```bash
# 0 - Copy (no compression)
7z a -mx=0 archive.7z file

# 1 - Fastest
7z a -mx=1 archive.7z file

# 3 - Fast
7z a -mx=3 archive.7z file

# 5 - Normal (default)
7z a -mx=5 archive.7z file

# 7 - Maximum
7z a -mx=7 archive.7z file

# 9 - Ultra (slowest, best compression)
7z a -mx=9 archive.7z file
```

### Dictionary Size
```bash
# Dictionary size affects compression ratio and memory
# 64KB to 4GB for LZMA2

7z a -t7z -md=64m archive.7z file
```

### Word Size
```bash
# Word size for LZMA
# Usually 4-273 bytes

7z a -t7z -mf=bcj archive.7z file
```

### Multi-threading
```bash
# Use multiple threads
7z a -mmt4 archive.7z file

# Use all threads
7z a -mmt archive.7z file
```

### Solid Mode
```bash
# Solid mode improves compression for similar files
# But makes updating/deleting slower

7z a -ms=on archive.7z dir/

# Solid block size
7z a -ms=on -ms=4g archive.7z dir/
```

## Encryption

### Password Protection
```bash
# Create encrypted archive
7z a -p -mhe=on archive.7z file

# -p prompts for password
# -mhe=on encrypts headers (filenames too)
```

### Encryption Methods
```bash
# AES-256 (default for 7z)
7z a -p -mhc=on -mhe=on archive.7z file

# AES-256 for ZIP
7z a -tzip -p -mem=AES256 archive.zip file
```

## Aliases

Add to shell config:

```bash
# Aliases for 7z
alias 7zc='7z a'          # Create archive
alias 7zx='7z x'          # Extract archive
alias 7zl='7z l'          # List archive
alias 7zt='7z t'          # Test archive
alias 7zu='7z u'          # Update archive

# Quick tar.7z (tar + 7z)
alias tar7z='tar cf - file1 file2 | 7z a -si archive.tar.7z'

# Extract tar.7z
alias untar7z='7z x -so archive.tar.7z | tar xf -'
```

## Tips

### Best Compression
```bash
# For maximum compression (slow)
7z a -t7z -m0=lzma2 -mx=9 -md=256m -mfb=256 -ms=on archive.7z file

# For good compression (faster)
7z a -t7z -m0=lzma2 -mx=7 -md=64m -ms=on archive.7z file

# For fastest compression
7z a -t7z -m0=lzma2 -mx=1 -md=1m archive.7z file
```

### Backup Directories
```bash
# Backup directory with compression
7z a -t7z -m0=lzma2 -mx=9 backup.7z ~/documents/

# Incremental backup (only new/modified)
7z u -u -up0q0r2x2y2z0w0a1 backup.7z ~/documents/

# Backup excluding files
7z a backup.7z ~/projects/ -x!.git/ -x!node_modules/ -x!target/
```

### Exclude Patterns
```bash
# Exclude specific files
7z a archive.7z dir/ -x!*.log

# Exclude directories
7z a archive.7z dir/ -x!*.git/* -x!node_modules/*

# Exclude using regex
7z a archive.7z dir/ -xr!*.tmp
```

### Split Archives
```bash
# Create split archive for storage
7z a -v1g archive.7z largefile

# Create CD-sized archives
7z a -v700m archive.7z dir/

# Create DVD-sized archives
7z a -v4.7g archive.7z dir/
```

## Troubleshooting

### "File is not supported"
```bash
# Install full 7zip package (Ubuntu/Debian)
sudo apt install p7zip-full

# Install plugins (Fedora)
sudo dnf install p7zip-plugins
```

### "Out of memory"
```bash
# Reduce dictionary size
7z a -md=16m archive.7z file

# Disable solid mode
7z a -ms=off archive.7z dir/
```

### Cannot extract RAR
```bash
# 7z can only extract RAR version 5
# For RAR3, install unrar

# Ubuntu/Debian
sudo apt install unrar

# Fedora
sudo dnf install unrar

# Arch
sudo pacman -S unrar
```

### Password not working
```bash
# Make sure -mhe=on matches
# If headers encrypted, must use -mhe=on to extract

7z x -p -mhe=on archive.7z
```

## Comparison

**7z:**
- Best compression ratio
- Open source
- Cross-platform
- AES-256 encryption
- Solid archives

**ZIP:**
- Most compatible
- Faster compression
- Worse compression ratio
- Widely supported

**tar.gz:**
- Unix standard
- Good compatibility
- Moderate compression
- POSIX permissions

**tar.xz:**
- Excellent compression
- Slow compression
- Fast decompression
- Native on Linux

## Resources

- [7-Zip Official](https://www.7-zip.org/)
- [7-Zip Documentation](https://sevenzip.osdn.jp/chm/cmdline/)
- [p7zip GitHub](https://github.com/jnovy/p7zip)

---

**Last Updated**: 2025-03-14
