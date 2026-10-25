-- Automatic session management is great for auto saving sessions before exiting Neovim and getting back to work when you come back.

return {
  "rmagatti/auto-session",
  lazy = false, -- Load immediately when Neovim starts (no lazy loading)
  opts = {
    auto_save = true,
    auto_restore = true,
    cwd_change_handling = true, -- Enable session management when changing directories
    post_restore_cmds = {
      function()
        require("nvim-tree.api").tree.open({ focus = false })
      end,
    },
  },
  keys = {
    { "<leader>wr", "<cmd>SessionRestore<CR>", desc = "Restore session for cwd" }, -- restore last workspace session for current directory
    { "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session for auto session root dir" }, -- save workspace session for current working directory
  },
}
