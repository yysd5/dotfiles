return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("illuminate").configure({
      -- nvim-treesitter(main)にはlocalsが無いのでtreesitterは使わない
      providers = { "lsp", "regex" },
      delay = 200,
      filetypes_denylist = { "NvimTree", "TelescopePrompt" },
      under_cursor = true,
    })
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#3c3836", underline = true })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#3c3836", underline = true })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#3c3836", underline = true })
  end,
}
