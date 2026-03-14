# unar (Universal Archive)

unar is a command-line utility for extracting archives in various formats. It's the archive companion to lsar.

## Features

### Supported Formats
- **ZIP** - ZIP and JAR archives
- **TAR** - Tar archives (including compressed variants)
- **GZIP** - .gz files
- **BZIP2** - .bz2 files
- **7Z** - 7-Zip archives
- **RAR** - RAR archives (all versions)
- **ISO** - CD/DVD images
- **CAB** - Cabinet files
- **ACE** - ACE archives
- **LHA** - LHA/LZH archives
- ** StuffIt** - SIT archives
- **DMG** - disk images
- **RPM** - RPM packages
- **DEB** - Debian packages
- **CPIO** - CPIO archives
- **XAR** - XAR archives
- **LZMA** - LZMA and XZ
- **NSIS** - NSIS installers

### Features
- **Automatic encoding detection** - Detects filenames encoding automatically
- **Recursive extraction** - Extract nested archives
- **Smart extraction** - Creates directories intelligently
- **Preserve permissions** - Maintains file permissions
- **Quiet mode** - Suppress output

## Installation

### Prerequisites

```bash
# Install unar
# macOS
brew install unar

# Fedora
sudo dnf install unar

# Ubuntu
sudo apt install unar

# Arch
sudo pacman -S unarchiver
# or
yay -S unar

# Gentoo
sudo emerge app-arch/unar

# Void
sudo xbps-install unar

# Alpine
sudo apk add unar

# FreeBSD
sudo pkg install unar

# Windows (11)
# Download from: https://theunarchiver.com/command-line
# Or use scoop:
scoop bucket add extras
scoop install unar
```

### Setup

```bash
# No configuration needed
unar is ready to use after installation
```

## Usage

### Basic Extraction

```bash
# Extract archive (auto-detect format)
unar archive.zip

# Extract to specific directory
unar archive.7z -d /path/to/output

# Extract with password
unar archive.zip -p password

# Extract multiple archives
unar *.zip

# Force overwrite
unar archive.zip -f

# Never overwrite (skip existing files)
unar archive.zip -s

# Freshen files (overwrite only if newer)
unar archive.zip -f -o
```

### Output Options

```bash
# Quiet mode (no output)
unar archive.zip -q

# Verbose output
unar archive.zip -v

# Output directory
unar archive.zip -o /path/to/dir
# or
unar archive.zip --output-directory /path/to/dir

# No directory (extract to current dir)
unar archive.zip -D
```

### Special Operations

```bash
# List contents of archive
lsar archive.zip

# List with detailed info
lsar -l archive.zip

# Extract without creating directory
unar archive.zip -D

# Force output directory (even if single file)
unar archive.zip -f -D

# Recursively extract nested archives
unar archive.zip -r

# Show password prompt
unar archive.zip -p
```

### Encoding Detection

```bash
# Detect encoding manually
unar archive.zip -e UTF-8

# List encodings
lsar -e archive.zip

# Force specific encoding
unar archive.zip -e GB18030

# Auto-detect encoding (default)
unar archive.zip
```

### Archive Formats

```bash
# ZIP archives
unar file.zip

# TAR archives
unar file.tar

# Compressed tar
unar file.tar.gz
unar file.tar.bz2
unar file.tar.xz
unar file.tar.lzma

# 7-Zip
unar file.7z

# RAR
unar file.rar

# ISO
unar file.iso

# DMG (macOS)
unar file.dmg

# RPM packages
unar file.rpm

# DEB packages
unar file.deb

# Cabinet files
unar file.cab

# LHA/LZH
unar file.lzh
```

## Options

### General Options

```bash
# -o, --output-directory <path>   Output directory
# -f, --force                     Overwrite files
# -s, --skip                      Skip existing files
# -D, --no-directory              No directory creation
# -p, --password <password>       Archive password
# -q, --quiet                     Quiet mode
# -v, --verbose                   Verbose output
# -r, --recursive                 Recursive extraction
# -e, --encoding <encoding>       Filename encoding
# -h, --help                      Show help
```

### Extraction Behavior

```bash
# Always overwrite (don't prompt)
unar archive.zip -f

# Skip existing files
unar archive.zip -s

# Prompt for overwrite
unar archive.zip

# Create parent directories
unar archive.zip -o ~/backups/newdir/
```

## lsar (List Archive)

