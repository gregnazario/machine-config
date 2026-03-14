-- Neovim Plugins Configuration
-- Base configuration for all operating systems
-- Using Lazy.nvim plugin manager

return {
  -- === Core Plugins ===

  -- Lazy.nvim (plugin manager)
  {
    "folke/lazy.nvim",
    version = "*",
    opts = {},
  },

  -- === UI ===

  -- Dracula theme
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    config = function()
      require("dracula").setup({
        -- customize dracula color palette
        colors = {
          bg = "#282A36",
          fg = "#F8F8F2",
          selection = "#44475A",
          comment = "#6272A4",
          red = "#FF5555",
          orange = "#FFB86C",
          yellow = "#F1FA8C",
          green = "#50FA7B",
          purple = "#BD93F9",
          cyan = "#8BE9FD",
          pink = "#FF79C6",
        },
        -- show the '~' characters after the end of lines
        show_end_of_buffer = true,
        -- transparent the background
        transparent_bg = false,
        -- lualine integration
        lualine_bg_color = "#44475a",
        -- overrides
        overrides = {},
      })
      vim.cmd.colorscheme("dracula")
    end,
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    enabled = vim.g.have_nerd_font,
    opts = {},
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "dracula",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        numbers = "none",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = { style = "icon", icon = "▎" },
        buffer_close_icon = "󰅖",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 18,
        truncate_names = true,
        tab_size = 18,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
          },
          {
            filetype = "toggleterm",
            text = "Terminal",
            text_align = "left",
            separator = true,
          },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        persist_buffer_sort = true,
        separator_style = "slant",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
      },
    },
    keys = {
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
    },
  },

  -- === File Explorer ===

  -- Neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
      { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal in Neo-tree" },
      { "<leader>be", "<cmd>Neotree buffers<cr>", desc = "Buffers" },
      { "<leader>ge", "<cmd>Neotree git_status<cr>", desc = "Git status" },
    },
    opts = {
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
      sort_case_insensitive = false,
      sort_function = nil,
      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          with_expanders = nil,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "󰜌",
          default = "*",
          highlight = "NeoTreeFileIcon",
        },
        modified = {
          symbol = "[+]",
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
        },
        git_status = {
          symbols = {
            added = "",
            modified = "",
            deleted = "",
            renamed = "",
            untracked = "?",
            ignored = "",
            unstaged = "",
            staged = "S",
            conflict = "",
          },
        },
      },
      window = {
        position = "left",
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = false,
          hide_by_name = {
            ".DS_Store",
            "thumbs.db",
          },
          never_show = {},
        },
        follow_current_file = {
          enabled = false,
          leave_dirs_open = false,
        },
        group_empty_dirs = false,
        use_libuv_file_watcher = false,
      },
      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        group_empty_dirs = true,
        show_unloaded = true,
      },
      git_status = {
        window = {
          position = "float",
        },
      },
    },
  },

  -- === Fuzzy Finder ===

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git files" },
      { "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Grep word" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Old files" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fm", "<cmd>Telescope man_pages<cr>", desc = "Man pages" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
    },
    config = function()
      require("telescope").load_extension("fzf")
    end,
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        file_ignore_patterns = { "node_modules" },
        generic_sorter = require("telescope.sorters").get_fzy_sorter,
        file_sorter = require("telescope.sorters").get_fzy_sorter,
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    },
  },

  -- === LSP ===

  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      require("config.lsp").setup()
    end,
  },

  -- Mason (LSP installer)
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "rust-analyzer",
        "typescript-language-server",
        "pyright",
        "ruff-lsp",
        "yaml-language-server",
        "yamlfmt",
        "yamllint",
        "json-lsp",
        "jsonlint",
        "go-language-server",
        "gopls",
        "gofumpt",
        "goimports-reviser",
        "gomodifytags",
        "impl",
        "delve",
        "html-lsp",
        "css-language-server",
        "eslint-lsp",
        "prettierd",
        "tailwindcss-language-server",
        "terraform-ls",
        "tflint",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "bash-language-server",
        "shfmt",
        "shellcheck",
        "markdownlint",
        "marksman",
        "taplo",
        "typos",
        "write-good",
        "vale",
      },
    },
  },

  -- mason-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "ts_ls",
          "pyright",
          "ruff_lsp",
          "yamlls",
          "jsonls",
          "gopls",
          "html",
          "cssls",
          "eslint",
          "tailwindcss",
          "terraformls",
          "dockerls",
          "docker_compose_language_service",
          "bashls",
          "marksman",
          "taplo",
          "typos_lsp",
        },
      })
    end,
  },

  -- null-ls (formatters and linters)
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          -- Python
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.ruff,
          null_ls.builtins.diagnostics.ruff,
          null_ls.builtins.diagnostics.mypy,

          -- Rust
          null_ls.builtins.formatting.rustfmt,

          -- TypeScript/JavaScript
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.diagnostics.eslint_d,

          -- Go
          null_ls.builtins.formatting.gofumpt,
          null_ls.builtins.formatting.goimports_reviser,
          null_ls.builtins.code_actions.gomodifytags,
          null_ls.builtins.diagnostics.revive,

          -- YAML
          null_ls.builtins.formatting.yamlfmt,
          null_ls.builtins.diagnostics.yamllint,
          null_ls.builtins.code_actions.gitrebase,

          -- JSON
          null_ls.builtins.diagnostics.jsonlint,

          -- Shell
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.diagnostics.shellcheck,

          -- Markdown
          null_ls.builtins.diagnostics.markdownlint,
          null_ls.builtins.diagnostics.vale,

          -- Spelling
          null_ls.builtins.code_actions.proselint,
          null_ls.builtins.diagnostics.alex,
          null_ls.builtins.diagnostics.write_good,

          -- General
          null_ls.builtins.code_actions.gitrebase,
          null_ls.builtins.diagnostics.trail_spaces,
        },
      })
    end,
  },

  -- === Completion ===

  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Snippets
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Completion sources
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(entry, vim_item)
            vim_item.kind = string.format("%s %s", require("lspkind").get_symbol(vim_item.kind), vim_item.kind)
            return vim_item
          end,
        },
      }
    end,
  },

  -- === Treesitter ===

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "toml",
        "typescript",
        "yaml",
        "vim",
        "vimdoc",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
    },
  },

  -- === Git Integration ===

  -- gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      watch_gitdir = true,
      auto_attach = true,
      attach_to_untracked = true,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        border = "single",
        style = "minimal",
        relative = false,
      },
      yadm = { enable = false },
    },
  },

  -- fugitive
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    keys = {
      { "<leader>gg", "<cmd>Git<cr>", desc = "Git" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
      { "<leader>gd", "<cmd>Gdiff<cr>", desc = "Git diff" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
      { "<leader>gP", "<cmd>Git pull<cr>", desc = "Git pull" },
    },
  },

  -- === Utilities ===

  -- Comment.nvim
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Comment toggle" },
      { "gb", mode = { "n", "v" }, desc = "Comment block" },
    },
    opts = {
      toggler = {
        line = "gcc",
        block = "gbc",
      },
      opleader = {
        line = "gc",
        block = "gb",
      },
      extra = {
        above = "gcO",
        below = "gco",
        eol = "gcA",
      },
    },
  },

  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Debug" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
        { "<leader>q", group = "Quit/Session" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Toggle" },
        { "<leader>w", group = "Window" },
        { "<leader>x", group = " diagnostics" },
      },
    },
    keys = {
      { "<leader>", "", desc = "<leader>" },
      { "<leader>?", desc = "Which Key" },
    },
  },

  -- toggleterm
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal horizontal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Terminal vertical" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal float" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<leader>tt]],
      direction = "float",
      float_opts = {
        border = "rounded",
      },
    },
  },

  -- === Auto-pairs ===

  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
  },

  -- === Indent guides ===

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },

  -- === Startup screen ===

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("alpha").setup(require("alpha.themes.dashboard").config)
    end,
  },

  -- === Notifications ===

  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#1e1e2e",
      level = "INFO",
      minimum_width = 50,
      render = "default",
      stages = "fade",
      timeout = 3000,
      top_down = true,
    },
  },

  -- === Indentation ===

  {
    "Darazaki/indent-o-matic",
    event = "VeryLazy",
    opts = {},
  },

  -- === Zen mode ===

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen mode" } },
    opts = {},
  },

  -- === OS-specific plugins will be added in OS configs ===
  -- source: editors/neovim/os/$(detect-os)/plugins.lua
}
