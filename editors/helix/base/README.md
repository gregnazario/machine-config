# Helix Editor Configuration

Modern Rust-based modal editor with LSP support and Dracula theme.

## Features

### Editor Features
- **LSP Support** - rust-analyzer, TypeScript, Python, Go, YAML, JSON, HTML/CSS, Bash, Markdown, Terraform, Docker
- **Auto-format** - Format on save for supported languages
- **Auto-save** - Save automatically (configurable)
- **Soft Wrap** - Line wrapping at 100 characters
- **Indent Guides** - Visual indent indicators
- **Gutter** - Diagnostics, line numbers, diff

### UI
- **Theme** - Dracula
- **Line Numbers** - Relative line numbers
- **Status Line** - Mode, file name, diagnostics, encoding, type
- **File Picker** - With hidden files and symlinks

### Keybindings

#### Normal Mode

**Window Navigation**
- `Ctrl-h/j/k/l` - Navigate windows
- `Ctrl-w` - Vertical split
- `Ctrl-v` - Horizontal split

**File Operations**
- `Ctrl-p` - File picker
- `Ctrl-b` - Buffer picker
- `Ctrl-f` - Global search
- `Ctrl-s` - Save
- `Ctrl-q` - Quit

**LSP**
- `Space l c` - Code actions
- `Space l d` - Go to definition
- `Space l h` - Hover documentation
- `Space l r` - Find references
- `Space l s` - Symbol info
- `Space l w` - Workspace symbol
- `Space l R` - Rename

**Leader**
- `Space q` - Quit
- `Space w` - Write (save)
- `Space x` - Force write
- `Space Q` - Force quit

#### Insert Mode

- `jj` - Escape to normal mode
- `Ctrl-s` - Save
- `Ctrl-z` - Undo
- `Esc` - Escape to normal mode

#### Select Mode

- `h/j/k/l` - Extend selection
- `w/W/e/b` - Extend word
- `0/$/^` - Extend to line start/end/first non-whitespace
- `C-s` - Save
- `C-q` - Quit
- `Esc` - Normal mode

## Installation

### Prerequisites

```bash
# Install Helix
# macOS
brew install helix

# Fedora
sudo dnf install helix

# Ubuntu
sudo snap install helix --classic

# Arch
sudo pacman -S helix

# Install LSP servers (manually or via system package manager)
```

### Setup

```bash
# Copy config to Helix config directory
mkdir -p ~/.config/helix
cp ~/.local/share/greg-config/editors/helix/base/config.toml ~/.config/helix/

# For theme (if using custom theme)
mkdir -p ~/.config/helix/themes
cp ~/.local/share/greg-config/editors/helix/base/themes/* ~/.config/helix/themes/

# Start Helix
hx
```

## Language Support

### Python
- **LSP**: pyright
- **Formatter**: black
- **Indent**: 4 spaces
- **Rulers**: 100 characters

### Rust
- **LSP**: rust-analyzer
- **Features**: all
- **Format**: auto
- **Rulers**: 100 characters

### TypeScript/JavaScript
- **LSP**: typescript-language-server
- **Formatter**: Prettier (via LSP)
- **Indent**: 2 spaces
- **Rulers**: 100 characters

### Go
- **LSP**: gopls
- **Format**: gofumpt, goimports
- **Indent**: tabs
- **Rulers**: 100 characters

### YAML
- **LSP**: yaml-language-server
- **Formatter**: yamlfmt
- **Indent**: 2 spaces
- **Rulers**: 100 characters

### JSON
- **LSP**: json-language-server
- **Formatter**: jsonfmt
- **Indent**: 2 spaces
- **Rulers**: 100 characters

### Markdown
- **LSP**: marksman
- **Soft Wrap**: 80 characters
- **Rulers**: 80 characters

### Bash
- **LSP**: bash-language-server
- **Formatter**: shfmt
- **Indent**: 2 spaces
- **Rulers**: 100 characters

## LSP Configuration

All LSP servers configured in `config.toml`:

```toml
[language-server]
typescript-language-server = { command = "typescript-language-server", args = ["--stdio"] }
pyright = { command = "pyright-langserver", args = ["--stdio"] }
rust-analyzer = { command = "rust-analyzer" }
gopls = { command = "gopls" }
# ... and more
```

## Theme

**Dracula Theme** configured with:
- Blue-ish purple backgrounds
- Bright text colors
- Custom colors for UI elements

Custom theme file: `themes/dracula_theme.toml`

## Usage

### Basic Editing

```bash
# Open file
hx file.py

# Open multiple files
hx file1.py file2.py

# Open directory
hx .

# File picker
Ctrl-p
```

### LSP Features

```bash
# Go to definition
Space l d

# Find references
Space l r

# Hover documentation
Space l h

# Code actions
Space l c

# Rename
Space l R
```

### Multiple Cursors

```bash
# Select multiple matches
Space s
# then select with c (character) or w (word)
```

## Shell Integration

Helix integrates well with:
- **Fish** - Shell completion
- **ZSH** - Shell completion
- **Bash** - Shell completion

## Troubleshooting

### LSP not working

1. Check LSP is installed
2. Restart Helix
3. Check helix log: `hx --log`

### Theme not loading

1. Check theme file exists in `~/.config/helix/themes/`
2. Check `config.toml` has correct theme name
3. Restart Helix

### Auto-format not working

1. Check language config has `auto-format = true`
2. Check formatter is installed
3. Try manual format: `Space l f`

## Resources

- [Helix Documentation](https://helix-editor.com/)
- [Helix GitHub](https://github.com/helix-editor/helix)
- [LSP Documentation](https://helix-editor.com/languages.html)
- [Dracula Theme](https://draculatheme.com/)

---

**Last Updated**: 2025-03-14
