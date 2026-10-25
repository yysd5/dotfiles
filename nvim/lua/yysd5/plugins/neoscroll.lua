-- https://github.com/karb94/neoscroll.nvim
return {
  "karb94/neoscroll.nvim",
  config = function()
    local neoscroll = require("neoscroll")

    neoscroll.setup({
      easing = "quadratic",
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      performance_mode = true,
    })

    local keymap = {
      ["<C-u>"] = function()
        neoscroll.ctrl_u({ duration = 150, easing = "sine" })
      end,
      ["<C-d>"] = function()
        neoscroll.ctrl_d({ duration = 150, easing = "sine" })
      end,
      ["<C-b>"] = function()
        neoscroll.ctrl_b({ duration = 300, easing = "circular" })
      end,
      ["<C-f>"] = function()
        neoscroll.ctrl_f({ duration = 300, easing = "circular" })
      end,
    }

    local modes = { "n", "v", "x" }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func, { silent = true })
    end

    -- C-e / C-y default behavior(Scrolling 1 line)
    vim.keymap.set("n", "<C-e>", "<C-e>", { noremap = true, silent = true })
    vim.keymap.set("n", "<C-y>", "<C-y>", { noremap = true, silent = true })
  end,
}
