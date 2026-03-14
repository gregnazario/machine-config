-- Neovim Options
-- Base configuration for all operating systems

local opt = vim.opt

-- === Editor Settings ===

-- Line numbers
opt.relativenumber = true  -- Relative line numbers
opt.number = true          -- Show current line number

-- Indentation
opt.expandtab = true       -- Use spaces instead of tabs
opt.shiftwidth = 4         -- Number of spaces for indentation
opt.tabstop = 4            -- Number of spaces for a tab
opt.smartindent = true     -- Smart indentation
opt.shiftround = true      -- Round indent to multiple of shiftwidth

-- Search
opt.ignorecase = true      -- Case insensitive search
opt.smartcase = true       -- Case sensitive when uppercase present
opt.hlsearch = false       -- Don't highlight all matches
opt.incsearch = true       -- Show match as you type

-- Text rendering
opt.wrap = false           -- Don't wrap lines
opt.linebreak = true       -- Break lines at word boundaries
opt.scrolloff = 8          -- Keep 8 lines visible when scrolling
opt.sidescrolloff = 8      -- Keep 8 columns visible horizontally
opt.signcolumn = "yes"     -- Always show sign column

-- Appearance
opt.termguicolors = true    -- True color support
opt.background = "dark"    -- Dark background
opt.cursorline = true      -- Highlight current line
opt.winblend = 10          -- Pseudo-transparency for floating windows
opt.pumblend = 10          -- Pseudo-transparency for popup menu

-- Status line
opt.laststatus = 3         -- Global status line
opt.showmode = false       -- Don't show mode in command line

-- Command line
opt.cmdheight = 1          -- Height of command line
opt.showcmd = true         -- Show command in status line
opt.wildmenu = true        -- Command-line completion menu
opt.wildmode = "longest:full,full"  -- Wildcard completion mode

-- Windows and splits
opt.splitbelow = true      -- Split window below current
opt.splitright = true      -- Split window to the right
opt.equalalways = true     -- Equalize window sizes

-- Mouse
opt.mouse = "a"            -- Enable mouse support
opt.mousescroll = "ver:1,hor:6"  -- Scroll speed

-- Clipboard
opt.clipboard = "unnamedplus"  -- Use system clipboard

-- Undo and backup
opt.undofile = true        -- Persistent undo
opt.backup = false         -- Don't create backup files
opt.writebackup = false    -- Don't create backup before write
opt.swapfile = false       -- Don't use swap files

-- Performance
opt.updatetime = 250       -- Faster swap file write
opt.timeoutlen = 300       -- Faster key mapping timeout
opt.ttimeoutlen = 10       -- Faster key code timeout

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }  -- Completion options
opt.pumheight = 10         -- Maximum height of popup menu

-- Folding
opt.foldmethod = "expr"     -- Use Treesitter for folding
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99         -- Open all folds by default
opt.foldcolumn = "1"       -- Show fold column

-- grep
opt.grepprg = "rg --vimgrep"  -- Use ripgrep for :grep command
opt.grepformat = "%f:%l:%c:%m"  -- Grep output format

-- Session
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }

-- View
opt.viewoptions = { "folds", "cursorbindings", "cursor" }  -- Save and restore view

-- Listchars
opt.list = true            -- Show listchars
opt.listchars = {
  tab = "│ ",
  trail = "·",
  nbsp = "␣",
  extends = "⟩",
  precedes = "⟨",
  eol = "↲",
}

-- Fillchars
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Spelling
opt.spelllang = { "en" }   -- Spell checking language
opt.spelloptions = "camel"  -- Treat camelCase as one word

-- Format options
opt.formatoptions = "jcroqlnt"  -- See :help fo-table

-- Number formats
opt.nrformats = "alpha"    -- Number formats for Ctrl-a/x

-- Shortmess
opt.shortmess = {
  a = true,  -- Use [a]bbreviated file names
  c = true,  -- Don't show |ins-completion-menu| messages
  s = true,  -- Don't show search count message
}

