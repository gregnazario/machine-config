# tokei - Code Statistics

tokei is a program that displays statistics about your code. It's fast, accurate, and supports many languages.

## Features

### Core Features
- **Fast** - Written in Rust, very fast
- **Accurate** - Uses tree-sitter for parsing
- **Multi-language** - Supports 200+ programming languages
- **Blame** - Git blame statistics
- **File filtering** - Filter by extension, directory, etc.
- **Output formats** - JSON, CSV, and more
- **CI/CD friendly** - Exit codes based on thresholds
- **Hidden files** - Include/exclude hidden files
- **Comments** - Separate comment statistics

### Languages Supported
- **Web**: JavaScript, TypeScript, HTML, CSS, PHP, etc.
- **Systems**: C, C++, Rust, Go, etc.
- **Scripting**: Python, Ruby, Perl, Shell, etc.
- **Data**: JSON, YAML, XML, etc.
- **Markup**: Markdown, LaTeX, etc.
- **Config**: TOML, INI, Dockerfile, etc.
- And 180+ more!

## Installation

### Prerequisites

```bash
# Install tokei
# macOS
brew install tokei

# Fedora
sudo dnf install tokei

# Ubuntu
sudo snap install tokei
# Or download binary:
wget https://github.com/XAMPPRocky/tokei/releases/latest/download/tokei-x86_64-unknown-linux-gnu.tar.gz
tar xzf tokei-x86_64-unknown-linux-gnu.tar.gz
sudo mv tokei /usr/local/bin/

# Arch
sudo pacman -S tokei

# Gentoo
sudo emerge dev-util/tokei

# Void
sudo xbps-install tokei

# Alpine
sudo apk add tokei

# FreeBSD
sudo pkg install tokei

# Windows (11)
winget install tokei.tokei
# Or use scoop:
scoop install tokei

# Cargo (Rust)
cargo install tokei
```

### Setup

```bash
# No configuration needed
tokei is ready to use after installation

# Create config file (optional)
mkdir -p ~/.config/tokei
```

## Usage

### Basic Usage

```bash
# Show statistics for current directory
tokei

# Show statistics for specific directory
tokei /path/to/project

# Show statistics for specific files
tokei file1.py file2.js

# Show statistics for multiple directories
tokei project1/ project2/

# Include hidden files
tokei --hidden

# Exclude files
tokei --exclude '*.log'

# Exclude directory
tokei --exclude node_modules/
```

### Filtering

```bash
# Filter by language
tokei --languages Python,JavaScript,Rust

# Filter by file extension
tokei --files '*.py,*.js'

# Exclude language
tokei --exclude-language JavaScript

# Include specific files
tokei --files 'src/**/*.rs'

# Exclude directory
tokei --exclude target/

# Multiple exclusions
tokei --exclude node_modules/ --exclude target/ --exclude '*.min.js'
```

### Output Formats

```bash
# Human-readable (default)
tokei

# JSON output
tokei --output json

# JSON file
tokei --output json > stats.json

# Pretty JSON
tokei --output json | jq

# CSV output
tokei --output csv > stats.csv

# Compact output
tokei --compact

# Verbose output
tokei --verbose
```

### File Statistics

```bash
# Show file statistics
tokei --files

# Show individual files (not just directories)
tokei --files

# Sort by files
tokei --sort files

# Sort by lines
tokei --sort lines

# Sort by code
tokei --sort code

# Sort by comments
tokei --sort comments
```

### Git Integration

```bash
# Git blame statistics
tokei --blame

# Git blame for specific author
tokei --blame --author "Greg Nazario"

# Git blame for specific email
tokei --blame --email "greg@gnazar.io"

# Git blame since date
tokei --blame --since "2025-01-01"

# Git blame until date
tokei --blame --until "2025-12-31"

# Ignore files not in git
tokei --hidden
```

### Advanced Filtering

```bash
# Count only certain files
tokei --files 'src/**/*.rs'

# Exclude multiple patterns
tokei --exclude '*_test.go' --exclude '*_mock.go'

# Include/exclude by extension
tokei --exclude '*.min.js' --exclude '*.min.css'

# Count files by pattern
tokei --files --sort code

# Count only in src/ directory
tokei src/

# Exclude test files
tokei --exclude '*_test.*' --exclude '*.test.*'
```

### Configuration

```bash
# Read from config file
tokei --config /path/to/tokei.toml

# Save default config
tokei --config ~/.config/tokei/config.toml

# Use specific columns
tokei --columns 80

# Compact numbers (1K instead of 1000)
tokei --compact

# No collapsing (show all languages)
tokei --no-collapse
```

## Practical Examples

### Project Statistics

```bash
# Show project statistics
tokei

# Show by language
tokei --sort code

# Show with file count
tokei --files

# Pretty output
tokei --compact --sort code
```

### CI/CD Integration

```bash
# Check if code is under limit
tokei --output json | jq '.Total.code'

# Fail if code exceeds threshold
tokei --files | awk '{if ($2 > 10000) exit 1}'

# Generate report
tokei --output json > code-stats.json

# Upload to coverage service
tokei --output json | curl -X POST -d @- https://stats.service/api
```

### Monitoring Code Growth

```bash
# Save current stats
tokei --output json > stats-$(date +%Y%m%d).json

# Compare with previous stats
diff <(jq '.Total.code' stats-20250101.json) \
     <(jq '.Total.code' stats-20250201.json)

# Show growth
tokei --output json | jq '.Total.code'
```

### Team Statistics

```bash
# Count lines by author
tokei --blame

# Count by specific author
tokei --blame --author "Greg Nazario"

# Count lines by email
tokei --blame --email "greg@gnazar.io"

# Show blame for specific language
tokei --blame --languages Python
```

