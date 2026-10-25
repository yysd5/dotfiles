return {
  "tomasky/bookmarks.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  event = "VimEnter",
  config = function()
    local bookmarks = require("bookmarks")

    bookmarks.setup({
      -- サインカラム表示設定
      sign_priority = 8,

      -- 保存設定
      save_file = vim.fn.expand("$HOME/.cache/bookmarks"),

      -- キーワード設定
      keywords = {
        ["@t"] = "☑️ ", -- TODO
        ["@w"] = "⚠️ ", -- WARN
        ["@f"] = "⛏ ", -- FIX
        ["@n"] = "📓 ", -- NOTE
      },

      -- サインの表示設定
      on_attach = function(bufnr)
        -- バッファが有効かチェック
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        local bm = require("bookmarks")
        local map = vim.keymap.set

        map("n", "mm", bm.bookmark_toggle, { buffer = bufnr, desc = "Toggle bookmark" })
        map("n", "mi", bm.bookmark_ann, { buffer = bufnr, desc = "Add/Edit bookmark annotation" })
        map("n", "mc", bm.bookmark_clean, { buffer = bufnr, desc = "Clean bookmarks in buffer" })
        map("n", "mn", bm.bookmark_next, { buffer = bufnr, desc = "Next bookmark" })
        map("n", "mp", bm.bookmark_prev, { buffer = bufnr, desc = "Previous bookmark" })
        map("n", "ml", bm.bookmark_list, { buffer = bufnr, desc = "List bookmarks" })
        map("n", "mx", bm.bookmark_clear_all, { buffer = bufnr, desc = "Clear all bookmarks" })
      end,
    })

    -- Telescopeとの統合
    require("telescope").load_extension("bookmarks")

    -- グローバルキーマッピング
    local keymap = vim.keymap
    keymap.set("n", "<leader>ml", "<cmd>Telescope bookmarks list<cr>", { desc = "Bookmarks: List all" })
    keymap.set("n", "<leader>ma", require("bookmarks").bookmark_ann, { desc = "Bookmarks: Add annotation" })
    keymap.set("n", "<leader>mc", require("bookmarks").bookmark_clean, { desc = "Bookmarks: Clean buffer" })
    keymap.set("n", "<leader>mm", require("bookmarks").bookmark_toggle, { desc = "Bookmarks: Toggle" })
    keymap.set("n", "<leader>mx", require("bookmarks").bookmark_clear_all, { desc = "Bookmarks: Clear all" })
  end,
}
