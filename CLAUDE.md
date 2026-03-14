# AI Agent Guide: Greg's Dotfiles Repository

This document describes the structure and conventions used in this dotfiles repository to help AI agents (Claude, Copilot, etc.) understand how to work with and extend it.

## Repository Structure

### Top-Level Organization

```
greg-config/
├── <category>/              # Tool categories (terminals, editors, shells, etc.)
│   ├── <tool>/             # Individual tool directory
│   │   ├── base/           # Base configuration (all OSes)
│   │   │   ├── config.file # Actual config files
│   │   │   └── README.md   # Tool-specific documentation
│   │   └── os/             # OS-specific overrides
│   │       ├── macos/      # macOS-specific configs
│   │       ├── fedora/     # Fedora-specific configs
│   │       ├── arch/       # Arch-specific configs
│   │       ├── gentoo/     # Gentoo-specific configs
│   │       ├── ubuntu/     # Ubuntu-specific configs
│   │       ├── void/       # Void Linux-specific configs
│   │       ├── oracle/     # Oracle Linux-specific configs
│   │       ├── rocky/      # Rocky Linux-specific configs
│   │       ├── alpine/     # Alpine Linux-specific configs
│   │       ├── freebsd/    # FreeBSD-specific configs
│   │       ├── windows/    # Windows 11/WSL-specific configs
│   │       └── rpi/        # Raspberry Pi-specific configs
├── scripts/                # Installation and utility scripts
├── templates/              # Generic project templates
├── CLAUDE.md              # This file
├── README.md              # User-facing documentation
└── .gitignore             # Standard gitignore
```

## Supported Operating Systems

The repository supports 12 operating systems/distributions:

1. **macOS** - Apple's desktop OS
2. **Fedora** - Fedora Linux (RPM-based)
3. **RaspberryPi** - Raspberry Pi OS (Debian-based ARM)
4. **Arch** - Arch Linux (rolling release)
5. **Gentoo** - Gentoo Linux (source-based)
6. **Ubuntu** - Ubuntu Linux (Debian-based)
7. **Void** - Void Linux (independent)
8. **Oracle Linux** - Oracle Linux (RHEL-compatible)
9. **Rocky Linux** - Rocky Linux (RHEL-compatible)
10. **Alpine** - Alpine Linux (musl-based, minimal)
11. **Windows** - Windows 11 (both WSL2 and native)
12. **FreeBSD** - FreeBSD (Unix-like)

## Configuration Philosophy: Layered Approach

### The Layered System

Each tool uses a **layered configuration system**:

1. **Base Layer** (`base/`) - Common configuration for all OSes
2. **OS Layer** (`os/<os>/`) - OS-specific overrides on top of base

### How Layers Work

When installing configuration for a tool:

```bash
# On macOS, the installer would:
1. Read: terminals/zellij/base/config.kdl
2. Apply: terminals/zellij/os/macos/config.kdl (overrides/adds to base)
3. Merge: Create final config at ~/.config/zellij/config.kdl
```

### Override Strategy

- **OS-specific configs** should only contain **differences** from base
- Don't copy entire config - only override what's different
- Use merge strategies appropriate to the config format:
  - Shell scripts: `source` or `.` to include base
  - YAML/JSON/TOML: Override keys
  - KDL/Zellij: Merge sections
  - Emacs Lisp: Load base then add overrides

## Adding a New Tool

### Step 1: Choose Category

Place the tool in the appropriate category directory:

- `terminals/` - Terminal multiplexers
- `editors/` - Text editors
- `shells/` - Shell configurations
- `navigation/` - File navigation tools
- `monitoring/` - System monitoring tools
- `version-control/` - VCS tools
- `network/` - Network tools
- `productivity/` - Productivity tools
- `transfer/` - Download/transfer tools
- `development/` - Language/toolchain configs
- `containers/` - Container/VM tools
- `security/` - Security/auth tools
- `archive/` - Compression/archive tools
- `documentation/` - Documentation tools
- `fun/` - Fun utilities

### Step 2: Create Directory Structure

```bash
mkdir -p <category>/<new-tool>/{base,os/{macos,fedora,arch,gentoo,ubuntu,void,oracle,rocky,alpine,freebsd,windows,rpi}}
```

### Step 3: Add Base Configuration

Create the base configuration in `<category>/<new-tool>/base/`:

```bash
# Example: navigation/nnn/base/config
cat > navigation/nnn/base/config << 'EOF'
# Configuration for nnn file manager
# This is the base configuration used on all OSes
EOF
```

### Step 4: Document the Tool

Add a README.md in the tool's root directory:

