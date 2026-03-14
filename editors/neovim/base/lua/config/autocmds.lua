-- Neovim Autocmds
-- Base configuration for all operating systems

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- === General Autocmds ===

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
  desc = "Highlight yanked text",
})

-- Resize splits if window gets resized
autocmd("VimResized", {
  group = augroup("ResizeSplits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
  desc = "Resize splits when window is resized",
})

-- Go to last loc when opening a buffer
autocmd("BufReadPost", {
  group = augroup("LastLoc", { clear = true }),
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Go to last location when opening a buffer",
})

-- Check if we need to reload the file when it changed
autocmd("FocusGained", {
  group = augroup("CheckFile", { clear = true }),
  callback = function()
    vim.cmd("checktime")
  end,
  desc = "Check for file changes",
})

-- Close some filetypes with <q>
autocmd("FileType", {
  group = augroup("CloseWithQ", { clear = true }),
  pattern = {
    "qf",
    "help",
    "man",
    "lspinfo",
    "spectre_panel",
    "lir",
    "DressingSelect",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Close buffer",
    })
  end,
  desc = "Close certain filetypes with q",
})

-- === Filetype-specific Autocmds ===

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group = augroup("TrimWhitespace", { clear = true }),
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Remove trailing whitespace on save",
})

-- Auto place undo breakpoints
autocmd("BufWritePre", {
  group = augroup("UndoBreakpoints", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.api.nvim_get_option_value("modifiable", { buf = 0 }) then
      vim.cmd([[undojoin]])
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd([[call feedkeys("\<Esc>", "n")]])
      vim.api.nvim_win_set_cursor(0, pos)
    end
  end,
  desc = "Create undo breakpoints",
})

-- === EditorConfig ===

autocmd("BufRead", {
  group = augroup("EditorConfig", { clear = true }),
  callback = function()
    vim.cmd("EditorConfigReload")
  end,
  desc = "Load EditorConfig",
})

-- === LSP Autocmds ===

-- Format on save
autocmd("BufWritePre", {
  group = augroup("LspFormat", { clear = true }),
  callback = function()
    vim.lsp.buf.format({
      timeout_ms = 2000,
      filter = function(client)
        return client.name == "null-ls" or client.name == "rust-analyzer" or client.name == "ruff_lsp"
      end,
    })
  end,
  desc = "Format on save",
})

-- Show diagnostic float on cursor hold
autocmd("CursorHold", {
  group = augroup("LspCursorHold", { clear = true }),
  callback = function()
    local diagnostics = vim.diagnostic.get(0)
    if #diagnostics > 0 then
      vim.diagnostic.open_float({
        scope = "cursor",
        focusable = false,
        close_events = {
          "BufLeave",
          "CursorMoved",
          "InsertEnter",
        },
      })
    end
  end,
  desc = "Show diagnostic float on cursor hold",
})

-- Highlight references under cursor
autocmd("CursorHold", {
  group = augroup("LspDocumentHighlight", { clear = true }),
  callback = function()
    vim.lsp.buf.document_highlight()
  end,
  desc = "Highlight references under cursor",
})

-- Clear references on cursor move
autocmd({ "CursorMoved", "CursorMovedI" }, {
  group = augroup("LspDocumentHighlightClear", { clear = true }),
  callback = function()
    vim.lsp.buf.clear_references()
  end,
  desc = "Clear references on cursor move",
})

-- === Filetype-specific Settings ===

-- Python
autocmd("FileType", {
  group = augroup("PythonSettings", { clear = true }),
  pattern = "python",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
  desc = "Python settings",
})

-- JavaScript/TypeScript
autocmd("FileType", {
  group = augroup("JSTSSettings", { clear = true }),
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
  desc = "JavaScript/TypeScript settings",
})

-- Rust
autocmd("FileType", {
  group = augroup("RustSettings", { clear = true }),
  pattern = "rust",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
  desc = "Rust settings",
})

-- Lua
autocmd("FileType", {
  group = augroup("LuaSettings", { clear = true }),
  pattern = "lua",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
  desc = "Lua settings",
})

-- YAML
autocmd("FileType", {
  group = augroup("YAMLSettings", { clear = true }),
  pattern = "yaml",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
  desc = "YAML settings",
})

-- Markdown
autocmd("FileType", {
  group = augroup("MarkdownSettings", { clear = true }),
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
  desc = "Markdown settings",
})

-- JSON
autocmd("FileType", {
  group = augroup("JSONSettings", { clear = true }),
  pattern = "json",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
  desc = "JSON settings",
})

-- Go
autocmd("FileType", {
  group = augroup("GoSettings", { clear = true }),
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
  desc = "Go settings",
})

-- HTML/CSS
autocmd("FileType", {
  group = augroup("HTMLCSSSettings", { clear = true }),
  pattern = { "html", "css", "scss", "sass" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
  desc = "HTML/CSS settings",
})

-- Shell scripts
autocmd("FileType", {
  group = augroup("ShellSettings", { clear = true }),
  pattern = { "sh", "bash", "zsh" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
  desc = "Shell script settings",
})

-- === Yazi Integration ===

-- Open yazi in floating window
autocmd("BufEnter", {
  group = augroup("YaziIntegration", { clear = true }),
  callback = function()
    if vim.bo.filetype == "yazi" then
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = 0, silent = true })
    end
  end,
  desc = "Yazi integration",
})

-- === OS-specific autocmds will be layered on top ===
-- source: editors/neovim/os/$(detect-os)/autocmds.lua