### Code Review

```bash
# Show files with most code
tokei --files --sort code

# Show largest files
tokei --files | sort -k2 -n

# Show files by language
tokei --files --languages Python,JavaScript

# Find complex files (high comment ratio)
tokei --files --verbose
```

### Documentation

```bash
# Count documentation lines
tokei --files | awk '{print $4, $5}'

# Count comments vs code
tokei --output json | \
  jq '.[] | select(.name == "Python") | .comments'

# Calculate comment ratio
code=$(tokei --output json | jq '.Total.code')
comments=$(tokei --output json | jq '.Total.comments')
ratio=$(echo "scale=2; $comments / $code * 100" | bc)
echo "Comment ratio: $ratio%"
```

## Aliases

Add to shell config:

```bash
# Aliases for tokei
alias tok='tokei'               # Quick stats
alias tokf='tokei --files'      # File stats
alias tokc='tokei --compact'    # Compact output
alias tokj='tokei --output json | jq'  # JSON output
alias tokb='tokei --blame'      # Blame stats
alias tokl='tokei --languages'  # Filter by language
alias toks='tokei --sort code'  # Sort by code
```

## Tips

### Quick Stats

```bash
# Quick overview
tokei --compact

# Show largest files
tokei --files | sort -k2 -n | head

# Count specific language
tokei --languages Python

# Exclude test files
tokei --exclude '*_test.*' --exclude '*.test.*'
```

### Clean Output

```bash
# Compact output for terminal
tokei --compact

# Show as JSON
tokei --output json | jq

# CSV for spreadsheets
tokei --output csv > stats.csv
```

### CI/CD

```bash
# Check code size
tokei --output json | jq '.Total.code'

# Fail if too large
if (( $(tokei --output json | jq '.Total.code') > 10000 )); then
  echo "Code too large!"
  exit 1
fi

# Generate badge
tokei --output json | jq '.Total.code'
```

### Monitoring

```bash
# Track code growth over time
echo "$(date),$(tokei --output json | jq '.Total.code')" >> growth.csv

# Create graph
# Use growth.csv in your favorite tool

# Compare directories
tokei old/ new/
```

## Configuration File

Create `~/.config/tokei/config.toml`:

```toml
# Exclude directories
exclude = [
  "node_modules",
  "target",
  "build",
  "dist",
  ".git",
  "__pycache__",
  "*.min.js",
  "*.min.css",
]

# Include hidden files
hidden = true

# Sort by code lines
sorting = "Code"

# Compact numbers
compact = true

# Specific languages
languages = [
  "Python",
  "JavaScript",
  "TypeScript",
  "Rust",
]

# Columns for output
columns = 80

# No collapsing (show all)
no_collapse = true
```

## Output Format

```
==============================================================================
 Language            Files    Lines    Code  Comments   Blanks    Complexity
==============================================================================
 Python                  45    8956     7234      1125      597          1234
 JavaScript              32    5423     4532       654      237          2345
 Rust                    18    3421     2987       312      122          890
 YAML                     8     456      234       145       77            -
 Markdown               12     789      678        89       22            -
==============================================================================
 Total                  115   19045    15665      2325     1055          4469
==============================================================================
```

## Comparison

**tokei:**
- Very fast (Rust)
- Uses tree-sitter (accurate)
- 200+ languages
- Git blame support
- JSON/CSV output
- Actively maintained

**cloc:**
- Perl-based
- Slower than tokei
- 200+ languages
- Widely used
- More mature

**scc:**
- Go-based
- Fast (but slower than tokei)
- 300+ languages
- More features
- More output options

**sloccount:**
- C-based
- Very slow
- Cost estimation
- Fewer languages
- Older tool

## Troubleshooting

### "No such file or directory"

```bash
# Check directory exists
ls -la /path/to/project

# Use current directory
tokei

# Check permissions
ls -la /path/to/project/
```

### Language not detected

```bash
# Check supported languages
tokei --languages | grep -i python

# Use file extension
tokei --files '*.py'

# Check file type
file script.py
```

### Git blame not working

```bash
# Check git repository
git status

# Check blame works
git blame file.py

# Run from git root
tokei --blame
```

### Output too wide

```bash
# Use compact output
tokei --compact

# Set columns
tokei --columns 80

# Output JSON instead
tokei --output json | jq
```

## Integration

### With fzf

```bash
# Select directory and show stats
tokei $(fd -t d | fzf)

# Interactive language filter
tokei --languages $(tokei --languages | fzf -m)
```

### With jq

```bash
# Pretty JSON output
tokei --output json | jq '.'

# Get total code lines
tokei --output json | jq '.Total.code'

# Get stats for Python
tokei --output json | jq '.Python'

# Calculate comment ratio
tokei --output json | jq '[.[] | .comments] | add / [.[] | .code] | add * 100'
```

### With Git

```bash
# Stats for git repo
tokei $(git rev-parse --show-toplevel)

# Stats for current branch only
tokei --files $(git diff --name-only)

# Stats for uncommitted files
tokei --files $(git diff --name-only)
```

### With CI/CD

```bash
# GitHub Actions
- name: Generate code stats
  run: |
    tokei --output json > stats.json

# GitLab CI
code_stats:
  script:
    - tokei --output json > stats.json
  artifacts:
    paths:
      - stats.json
```

## Resources

- [tokei GitHub](https://github.com/XAMPPRocky/tokei)
- [tokei Documentation](https://tokei.rs)
- [tokei on crates.io](https://crates.io/crates/tokei)

---

**Last Updated**: 2025-03-14
