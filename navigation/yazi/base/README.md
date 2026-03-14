# Yazi File Manager Configuration

Modern Rust-based terminal file manager with LSP support, image preview, and Dracula theme.

## Features

### Core Features
- **Dracula Theme** - Beautiful dark theme
- **FZF Integration** - Fuzzy file searching
- **File Preview** - Preview for text, images, videos
- **Sort Methods** - By name, size, modified time
- **Linemode Details** - Show size, permissions, dates
- **Parent Preview** - Show parent directory in preview
- **Git Integration** - Show git status in file list

### File Operations
- **Edit** - Open in your $EDITOR (nvim, hx, etc.)
- **Open** - Open with system default application
- **Extract** - Extract archives
- **Play** - Play media files

### Navigation
- **Vi-style** - Vi-inspired keybindings
- **Parent directory** - Go to parent directory
- **Search** - FZF-powered fuzzy search
- **Follow symlinks** - Follow symbolic links
- **Hidden files** - Toggle hidden files

## Installation

### Prerequisites

```bash
# Install Yazi
# macOS
brew install yazi

# Fedora
sudo dnf install yazi

# Ubuntu (via cargo)
cargo install yazi

# Arch (from AUR)
yay -S yazi

# Dependencies:
# - fd: fast file search
# - ripgrep: content search
# - fzf: fuzzy finder
# - bat: syntax highlighting
# - chafa: image preview
# - ffmpegthumbnailer: video thumbnails
# - pdftopp: PDF preview
# - poppler: PDF rendering
# - fontpreview: font preview
```

### Setup

```bash
# Copy config to Yazi directory
mkdir -p ~/.config/yazi
cp ~/.local/share/greg-config/navigation/yazi/base/yazi.toml ~/.config/yazi/

# Start Yazi
yazi

# Or set as default file manager
# Add to shell config:
# export OPENER=yazi
```

## Usage

### Basic Navigation

```bash
# Open Yazi in current directory
yazi

# Open in specific directory
yazi ~/projects

# Open Yazi from Yazi
# Just type yazi and hit Enter in Yazi

# Go to parent directory
h

# Go into directory
l

# Toggle hidden files
zh

# Sort by
# sz - Sort by size
# sm - Sort by modified time
# sa - Sort alphabetically

# File operations
# Enter - Open file/dir
# Space - Select file
# v - Visual mode (multi-select)
# yy - Yank (copy) selected files
# pp - Paste (move) files
# dd - Delete selected files
# q - Quit

# FZF search
/ - Open FZF search
# Type search term
# Enter to go to file

# Preview
# Preview shown on the right
# Shows: file content, image preview, etc.

# CD on quit
# Yazi will cd into the last visited directory
# on exit (if supported by shell)

# Image preview
# JPG, PNG, GIF, etc. displayed in preview pane

# Video preview
# Thumbnails shown for video files

# PDF preview
# PDF content displayed in preview pane

# Archive preview
# Archive contents displayed

# Parent preview
# Parent directory shown in preview pane

# Line modes
# Size: Shows file size
# Mtime: Shows modified time
# Permissions: Shows file permissions
```

## LSP Features

Yazi has built-in LSP support for:
- Syntax highlighting
- Code navigation
- Symbol search
- Find references
- Hover documentation

## Theme

**Dracula Theme** configured with:
- Dracula color palette
- Custom file colors
- Custom UI elements
- Graph colors (blue, purple, pink, yellow, green)

## Configuration

### Sort Options

- `alphabetical` - Sort by name
- `natural` - Sort by natural order (numbers correctly)
- `size` - Sort by file size
- `mtime` - Sort by modified time
- `ext` - Sort by file extension

### Line Modes

- `none` - No line mode
- `size` - Show file size
- `mtime` - Show modified time
- `permissions` - Show file permissions

### Keybindings

**Normal Mode:**
- `h/j/k/l` - Navigate left/down/up/right
- `Enter` - Enter directory
- `q` - Quit (CD to current dir)
- `Q` - Quit (no CD)

**Visual Mode:**
- `v` - Toggle visual mode
- `Space` - Toggle selection
- `yy` - Yank selected files
- `dd` - Delete selected files

**Search:**
- `/` - FZF search
- Type search term
- `Esc` - Clear search

## File Type Support

### Text Files
- `.txt`, `.md`, `.rst` - Preview with syntax highlighting
- `.json`, `.yaml`, `.toml` - Preview with syntax highlighting
- Source code - Preview with syntax highlighting

### Images
- `.jpg`, `.png`, `.gif`, `.svg` - Image preview

### Videos
- `.mp4`, `.mkv`, `.avi` - Video thumbnail

### Archives
- `.zip`, `.tar`, `.gz`, `.bz2`, `.7z`, `.rar` - Archive contents

### PDF
- `.pdf` - PDF preview (first page)

### Fonts
- Font preview

## Integration

### Shell Integration

```bash
# CD to last directory in Yazi
# In Yazi, press 'q' to quit
# This will cd to the last directory you were in

# Or use yazi wrapper function
function ya() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f "$tmp"
}

# Use in shell:
# ya
# ya ~/projects
# ya ..
```

### Neovim Integration

```vim
" Use Yazi as file explorer in Neovim
function! Yazi()
  execute 'silent !yazi ' . expand('%:p:h')
  redraw!
endfunction

" Map to a keybinding
nnoremap <leader>e :call Yazi()<CR>
```

### Ranger Replacement

```bash
# Use Yazi instead of ranger
alias ranger='yazi'

# Use Yazi as file browser
alias files='yazi'
alias f='yazi'
```

## Troubleshooting

### Preview not working

1. Check preview dependencies are installed
2. Check file permissions
3. Check Yazi log: `yazi --debug`

### FZF not working

1. Install FZF
2. Check FZF is in PATH
3. Restart Yazi

### Image preview not working

1. Install `chafa` or `ueberzug`
2. Check terminal supports sixel
3. Try terminal kitty or alacritty

### PDF preview not working

1. Install `pdftopp` or `poppler`
2. Check PDF file is not corrupted
3. Check file permissions

### Slow performance

1. Reduce preview size
2. Disable file watcher
3. Reduce max_height/max_width

## Resources

- [Yazi Documentation](https://yazi-rs.github.io/)
- [Yazi GitHub](https://github.com/sxyazi/yazi)
- [Yazi Plugins](https://yazi-rs.github.io/plugins.html)
- [Dracula Theme](https://draculatheme.com/)

---

**Last Updated**: 2025-03-14
