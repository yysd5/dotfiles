-- 補完(blink.cmp)
-- キー操作はnvim-cmp時代のものを再現している
return {
  "saghen/blink.cmp",
  version = "1.*", -- リリース版を使うとビルド済みのRust製fuzzy matcherが入る
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" },
      config = function()
        local luasnip = require("luasnip")
        -- friendly-snippetsのドキュメントコメント用スニペットを有効にする
        -- (lazy_loadより前に行う必要がある)
        -- https://github.com/rafamadriz/friendly-snippets/issues/350
        luasnip.filetype_extend("cpp", { "cppdoc" })
        luasnip.filetype_extend("java", { "javadoc" })
        luasnip.filetype_extend("javascript", { "jsdoc" })
        luasnip.filetype_extend("lua", { "luadoc" })
        luasnip.filetype_extend("python", { "pydoc" })
        luasnip.filetype_extend("rust", { "rustdoc" })
        luasnip.filetype_extend("shell", { "shelldoc" })
        luasnip.filetype_extend("typescript", { "tsdoc" })
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
  opts = {
    keymap = {
      preset = "none",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "cancel", "fallback" },
      -- 候補を選んだときだけ確定し、未選択なら通常の改行
      ["<CR>"] = { "accept", "fallback" },
      ["<C-y>"] = { "accept", "fallback" },
      -- スニペットのプレースホルダ間を移動する
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
    completion = {
      -- 最初は何も選択せず、選択した候補はその場で挿入する
      list = { selection = { preselect = false, auto_insert = true } },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    snippets = { preset = "luasnip" },
    sources = {
      default = { "lazydev", "lsp", "snippets", "buffer", "path" },
      providers = {
        -- nvim設定のLua用(lazydev.nvim)
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
      },
    },
    -- コマンドラインの補完はNeovim標準のままにする
    cmdline = { enabled = false },
  },
}