-- Confirm
opt.confirm = true         -- Ask to save instead of failing

-- Hidden
opt.hidden = true          -- Allow hidden buffers

-- History
opt.history = 1000         -- Number of commands to remember

-- Tags
opt.tags = "./tags,tags;"  -- Tags file location

-- Tag stack
opt.tagfunc = ""           -- Use default tag function

-- Wildignore
opt.wildignore = {
  "*.aux",
  "*.out",
  "*.toc",
  "*.o",
  "*.pyc",
  "*pycache*",
  ".git",
  ".hg",
  ".svn",
  "*.DS_Store",
  "node_modules",
}

-- === LSP Settings ===

vim.lsp.enable = function()
  -- Auto-start LSP for all supported languages
  require("config.lsp").setup()
end

-- === Diagnostics ===

-- Configure diagnostic signs
vim.fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "!", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "i", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "?", texthl = "DiagnosticSignHint" })

-- Configure diagnostic display
vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✗",
      [vim.diagnostic.severity.WARN] = "!",
      [vim.diagnostic.severity.INFO] = "i",
      [vim.diagnostic.severity.HINT] = "?",
    },
  },
  virtual_text = {
    prefix = "●",
    spacing = 2,
  },
  float = {
    border = "rounded",
    source = "always",
  },
  underline = true,
  update_in_insert = false,
})

-- === Terminal ===

-- Shell
vim.env.SHELL = "/bin/bash"  -- Or use fish, zsh, etc.

-- Terminal settings
opt.termsync = false

-- === Filetype ===

-- Filetype plugins
opt.filetype = "plugin"
opt.filetype = "indent"

-- Modeline
opt.modeline = true
opt.modelines = 3

-- === Fix issues ===

-- Fix markdown indentation
vim.g.markdown_recommended_style = 0

-- Disable perl provider
vim.g.loaded_perl_provider = 0

-- Disable ruby provider
vim.g.loaded_ruby_provider = 0

-- === Netrw (file browser) ===

-- Use neo-tree instead
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

-- === Disable built-in plugins ===

-- Comment plugin (using Comment.nvim instead)
vim.g.loaded_comment = 0

-- Matchit (using nvim-treesitter-textobjects instead)
vim.g.loaded_matchit = 1

-- 2html plugin
vim.g.loaded_2html_plugin = 1

-- Remote plugins
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

-- === Neovim-specific settings ===

-- Use Lua for expressions
vim.o.exrc = false

-- Python provider (if needed)
-- vim.g.python_host_prog = "/usr/bin/python"
-- vim.g.python3_host_prog = "/usr/bin/python3"

-- Node provider (if needed)
-- vim.g.node_host_prog = "/usr/bin/neovim-node-host"

-- Ruby provider (if needed)
-- vim.g.ruby_host_prog = "/usr/bin/neovim-ruby-host"

-- === Performance ===

-- Reduce updatetime for CursorHold
opt.updatetime = 300

-- Faster syntax highlighting
vim.cmd("syntax sync minlines=200")

-- === Time ===

-- Timeout for mappings
opt.timeout = true
opt.ttimeout = true
opt.ttimeoutlen = 50

-- === Title ===

-- Set window title
opt.title = true
opt.titlestring = "%t %y %m"

-- === Status line format ===

opt.statusline = ""  -- Will be set by lualine

-- === Wildmenu completion ===

opt.wildoptions = "pum"

-- === Menu ===

opt.pumheight = 15

-- === EditorConfig ===

-- Enable EditorConfig support
vim.cmd([[
  packadd vim-editorconfig
  let g:editorconfig = v:true
]])

-- === File encoding ===

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- === End of options ===

-- These options will be used by Neovim
-- OS-specific overrides will be layered on top
-- source: editors/neovim/os/$(detect-os)/options.lua
