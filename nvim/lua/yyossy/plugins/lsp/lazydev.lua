-- nvim設定のLuaを編集するときに、lua_lsへNeovimのAPIやプラグインの型を教える
-- (アーカイブされたneodev.nvimの後継)
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- vim.uvの型
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