```markdown
# nnn - File Manager Configuration

## What is nnn?

ncurses-based file manager with hardcore keyboard-only workflow.

## Configuration Files

- `~/.config/nnn/plugins/config` - Plugin configuration
- `~/.config/nnn/plugins/` - Plugins directory

## Installation

### macOS
```bash
brew install nnn
```

### Ubuntu/Debian
```bash
sudo apt install nnn
```

### Arch
```bash
sudo pacman -S nnn
```

### Fedora
```bash
sudo dnf install nnn
```

## OS-Specific Notes

### macOS
- Uses different keybindings for some commands due to Terminal.app differences

### FreeBSD
- Requires compilation from ports or package from sysutils/nnn

## Features Included

- Custom plugins
- Custom keybindings
- Integration with fzf
- CD on quit (nnn's `Q` feature)
```

### Step 5: Add OS-Specific Overrides (if needed)

Only create OS-specific files if there are actual differences:

```bash
# Example: macOS-specific override
cat > navigation/nnn/os/macos/config-override << 'EOF'
# macOS-specific keybindings due to Terminal differences
EOF
```

## Adding a New Operating System

### Step 1: Create OS Directories

For each tool, add the new OS directory:

```bash
#!/bin/bash
# scripts/add-os.sh NEW_OS_NAME

for tool_dir in */*/; do
  if [ -d "$tool_dir/os" ]; then
    mkdir -p "$tool_dir/os/NEW_OS_NAME"
  fi
done
```

### Step 2: Update OS Detection

Update `scripts/utils/detect-os.sh`:

```bash
detect_os() {
  # ... existing detection logic ...

  # Add new OS detection
  elif [ -f /etc/NEW_OS-release ]; then
    echo "newos"
}
```

### Step 3: Add Installation Scripts

Create installation scripts in `scripts/install/`:

```bash
# scripts/install/newos-install.sh
install_packages_newos() {
  # Package manager commands for new OS
}
```

## Configuration Merge Strategies

### Shell Configurations (bash, zsh, fish, nushell)

**Strategy**: Source/include the base file, then add OS-specifics

```bash
# shells/zsh/base/.zshrc
# Base zsh configuration
export PATH="$HOME/bin:$PATH"

# shells/zsh/os/macos/.zshrc
# Source base configuration
source ~/.config/zsh/base/.zshrc

# macOS-specific additions
export PATH="/opt/homebrew/bin:$PATH"
```

### YAML/TOML/JSON Configurations

**Strategy**: Override keys, keep rest from base

```yaml
# editors/helix/base/config.toml
[editor]
line-number = "relative"
mouse = true

# editors/helix/os/windows/config.toml
[editor]
line-number = "relative"  # Keep same
mouse = false            # Override for Windows Terminal

# Windows-specific keys
[editor.soft-wrap]
enable = true
```

### KDL Configurations (Zellij)

**Strategy**: Merge sections

```kdl
// terminals/zellij/base/config.kdl
keybinds clear-defaults=true {
    shared_except "lock" {
        bind "Ctrl g" { SwitchToMode "lock"; }
    }
}

// terminals/zellij/os/macos/config.kdl
// macOS-specific keybindings
keybinds {
    shared_except "lock" {
        bind "Cmd g" { SwitchToMode "lock"; }  # Cmd instead of Ctrl
    }
}
```

### Lisp Configurations (Emacs)

**Strategy**: Load base config, then evaluate OS-specifics

```elisp
;; editors/emacs/base/init.el
;; Base configuration
(require 'package)
(setq package-user-dir "~/.emacs.d/elpa")

;; editors/emacs/os/macos/init.el
;; Load base
(load "~/.config/emacs/base/init.el")

;; macOS-specific
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta))
```

## Naming Conventions

### Directory Names
- Use **lowercase** with **hyphens** for multi-word tools: `git-fuzzy`, `terminal-notes`
- Use **lowercase** for single words: `zellij`, `neovim`, `btop`

### File Names
- Config files should match their expected location:
  - `.zshrc` → `shells/zsh/base/.zshrc`
  - `config.kdl` → `terminals/zellij/base/config.kdl`
  - `init.lua` → `editors/neovim/base/init.lua`

### OS Directory Names
- Use lowercase, standardized names:
  - `macos` (not `darwin` or `osx`)
  - `fedora` (not `fedora-linux`)
  - `windows` (not `win` or `win11`)
  - `freebsd` (not `bsd` or `fbsd`)

## Script Conventions

### Installation Scripts

Location: `scripts/install/`

Naming: `<tool>-install.sh` or `install-<category>.sh`

Example structure:

