-- Neovim Configuration
-- LazyVim-style setup with Lazy.nvim
-- Base configuration for all operating systems

-- Bootstrap Lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- use latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key to Space (must be done before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load options, autocmds, and keymaps
require("config.options")
require("config.autocmds")
require("config.keymaps")

-- Setup plugins
require("lazy").setup("config.plugins", {
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    missing = true,
    colorscheme = { "dracula" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- OS-specific overrides will be layered on top by installer
-- source: editors/neovim/os/$(detect-os)/init.lua
