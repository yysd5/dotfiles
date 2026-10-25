-- https://github.com/ThePrimeagen/refactoring.nvim
-- 操作はoperator(g@)として提供されるので、expr mapでモーションを続ける
return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "lewis6991/async.nvim", -- Neovim 0.12では必要(0.13以降は不要)
  },
  lazy = false,
  config = function()
    local keymap = vim.keymap
    local debug = function()
      return require("refactoring.debug")
    end

    keymap.set({ "n", "x" }, "<leader>rr", function()
      require("refactoring").select_refactor()
    end, { desc = "Refactor: Select refactor" })

    keymap.set("n", "<leader>rp", function()
      return debug().print_loc({ output_location = "below" })
    end, { expr = true, desc = "Refactor: Insert debug print (below)" })

    keymap.set("n", "<leader>rv", function()
      return debug().print_var({ output_location = "below" }) .. "iw"
    end, { expr = true, desc = "Refactor: Print variable" })
    keymap.set("x", "<leader>rv", function()
      return debug().print_var({ output_location = "below" })
    end, { expr = true, desc = "Refactor: Print variable" })

    -- ノーマルモードではバッファ全体を対象にする
    keymap.set("n", "<leader>rc", function()
      vim.cmd.normal({ "gg" .. debug().cleanup({ restore_view = true }) .. "G", bang = true })
    end, { desc = "Refactor: Cleanup debug statements" })
    keymap.set("x", "<leader>rc", function()
      return debug().cleanup({ restore_view = true })
    end, { expr = true, desc = "Refactor: Cleanup debug statements" })
  end,
}
