# Greg's Dotfiles Installer

## Architecture

The installer uses a **bootstrap pattern**:

1. **`install.sh`** (POSIX shell) - Lightweight bootstrap that checks for Python 3
2. **`install.py`** (Python 3) - Full-featured interactive installer
3. **`install-*.sh`** (POSIX shell) - Category-specific installation scripts

## Why Python?

- **Universal**: Python 3 is available on all 12 supported operating systems
- **Interactive**: Proper input handling, menu systems, and terminal control
- **Maintainable**: Easier to read and modify than complex shell scripts
- **Cross-platform**: Consistent behavior across different shells
- **Error Handling**: Better exception handling and debugging

## Usage

### Quick Start

```bash
# From the repository root
./scripts/install.sh
```

### Direct Python Usage

```bash
# If you prefer to run Python directly
python3 scripts/install/install.py
```

## Requirements

- **Python 3.6+** - Required for the interactive installer
- **POSIX shell** (sh, bash, dash, etc.) - Only for bootstrap and category scripts

## Installation Flow

1. **Bootstrap** (`install.sh`)
   - Checks for Python 3 installation
   - Validates Python version (3.6+)
   - Delegates to Python installer

2. **Welcome & Detection** (`install.py`)
   - Displays system information
   - Detects operating system
   - Shows welcome message

3. **Category Selection**
   - Interactive menu to select tool categories
   - Preview tools in each category
   - Select all or specific categories

4. **Confirmation**
   - Shows summary of selections
   - Displays target OS
   - Confirms before proceeding

5. **Installation**
   - Runs category-specific install scripts
   - Creates symlinks and merges configs
   - Reports success/failure for each category

6. **Completion**
   - Displays installation summary
   - Shows next steps
   - Reports any failures

## Supported Categories

- `terminals` - Terminal multiplexers (zellij, tmux, screen)
- `editors` - Text editors (neovim, helix, emacs)
- `shells` - Shell configurations (zsh, fish, nushell)
- `navigation` - File navigation (yazi, fd, ripgrep, fzf)
- `monitoring` - System monitoring (btop, glances, modern-utils)
- `version-control` - Version control (git, gh, lazygit, git-fuzzy)
- `network` - Network tools (gping, httpie, speedtest, bandwhich)
- `productivity` - Productivity tools (presenterm, todotxt, jira-cli)
- `transfer` - Download/transfer (aria2, curlie, wget2)
- `development` - Dev tools (python, rust, nodejs, project-templates)
- `containers` - Container tools (nix, docker, kubernetes, version-managers)
- `security` - Security tools (age, ssh, 1password-cli, totp)
- `archive` - Archive tools (compressors, parallel, unar, image-tools)
- `documentation` - Documentation (tldr, tealdeer, man, cheat, docuum)
- `fun` - Fun utilities (fetch, utilities, qalc)

## Adding a New Category

### 1. Create Category Installer

Create `scripts/install/install-<category>.sh`:

```bash
#!/bin/sh
# Install <category> configurations
# Arguments: OS_TYPE REPO_ROOT

set -e -u

OS_TYPE="$1"
REPO_ROOT="$2"

# Your installation logic here
echo "Installing <category> for $OS_TYPE"
```

### 2. Add to Python Installer

Edit `scripts/install/install.py` and add to `CATEGORIES` dict:

```python
CATEGORIES = {
    # ... existing categories ...
    'newcategory': {
        'description': 'Category Description',
        'tools': ['tool1', 'tool2', 'tool3']
    }
}
```

### 3. Test

```bash
./scripts/install.sh
```

## Troubleshooting

### "Python 3 is not installed"

Install Python 3 using your system package manager:

- **macOS**: `brew install python@3`
- **Fedora**: `sudo dnf install python3`
- **Ubuntu**: `sudo apt install python3`
- **Arch**: `sudo pacman -S python`

### "Python 3.6 or higher is required"

Your system has an old Python version. Update to Python 3.6 or newer.

### Installer exits unexpectedly

Run with debug output:

```bash
python3 scripts/install/install.py 2>&1 | tee install.log
```

### Category installer fails

Check the specific installer script:

```bash
# Run installer directly
sh scripts/install/install-<category>.sh $(detect-os) $(pwd)
```

## Development

### Testing the Installer

To test the installer without making changes:

```bash
# Dry run - just display what would be installed
python3 scripts/install/install.py --help
```

### Adding Python Dependencies

If you need external Python packages:

1. Create `scripts/install/requirements.txt`
2. Update bootstrap to install requirements:
   ```bash
   pip install -r scripts/install/requirements.txt
   ```

**Note**: Currently, the installer uses only Python standard library to avoid dependency issues.

## File Structure

```
scripts/
├── install.sh              # Bootstrap (POSIX sh)
├── install/
│   ├── install.py          # Main installer (Python 3)
│   ├── install-terminals.sh
│   ├── install-editors.sh
│   ├── install-*.sh        # Category installers
│   └── README.md           # This file
├── utils/
│   ├── detect-os.sh        # OS detection utility
│   └── common.sh           # Common functions
└── lint.sh                 # Linting script
```

## License

Part of Greg's Dotfiles Repository
