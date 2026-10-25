-- Which-key is great for seeing what keymaps you can use.

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 1000
  end,
  opts = {
    -- <leader>のprefixごとのグループ名
    spec = {
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>gd", group = "Git diff (Diffview)" },
      { "<leader>h", group = "Git hunk" },
      { "<leader>c", group = "Code" },
      { "<leader>r", group = "Refactor" },
      { "<leader>w", group = "Window / Session" },
      { "<leader><Tab>", group = "Tab" },
      { "<leader>t", group = "Toggle" },
      { "<leader>q", group = "Quickfix" },
      { "<leader>x", group = "Trouble" },
      { "<leader>m", group = "Bookmark" },
      { "<leader>e", group = "Explorer" },
      { "<leader>n", group = "No highlight" },
    },
  },
}
