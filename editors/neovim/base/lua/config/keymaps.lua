-- Neovim Keymaps
-- Base configuration for all operating systems

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- === Leader Key ===
-- Set to Space (configured in init.lua)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- === General Keymaps ===

-- Better escape for jj
keymap("i", "jj", "<ESC>", opts)

-- Save file
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })

-- Quit
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- Save and quit
keymap("n", "<leader>x", "<cmd>x<cr>", { desc = "Save and Quit" })

-- Force quit
keymap("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Force Quit All" })

-- === Window Navigation ===

-- Navigate windows
keymap("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
keymap("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
keymap("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
keymap("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })

-- Resize windows
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Window splits
keymap("n", "<leader>-", "<cmd>split<cr>", { desc = "Horizontal Split" })
keymap("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })

-- Close window
keymap("n", "<leader>wd", "<cmd>close<cr>", { desc = "Close Window" })

-- Close buffer
keymap("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close Buffer" })

-- === Buffer Navigation ===

-- Next buffer
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Previous buffer
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })

-- === Tab Navigation ===

-- New tab
keymap("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New Tab" })

-- Close tab
keymap("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close Tab" })

-- Next tab
keymap("n", "<leader>tl", "<cmd>tabnext<cr>", { desc = "Next Tab" })

-- Previous tab
keymap("n", "<leader>th", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- === Movement ===

-- Move lines up and down
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Selection Down" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Selection Up" })

-- === Visual Mode ===

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- === Search ===

-- Clear search highlights
keymap("n", "<leader>ur", "<cmd>nohlsearch<cr>", { desc = "Clear Search Highlights" })

-- === Undo/Redo ===

-- Undo
keymap("n", "U", "<cmd>redo<cr>", { desc = "Redo" })

-- === Text Editing ===

-- Better indenting
keymap("v", ">", ">gv", opts)
keymap("v", "<", "<gv", opts)

-- Paste over selection
keymap("v", "p", '"_dP', opts)

-- === Quickfix ===

-- Next quickfix item
keymap("n", "[q", "<cmd>cprev<cr>", { desc = "Previous Quickfix" })

-- Previous quickfix item
keymap("n", "]q", "<cmd>cnext<cr>", { desc = "Next Quickfix" })

-- === LSP Keymaps ===

-- LSP finder
keymap("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
keymap("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })
keymap("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
keymap("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })

-- Hover documentation
keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
keymap("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })

-- Code actions
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })

-- Rename
keymap("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })

-- Format
keymap("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format Document" })

-- Diagnostics
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open Diagnostic Float" })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Add to Location List" })

-- LSP info
keymap("n", "gI", "<cmd>LspInfo<cr>", { desc = "LSP Info" })

-- === Telescope Keymaps ===

-- Find files
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })

-- Git files
keymap("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Git Files" })

-- Grep in files
keymap("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Grep Word" })

-- Search in current buffer
keymap("n", "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search Buffer" })

-- Buffers
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find Buffers" })

-- Old files
keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Old Files" })

-- Commands
keymap("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Commands" })

-- Keymaps
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })

-- Help tags
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })

-- Man pages
keymap("n", "<leader>fm", "<cmd>Telescope man_pages<cr>", { desc = "Man Pages" })

-- Marks
keymap("n", "<leader>fM", "<cmd>Telescope marks<cr>", { desc = "Marks" })

-- Registers
keymap("n", "<leader>fr", "<cmd>Telescope registers<cr>", { desc = "Registers" })

-- Colorschemes
keymap("n", "<leader>fc", "<cmd>Telescope colorscheme<cr>", { desc = "Colorschemes" })

-- LSP references
keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })

-- LSP definitions
keymap("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Definitions" })

-- LSP implementations
keymap("n", "gi", "<cmd>Telescope lsp_implementations<cr>", { desc = "Implementations" })

-- LSP type definitions
keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Type Definitions" })

-- LSP document symbols
keymap("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })

-- LSP workspace symbols
keymap("n", "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace Symbols" })

-- LSP diagnostics
keymap("n", "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Document Diagnostics" })

-- === Neo-tree Keymaps ===

-- Toggle file tree
keymap("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neo-tree" })

-- Show file tree
keymap("n", "<leader>E", "<cmd>Neotree reveal<cr>", { desc = "Reveal in Neo-tree" })

-- Git status
keymap("n", "<leader>gg", "<cmd>Neotree git_status<cr>", { desc = "Git Status" })

-- Buffers
keymap("n", "<leader>be", "<cmd>Neotree buffers<cr>", { desc = "Buffers" })

-- === Terminal Keymaps ===

-- Toggle terminal
keymap("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })

-- Terminal in horizontal split
keymap("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Terminal Horizontal" })

-- Terminal in vertical split
keymap("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Terminal Vertical" })

-- Terminal in floating window
keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Terminal Float" })

-- === Git Keymaps ===

-- Git blame
keymap("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Git Blame" })

-- Git browse
keymap("n", "<leader>go", "<cmd>GBrowse<cr>", { desc = "Git Browse" })

-- Git diff
keymap("n", "<leader>gd", "<cmd>Git diff<cr>", { desc = "Git Diff" })

-- === Comment Keymaps ===

-- Toggle comment (linedifferent)
keymap("n", "gc", "<cmd>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<cr>", { desc = "Toggle Comment" })

-- Toggle block comment
keymap("n", "gb", "<cmd>lua require('Comment.api').toggle_blockwise_op(vim.fn.visualmode())<cr>", { desc = "Toggle Block Comment" })

-- === Misc Keymaps ===

-- Toggle spell check
keymap("n", "<leader>us", "<cmd>set spell!<cr>", { desc = "Toggle Spell Check" })

-- Toggle wrap
keymap("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Toggle Line Wrap" })

-- Center screen when scrolling
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)

-- Center screen when searching
keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)

-- Stay in visual mode when indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- === Which-Key ===

-- Show which-key popup
keymap("n", "<leader>", "<cmd>WhichKey '<leader>'<cr>", { desc = "WhichKey" })

-- Visual mode which-key
keymap("v", "<leader>", "<cmd>WhichKeyVisual '<leader>'<cr>", { desc = "WhichKey Visual" })

-- === OS-specific keymaps will be layered on top ===
-- source: editors/neovim/os/$(detect-os)/keymaps.lua
