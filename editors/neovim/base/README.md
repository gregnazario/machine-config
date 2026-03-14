# Neovim Configuration

Lazy.nvim-based Neovim configuration with LSP support, modern completion, and Dracula theme.

## Features

### Editor Features
- **LSP Support** - rust-analyzer, TypeScript, Python (Pyright/Ruff), Go, YAML, JSON, HTML/CSS, Bash, Markdown, etc.
- **Completion** - nvim-cmp with LSP, buffer, and path sources
- **Treesitter** - Syntax highlighting for all common languages
- **Git Integration** - Gitsigns, fugitive
- **File Explorer** - Neo-tree with Git status
- **Fuzzy Finder** - Telescope with fzf-native
- **Terminal** - ToggleTerm with floating, horizontal, vertical
- **Comment** - Comment.nvim for quick comment toggling
- **Status Line** - Lualine with Dracula theme
- **Indent Guides** - Indent-blankline
- **Auto-pairs** - Mini.pairs

### UI
- **Theme** - Dracula
- **Icons** - nvim-web-devicons (if Nerd Font installed)
- **Bufferline** - Buffer tabs with diagnostics
- **Which-key** - Interactive keybinding popup
- **Startup screen** - Alpha dashboard

### Keybindings

#### Leader key: Space

**Files & Search**
- `<leader>ff` - Find files
- `<leader>fg` - Git files
- `<leader>fw` - Grep word
- `<leader>fb` - Find buffers
- `<leader>fo` - Old files
- `<leader>fc` - Commands

**LSP**
- `gd` - Go to definition
- `gr` - Go to references
- `gi` - Go to implementation
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>cr` - Rename
- `<leader>cf` - Format

**Git**
- `<leader>gg` - Git status
- `<leader>gb` - Git blame
- `<leader>gd` - Git diff

**Terminal**
- `<leader>tt` - Toggle terminal
- `<leader>th` - Terminal horizontal
- `<leader>tv` - Terminal vertical
- `<leader>tf` - Terminal float

**Windows**
- `Ctrl-h/j/k/l` - Navigate windows
- `<leader>-` - Horizontal split
- `<leader>|` - Vertical split
- `<leader>wd` - Close window

**Buffers**
- `<S-h>` - Previous buffer
- `<S-l>` - Next buffer

## Installation

### Prerequisites

```bash
# Install Neovim (v0.9+)
# macOS
brew install neovim

# Fedora/Ubuntu
sudo dnf install neovim  # Fedora
sudo apt install neovim  # Ubuntu

# Arch
sudo pacman -S neovim

# Install Nerd Font (for icons)
brew install font-jetbrains-mono-nerd-font

# Install LSP servers (via Mason)
# These will be installed automatically by Mason
```

### Setup

```bash
# Clone or copy to Neovim config directory
mkdir -p ~/.config/nvim
cp -r ~/.local/share/greg-config/editors/neovim/base/* ~/.config/nvim/

# Start Neovim
nvim

# Install plugins (Lazy.nvim will do this automatically)
# Press :Lazy then :Lazy sync

# Install LSP servers (Mason)
# Press :Mason, then press 'U' to install all
```

## Configuration Structure

```
~/.config/nvim/
├── init.lua                  # Entry point
├── lua/
│   ├── config/
│   │   ├── options.lua       # Neovim options
│   │   ├── keymaps.lua       # Keybindings
│   │   ├── autocmds.lua      # Autocommands
│   │   ├── lsp.lua           # LSP configuration
│   │   └── plugins.lua       # Plugin list
│   └── ...
└── ...
```

## LSP Servers

Auto-installed by Mason:
- **rust-analyzer** - Rust
- **ts_ls** - TypeScript/JavaScript
- **pyright** - Python
- **ruff_lsp** - Python (linting/formatting)
- **gopls** - Go
- **yamlls** - YAML
- **jsonls** - JSON
- **lua_ls** - Lua
- **html** - HTML
- **cssls** - CSS
- **bashls** - Bash
- **marksman** - Markdown
- **terraformls** - Terraform
- **dockerls** - Docker

## Python Development

```python
# Pyright configured with ruff_lsp for formatting
# Black and Ruff installed via null-ls

# LSP features:
# - Go to definition
# - Find references
# - Hover documentation
# - Code actions
# - Auto-import
# - Type checking
```

## Rust Development

```rust
// rust-analyzer configured
// - Cargo features: all
// - Check on save: clippy
// - Inlay hints: enabled

// LSP features:
// - Go to definition
// - Find references
// - Hover docs
// - Code actions
// - Macros expansion
// - Inlay types
```

## TypeScript Development

```typescript
// ts_ls configured
// - Prettier disabled (use null-ls)
// - ESLint configured
// - Path aliases supported

// LSP features:
// - IntelliSense
// - Go to definition
// - Find references
// - Refactoring
// - Type checking
```

## Troubleshooting

### LSP not working

1. Open Mason: `:Mason`
2. Check if LSP is installed
3. Press `U` to update all

### Treesitter not working

```vim
:TSUpdate
```

### Colors not working

```vim
:colorscheme dracula
```

### Plugins not loading

```vim
:Lazy health
:Lazy sync
```

## Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)
- [Nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [Mason.nvim](https://github.com/williamboman/mason.nvim)
- [Dracula Theme](https://github.com/Mofiqul/dracula.nvim)

---

**Last Updated**: 2025-03-14
