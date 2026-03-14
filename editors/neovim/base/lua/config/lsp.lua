-- LSP Configuration
-- Base configuration for all operating systems

local M = {}

-- LSP server mappings
M.lsp_servers = {
  -- TypeScript/JavaScript
  ts_ls = {
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    settings = {
      typescript = {
        format = {
          enable = false,
        },
      },
      javascript = {
        format = {
          enable = false,
        },
      },
    },
  },

  -- Python
  pyright = {
    filetypes = { "python" },
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
      },
    },
  },

  -- Rust
  rust_analyzer = {
    filetypes = { "rust" },
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          features = "all",
        },
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },

  -- Lua
  lua_ls = {
    filetypes = { "lua" },
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          },
        },
        telemetry = { enable = false },
      },
    },
  },

  -- Go
  gopls = {
    filetypes = { "go", "gomod" },
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },

  -- YAML
  yamlls = {
    filetypes = { "yaml", "yaml.docker-compose" },
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
          ["https://json.schemastore.org/docker-compose.yml"] = "docker-compose.yml",
        },
      },
    },
  },

  -- JSON
  jsonls = {
    filetypes = { "json", "jsonc" },
    settings = {
      json = {
        schemas = {
          {
            description = "TypeScript compiler configuration",
            fileMatch = { "tsconfig.json", "tsconfig.*.json" },
            url = "https://json.schemastore.org/tsconfig.json",
          },
        },
      },
    },
  },

  -- HTML
  html = {
    filetypes = { "html" },
  },

  -- CSS
  cssls = {
    filetypes = { "css", "scss" },
  },

  -- Tailwind CSS
  tailwindcss = {
    filetypes = { "html", "javascriptreact", "typescriptreact" },
  },

  -- Bash
  bashls = {
    filetypes = { "sh", "bash" },
  },

  -- Markdown
  marksman = {
    filetypes = { "markdown", "markdown.mdx" },
  },

  -- Terraform
  terraformls = {
    filetypes = { "terraform", "tf" },
  },

  -- Docker
  dockerls = {
    filetypes = { "dockerfile" },
  },

  docker_compose_language_service = {
    filetypes = { "docker-compose.yml" },
  },

  -- Ruff (Python linter/formatter)
  ruff_lsp = {
    filetypes = { "python" },
    init_options = {
      settings = {
        args = {},
      },
    },
  },
}

-- LSP keybindings
M.lsp_keybindings = {
  -- Go to definition
  { "n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" } },
  { "n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" } },
  { "n", "gr", vim.lsp.buf.references, { desc = "Go to references" } },
  { "n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" } },
  { "n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" } },

  -- Hover
  { "n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" } },
  { "n", "gK", vim.lsp.buf.signature_help, { desc = "Signature help" } },

  -- Actions
  { "n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" } },
  { "n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" } },
  { "n", "<leader>cf", vim.lsp.buf.format, { desc = "Format document" } },

  -- Diagnostics
  { "n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" } },
  { "n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" } },
  { "n", "<leader>e", vim.diagnostic.open_float, { desc = "Open diagnostic float" } },
  { "n", "<leader>q", vim.diagnostic.setloclist, { desc = "Add to location list" } },
}

-- LSP capabilities
M.lsp_capabilities = {
  textDocument = {
    completion = {
      completionItem = {
        snippetSupport = true,
        commitCharactersSupport = true,
        deprecatedSupport = true,
        tagSupport = { valueSet = { 1 } },
      },
    },
    hover = {
      contentFormat = { "markdown", "plaintext" },
    },
    signatureHelp = {
      signatureInformation = {
        activeParameterSupport = true,
      },
      documentationFormat = { "markdown", "plaintext" },
    },
  },
}

-- Common LSP on_attach function
M.on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Buffer local mappings
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local opts = { noremap = true, silent = true }

  -- LSP keybindings
  local keybindings = M.lsp_keybindings
  for _, binding in ipairs(keybindings) do
    local mode, lhs, rhs, opts = unpack(binding)
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- Disable formatting for some LSPs (use null-ls instead)
  if client.name == "tsserver" or client.name == "html" or client.name == "cssls" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  -- Enable inlay hints for Rust
  if client.name == "rust_analyzer" then
    if vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(bufnr, true)
    end
  end
end

-- Setup LSP servers
M.setup = function()
  -- Load lspconfig
  local lspconfig = require("lspconfig")

  -- Setup each LSP server
  for server_name, server_config in pairs(M.lsp_servers) do
    local opts = {
      on_attach = M.on_attach,
      capabilities = M.lsp_capabilities,
      settings = server_config.settings,
      filetypes = server_config.filetypes,
      init_options = server_config.init_options,
    }
    lspconfig[server_name].setup(opts)
  end

  -- LSP diagnostics configuration
  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
      spacing = 2,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "✗",
        [vim.diagnostic.severity.WARN] = "!",
        [vim.diagnostic.severity.INFO] = "i",
        [vim.diagnostic.severity.HINT] = "?",
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })
end

return M
