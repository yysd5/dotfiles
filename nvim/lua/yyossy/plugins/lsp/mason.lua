return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      -- https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
      ensure_installed = {
        "ansiblels",
        "bashls",
        "clangd",
        "cmake",
        "docker_compose_language_service",
        "dockerls",
        "gopls",
        -- "groovyls",
        "html",
        "jdtls", -- java: nvim-jdtlsを使うのでこちらはコメントアウト
        "jsonls",
        "lua_ls",
        -- "ltex", -- reStructuredText
        "nginx_language_server",
        "pyright", -- python
        "rust_analyzer",
        "sqls",
        "terraformls", -- terraform lsp
        "tflint", -- terraform linter
        "ts_ls", -- javascript/typescript
      },
      automatic_installation = true, -- Automatically install missing servers
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "eslint_d", -- js/ts linter
        "markdownlint",
        "prettier", -- prettier formatter
        "ruff", -- python linter/formatter
        "stylua", -- lua formatter
        "shellcheck", -- shell linter
        "shfmt", -- shell formatter
        "xmlformatter",
      },
    })
  end,
}