```bash
#!/usr/bin/env bash
# scripts/install/zellij-install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/detect-os.sh"
source "$SCRIPT_DIR/../utils/install-base.sh"

install_zellij() {
    local os=$(detect_os)

    case "$os" in
        macos)
            brew install zellij
            ;;
        ubuntu|debian)
            sudo apt install -y zellij
            ;;
        arch)
            sudo pacman -S zellij
            ;;
        fedora)
            sudo dnf install zellij
            ;;
        *)
            echo "Unsupported OS: $os"
            return 1
            ;;
    esac
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    install_zellij "$@"
fi
```

### Utility Scripts

Location: `scripts/utils/`

Common utilities:
- `detect-os.sh` - OS detection
- `install-base.sh` - Base installation functions
- `merge-config.sh` - Configuration merge logic
- `symlink.sh` - Safe symlink creation

## Extending the Repository

### Adding a New Category

1. Create the category directory: `mkdir -p <new-category>/`
2. Add README.md explaining the category
3. Create tool subdirectories following the conventions
4. Add installation logic in `scripts/install/`

### Adding Package Managers

When adding tools that require specific package managers:

1. Check if package manager exists in `scripts/utils/detect-os.sh`
2. Add installation logic to `scripts/install/<category>-install.sh`
3. Document in the tool's README.md

### Cross-Tool Integration

Some tools integrate with others. Document these in the tool's README:

```markdown
## Integration with Other Tools

- **fzf**: Uses fuzzy finding for file selection
- **ripgrep**: Used for content search
- **zellij**: Detects if running inside Zellij session
```

## Testing Configurations

Before committing changes:

1. **Test on target OS**: Ensure config works on intended OS
2. **Test layer merge**: Verify base + OS-specific merge correctly
3. **Test install script**: Run installation script on clean system
4. **Document differences**: If OS has different behavior, document it

## Common Patterns

### Home Directory Structure

Configs should be installed to standard locations:

- Shell configs: `~/.config/<shell>/`
- CLI tools: `~/.config/<tool>/`
- Binaries: `~/.local/bin/`
- Libraries: `~/.local/lib/`

### XDG Base Directory Specification

Follow XDG standards where possible:

- `XDG_CONFIG_HOME` (default: `~/.config`)
- `XDG_DATA_HOME` (default: `~/.local/share`)
- `XDG_STATE_HOME` (default: `~/.local/state`)
- `XDG_CACHE_HOME` (default: `~/.cache`)

### Backward Compatibility

When updating configs:
- Don't break existing setups
- Use feature flags if needed
- Document breaking changes in tool's README

## Security Considerations

### Secrets Management

**NEVER commit secrets.** Use environment variables or external secret managers:

```bash
# Good: Reference secret via env var
export API_TOKEN="${DOTFILES_API_TOKEN:-}"

# Bad: Hardcoded secret
export API_TOKEN="sk-1234567890"
```

### Include Patterns

The `.gitignore` is configured to exclude:
- Secret keys and certificates
- Personal information (known_hosts, id_rsa)
- Local overrides
- Cache and runtime data

## Version Control

### Commit Messages

Use clear, descriptive commit messages:

```
feat(zellij): Add macOS keybinding overrides

- Map Cmd key instead of Ctrl for better macOS integration
- Add Terminal.app-specific workarounds
- Document in zellij README

Closes #123
```

### Branch Strategy

- `main` - Stable, working configurations
- `feature/<tool>-<feature>` - Feature branches
- `os/<os>` - OS-specific additions

## Resources for AI Agents

When working with this repository, AI agents should:

1. **Read this file first** - Understand the layered approach
2. **Check existing tool configs** - Follow established patterns
3. **Read tool-specific READMEs** - Understand tool-specific conventions
4. **Test merge logic** - Ensure base + OS layers work correctly
5. **Document changes** - Update relevant READMEs
6. **Follow naming conventions** - Maintain consistency

## Common Tasks for AI Agents

### "Add configuration for [tool]"

1. Choose appropriate category directory
2. Create directory structure with `base/` and `os/` subdirs
3. Add base configuration
4. Add OS-specific overrides if needed
5. Create README.md documenting the tool
6. Add installation script to `scripts/install/`
7. Test configuration merge

### "Add support for [OS] to [tool]"

1. Detect tool's directory: `<category>/<tool>/`
2. Create `os/<new-os>/` subdirectory
3. Add OS-specific configuration (only differences from base)
4. Update `scripts/utils/detect-os.sh` if needed
5. Add installation logic to `scripts/install/<tool>-install.sh`
6. Document in tool's README

### "Update [tool] configuration for new version"

1. Check tool's `base/` directory
2. Update base configuration for new version
3. Check if any OS-specific overrides need updates
4. Update tool's README with version-specific notes
5. Test on all target OSes if possible

## Contact and Contribution

This is a personal dotfiles repository. For questions or suggestions:

1. Open an issue
2. Submit a pull request
3. Follow the conventions in this document

---

**Last Updated**: 2025-03-14
**Maintained By**: Greg
