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

The installer will automatically install Python 3 if it's missing.

### Installation Profiles

The installer includes predefined profiles for common use cases:

1. **Minimal** (4 tools)
   - Essential tools for everyday use
   - zsh, fd, ripgrep, fzf, git, tldr
   - Perfect for new users or minimal setups

2. **Developer** (~20 tools)
   - Full development environment
   - Editors: neovim
   - Languages: python, rust, nodejs
   - Tools: git, gh, lazygit, docker, btop
   - Great for software developers

3. **Terminal Ninja** (~25 tools)
   - Focus on terminal productivity
   - Multiplexers: zellij, tmux
   - Shells: zsh, fish
   - All navigation and monitoring tools
   - Ideal for terminal power users

4. **System Administrator** (~15 tools)
   - Server and system management tools
   - Containers: docker, kubernetes
   - Monitoring: btop, glances
   - Network and transfer tools
   - Perfect for sysadmins

5. **Full Setup** (All tools)
   - Every available tool configured
   - For when you want everything
   - Use with caution!

6. **Custom** (Choose your own)
   - Hand-pick specific tools
   - Edit categories individually
   - Toggle tools on/off
   - Maximum control

### Installation Flow

1. **Python Check** (Automatic)
   - Installs Python 3 if missing
   - Upgrades if version too old

2. **Profile Selection**
   - Choose from predefined profiles
   - Or select custom for manual selection

3. **Tool Selection** (If custom or customizing profile)
   - Browse tools by category
   - See selection status [All/X/None]
   - Toggle individual tools
   - Accept when ready

4. **Confirmation**
   - Review all selected tools
   - Grouped by category
   - Total tool count
   - Confirm to proceed

5. **Installation**
   - Runs category installers
   - Creates symlinks
   - Merges configurations
   - Reports success/failure

6. **Summary**
   - Installation results
   - Next steps
   - Failure details (if any)

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

## Examples

### Install Minimal Profile

```bash
./scripts/install.sh
# Select: 1) Minimal
# Choose: 1) Accept as-is
# Confirm: y
```

### Install Developer Profile with Customization

```bash
./scripts/install.sh
# Select: 2) Developer
# Choose: 2) Customize
# Edit categories as needed
# Accept when ready
# Confirm: y
```

### Custom Installation

```bash
./scripts/install.sh
# Select: 6) Custom
# Edit each category
# Accept when ready
# Confirm: y
```

## Adding a New Profile

Edit `scripts/install/install.py` and add to `PROFILES` dict:

```python
PROFILES = {
    # ... existing profiles ...
    'myprofile': {
        'name': 'My Profile',
        'description': 'Description of what this profile is for',
        'tools': {
            'shells': ['zsh', 'fish'],
            'navigation': ['fd', 'ripgrep'],
            # ... more categories and tools
        }
    },
}
```

Or use `'tools': 'all'` to include all tools:

```python
'my-full': {
    'name': 'My Full Setup',
    'description': 'Everything I need',
    'tools': 'all'  # All tools from all categories
}
```

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

The installer will attempt to install Python 3 automatically. If it fails:

**Install manually:**
- **macOS**: `brew install python@3`
- **Fedora**: `sudo dnf install python3`
- **Ubuntu**: `sudo apt install python3`
- **Arch**: `sudo pacman -S python`

Then run the installer again.

### "Python 3.6 or higher is required"

The installer will try to upgrade Python automatically. If it fails, upgrade manually using your package manager.

### Installer exits unexpectedly

Run with debug output:

```bash
python3 scripts/install/install.py 2>&1 | tee install.log
```

### Category installer fails

Check the specific installer script:

```bash
# Run installer directly
sh scripts/install/install-<category>.sh $(./scripts/utils/detect-os.sh) $(pwd)
```

## Development

### Testing the Installer

To test profile selection:

```bash
echo "1" | ./scripts/install.sh  # Select minimal profile
```

To test custom selection (interactive):

```bash
./scripts/install.sh
# Select: 6) Custom
# Test category navigation and tool toggling
```

### File Structure

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