```bash
# List archive contents
lsar archive.zip

# List with details
lsar -l archive.zip

# List with timestamps
lsar -l -t archive.zip

# List specific files
lsar archive.zip file1 file2

# Show encoding
lsar -e archive.zip

# List nested archives
lsar -r archive.zip
```

## Practical Examples

### Backup Extraction

```bash
# Extract backup archive
unar backup-2025.7z -d ~/restore/ -f

# Extract with password
unar secure.zip -p mypassword -o ~/decrypt/

# Extract and preserve timestamps
unar archive.7z -f -o ~/restore/
```

### Development

```bash
# Extract downloaded dependencies
unar dependencies.zip -d ~/project/lib/

# Extract multiple archives to same directory
unar *.tar.gz -o ~/extracted/

# Extract project archives
unar project-*.zip -D
```

### Batch Extraction

```bash
# Extract all archives in directory
for f in *.zip; do unar "$f" -o extracted/; done

# Extract all archives recursively
find . -name "*.zip" -exec unar {} -o extracted/ \;

# Extract all archives (any format)
unar -o extracted/ *
```

### Nested Archives

```bash
# Extract nested archives automatically
unar outer.zip -r

# Extract outer, then inner
unar outer.zip -o temp/
unar temp/inner.zip -o final/
```

## Aliases

Add to shell config:

```bash
# Aliases for unar
alias extract='unar'      # Extract archive
alias lsa='lsar'          # List archive
alias unarq='unar -q'     # Quiet extraction
alias unarf='unar -f'     # Force overwrite
alias unars='unar -s'     # Skip existing
```

## Tips

### Always Extract to Directory

```bash
# Extract to directory (safer)
unar archive.zip -d extracted/

# Don't extract archives directly to current dir
# Bad: unar archive.zip
# Good: unar archive.zip -d temp/
```

### Recursive Extraction

```bash
# Extract nested archives
unar archive-with-archives.zip -r -o output/

# Useful for multi-part releases
```

### Encoding Issues

```bash
# If filenames are garbled
unar archive.zip -e UTF-8

# Or try Windows encoding
unar archive.zip -e GB18030

# Let auto-detection try
unar archive.zip
```

### Password-Protected Archives

```bash
# Extract with password (prompt)
unar archive.zip -p

# Password in command line (insecure!)
unar archive.zip -p mypassword
```

### Verification

```bash
# List archive before extracting
lsar archive.zip

# Verify contents
lsar -l archive.zip | grep important_file

# Then extract
unar archive.zip -o verified/
```

## Troubleshooting

### "No such file or directory"

```bash
# Check archive exists
ls -la archive.zip

# Check file type
file archive.zip

# Try lsar first
lsar archive.zip
```

### Encoding Problems

```bash
# Auto-detection failed, try manually
unar archive.zip -e Windows-1252

# Or list encoding first
lsar -e archive.zip
```

### Password Not Working

```bash
# Try interactive password prompt
unar archive.zip -p

# Some archives have multiple passwords
# Try extracting each file separately
```

### Cannot Extract Format

```bash
# Check if format is supported
lsar archive.zip

# Install unar full package
# Ubuntu/Debian
sudo apt install unar

# Some formats need additional libraries
# Check unar documentation
```

### Directory Not Created

```bash
# Force directory creation
unar archive.zip -D

# Or specify output directory
unar archive.zip -o output/
```

## Comparison

**unar:**
- Supports most formats
- Auto encoding detection
- Easy to use
- Safe (doesn't overwrite by default)

**7z:**
- Better compression
- Faster
- Fewer formats
- Manual encoding specification

**unzip/tar:**
- Format-specific
- Faster for their format
- Don't handle nested archives
- Manual encoding handling

**atool:**
- Similar to unar
- Perl-based
- Less features
- Less maintained

## Integration

### With fd (fd-find)

```bash
# Extract all archives found by fd
fd -e zip -e tar -e gz | xargs unar -o extracted/
```

### With ripgrep

```bash
# Extract archives containing specific file
for f in *.zip; do
  if lsar "$f" | grep -q "important"; then
    unar "$f" -o important/
  fi
done
```

### With fzf

```bash
# Interactive archive extraction
unar $(fzf) -o extracted/

# Or list archive first
lsar $(fzf) | less
```

## Resources

- [The Unarchiver](https://theunarchiver.com/)
- [unar on GitHub](https://github.com/MacPaw/XADMaster)
- [unar Man Page](https://linux.die.net/man/1/unar)

---

**Last Updated**: 2025-03-14
