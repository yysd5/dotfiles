-- CIでtreesitterパーサーを同期インストールするスクリプト
-- 使い方: nvim --headless -c "luafile .github/scripts/nvim-ts-install.lua"
-- 通常の起動時は非同期インストールなので、終了前に完了しない

local plugin = require("lazy.core.config").plugins["nvim-treesitter"]
local opts = require("lazy.core.plugin").values(plugin, "opts", false)
local ok = require("nvim-treesitter").install(opts.ensure_installed, { summary = true }):wait(1800000)
if not ok then
  io.stderr:write("treesitter parser install FAILED\n")
  vim.cmd("cquit 1")
end
vim.cmd("qall!")
