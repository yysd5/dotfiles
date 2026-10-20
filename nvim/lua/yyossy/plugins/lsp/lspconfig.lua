return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },

  -- Explicit dependencies (lazy.nvim will install & load these first)
  dependencies = {
    "williamboman/mason.nvim", -- LSP/DAP/Linter installer UI
    "williamboman/mason-lspconfig.nvim", -- mason ↔ nvim-lspconfig bridge (v2.x)
    "hrsh7th/cmp-nvim-lsp", -- LSP completion capabilities
    { "antosha417/nvim-lsp-file-operations", config = true }, -- auto-refresh on rename/move
    { "folke/neodev.nvim", opts = {} }, -- better Lua LS for Neovim configs
  },

  config = function()
    ---------------------------------------------------------------------------
    -- Imports
    ---------------------------------------------------------------------------
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap

    ---------------------------------------------------------------------------
    -- Global LSP capabilities (used for every server)
    ---------------------------------------------------------------------------
    local capabilities = cmp_nvim_lsp.default_capabilities()

    ---------------------------------------------------------------------------
    -- Diagnostic signs in the gutter
    ---------------------------------------------------------------------------
    local signs = { Error = "✖ ", Warn = "⚠ ", Hint = "⚑ ", Info = "ℹ " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    ---------------------------------------------------------------------------
    -- Floating-window borders
    ---------------------------------------------------------------------------
    local original_open_floating_preview = vim.lsp.util.open_floating_preview
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "double"
      return original_open_floating_preview(contents, syntax, opts, ...)
    end

    ---------------------------------------------------------------------------
    -- Buffer-local keymaps when the LSP attaches
    ---------------------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        require("yyossy.lsp_keymaps").setup_lsp_keymaps(ev.buf)
      end,
    })

    ---------------------------------------------------------------------------
    -- mason-lspconfig v2.x setup
    ---------------------------------------------------------------------------
    mason_lspconfig.setup({
      -- If you want automatic installation, uncomment ↓
      -- ensure_installed = { "lua_ls", "pyright", "gopls", "rust_analyzer", ... },
      handlers = {
        -- Default handler (executes for *every* installed server)
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,

        -- ---★ Per-server customisations ---------------------------------------------------
        lua_ls = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                completion = { callSnippet = "Replace" },
              },
            },
          })
        end,

        pyright = function()
          lspconfig.pyright.setup({
            capabilities = capabilities,
            -- Use the nearest .git directory as root to resolve absolute imports
            root_dir = lspconfig.util.root_pattern(".git"),
          })
        end,

        --[[ Example: customise SQLs
        sqls = function()
          lspconfig.sqls.setup({
            on_attach = function(client, bufnr)
              require("sqls").on_attach(client, bufnr)
            end,
            capabilities = capabilities,
            settings = {
              sqls = {
                connections = {
                  {
                    driver = "mysql",
                    dataSourceName = "root:root@tcp(127.0.0.1:13306)/world",
                  },
                },
              },
            },
          })
        end,
        ]]
      },
    })
  end,
}
