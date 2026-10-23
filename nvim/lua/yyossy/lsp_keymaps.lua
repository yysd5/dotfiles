-- プラグインとして認識されないようにpluginsディレクトリと
-- lsp_keymaps.luaを同階層に配置

local M = {}

function M.setup_lsp_keymaps(bufnr)
  local opts = { buffer = bufnr, silent = true }

  opts.desc = "Show LSP references"
  vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

  opts.desc = "Go to declaration"
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

  opts.desc = "Show LSP definitions"
  vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

  opts.desc = "Show LSP implementations"
  vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

  opts.desc = "Show LSP type definitions"
  vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

  -- TODO: テストに移動 gN割り当てる

  opts.desc = "See available code actions"
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

  opts.desc = "Smart rename"
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

  opts.desc = "Show line diagnostics"
  vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)

  opts.desc = "Show buffer diagnostics"
  vim.keymap.set("n", "<leader>cD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

  opts.desc = "Go to previous diagnostic"
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, opts)

  opts.desc = "Go to next diagnostic"
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, opts)

  opts.desc = "Hover documentation"
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover({ border = "double" })
  end, opts)

  opts.desc = "Restart LSP"
  vim.keymap.set("n", "<leader>cR", "<cmd>LspRestart<CR>", opts)
end

return M
