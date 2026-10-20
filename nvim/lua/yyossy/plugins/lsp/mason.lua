-- LSPサーバー以外のツール(formatter/linter)のインストール
-- LSPサーバーのインストールと有効化はlspconfig.luaで行う
return {
  "williamboman/mason.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        "eslint_d", -- js/ts linter
        "markdownlint",
        "prettier", -- prettier formatter
        "ruff", -- python linter/formatter (LSPとしても使う)
        "stylua", -- lua formatter
        "shellcheck", -- shell linter
        "shfmt", -- shell formatter
        "xmlformatter",
      },
    })
  end,
}
