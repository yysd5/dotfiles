-- LSPの設定
-- 各サーバーの既定設定はnvim-lspconfigのlsp/*.luaが提供し、
-- ここではvim.lsp.config()で上書きだけを行う。
-- masonでインストール済みのサーバーはmason-lspconfigがvim.lsp.enable()する
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },

  dependencies = {
    "williamboman/mason.nvim", -- LSP/DAP/Linter installer UI
    "williamboman/mason-lspconfig.nvim", -- mason ↔ vim.lsp.enable bridge (v2.x)
    "hrsh7th/cmp-nvim-lsp", -- LSP completion capabilities
    { "antosha417/nvim-lsp-file-operations", config = true }, -- auto-refresh on rename/move
  },

  config = function()
    ---------------------------------------------------------------------------
    -- Diagnostics
    ---------------------------------------------------------------------------
    local severity = vim.diagnostic.severity
    vim.diagnostic.config({
      signs = {
        text = {
          [severity.ERROR] = "✖ ",
          [severity.WARN] = "⚠ ",
          [severity.HINT] = "⚑ ",
          [severity.INFO] = "ℹ ",
        },
      },
      float = { border = "double" },
    })

    ---------------------------------------------------------------------------
    -- Common settings for every server
    ---------------------------------------------------------------------------
    vim.lsp.config("*", {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })

    ---------------------------------------------------------------------------
    -- Per-server customisations
    ---------------------------------------------------------------------------
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          completion = { callSnippet = "Replace" },
        },
      },
    })

    vim.lsp.config("pyright", {
      -- 絶対importを解決するため、最寄りの.gitをrootにする
      -- (root_markersはリストが要素ごとにマージされるのでroot_dirで指定する)
      root_dir = function(bufnr, on_dir)
        on_dir(vim.fs.root(bufnr, ".git") or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
      end,
    })

    ---------------------------------------------------------------------------
    -- Buffer-local keymaps when the LSP attaches
    ---------------------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        -- Pythonのhoverはpyrightに任せる(ruffとの重複表示を避ける)
        if client and client.name == "ruff" then
          client.server_capabilities.hoverProvider = false
        end
        require("yyossy.lsp_keymaps").setup_lsp_keymaps(ev.buf)
      end,
    })

    ---------------------------------------------------------------------------
    -- Install servers and enable installed ones
    ---------------------------------------------------------------------------
    require("mason-lspconfig").setup({
      -- https://github.com/mason-org/mason-lspconfig.nvim#available-lsp-servers
      ensure_installed = {
        "ansiblels",
        "bashls",
        "clangd",
        "cmake",
        "docker_compose_language_service",
        "dockerls",
        "gopls",
        "html",
        "jsonls",
        "lua_ls",
        "nginx_language_server",
        "pyright", -- python (型チェック)
        "ruff", -- python (lint/コードアクション)
        "rust_analyzer",
        "sqls",
        "terraformls", -- terraform lsp
        "tflint", -- terraform linter
        "ts_ls", -- javascript/typescript
      },
      automatic_enable = true,
    })
  end,
}
