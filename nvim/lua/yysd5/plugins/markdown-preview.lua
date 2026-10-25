-- https://github.com/iamcco/markdown-preview.nvim
-- install with yarn or npm
return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && npm install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_auto_close = 0 -- Keep browser preiview tab open when closing markdown buffer
  end,
  keys = {
    { "<leader>cp", "<cmd>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "Markdown Preview Toggle" },
  },
}
