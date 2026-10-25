-- Treesitterのパーサー管理(mainブランチ)
-- ハイライトとfoldはNeovim標準の機能を使い、FileTypeで有効化する。
-- パーサーのビルドにはtree-sitter-cli(brew)とCコンパイラが必要

-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
local parsers = {
  "bash",
  "c",
  "cpp",
  "cmake",
  "css",
  "dockerfile",
  "go",
  "gomod",
  "groovy",
  "gitignore",
  "html",
  "json",
  "javascript",
  "jsdoc",
  "jinja",
  "julia",
  "java",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "nginx",
  "python",
  "query",
  "rust",
  "sql",
  "terraform",
  "typescript",
  "tsx",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- mainブランチは遅延読み込みに非対応
  build = ":TSUpdate",
  -- ensure_installedはnvim-treesitterの設定ではなく、下のconfigで使う独自キー
  -- (CIで同期インストールするときにも参照する)
  opts = { ensure_installed = parsers },
  config = function(_, opts)
    -- インストール済みなら何もしない(非同期)
    require("nvim-treesitter").install(opts.ensure_installed)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("UserTreesitter", {}),
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if not lang or not vim.treesitter.language.add(lang) then
          return
        end
        vim.treesitter.start(ev.buf, lang)
        if vim.treesitter.query.get(lang, "indents") then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- インクリメンタル選択(Neovim 0.12標準のv_an/v_inに割り当てる)
    vim.keymap.set("n", "<C-space>", "van", { remap = true, desc = "Start treesitter node selection" })
    vim.keymap.set("x", "<C-space>", "an", { remap = true, desc = "Expand selection to parent node" })
    vim.keymap.set("x", "<bs>", "in", { remap = true, desc = "Shrink selection to child node" })
  end,
}
