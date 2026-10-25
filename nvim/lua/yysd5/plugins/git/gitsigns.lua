return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    current_line_blame = true,
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      map("n", "]h", function()
        gs.nav_hunk("next")
      end, "Next Hunk")
      map("n", "[h", function()
        gs.nav_hunk("prev")
      end, "Prev Hunk")

      -- Actions
      -- ステージ済みのhunkで実行するとステージを取り消す
      map("n", "<leader>hs", gs.stage_hunk, "Stage/unstage hunk")
      map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage hunk")
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset hunk")

      map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
      map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")

      map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")

      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, "Blame line")
      --map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")

      map("n", "<leader>hQ", function()
        gs.setqflist("all")
      end, "Hunks of all files to quickfix")
      map("n", "<leader>hq", gs.setqflist, "Hunks of buffer to quickfix")

      map("n", "<leader>hd", gs.diffthis, "Diff this")
      -- map("n", "<leader>hd", function()
      --   gs.diffthis("~")
      -- end, "Diff this ~")

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
    end,
  },
}
