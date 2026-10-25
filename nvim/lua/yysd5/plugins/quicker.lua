-- https://github.com/stevearc/quicker.nvim
return {
  "stevearc/quicker.nvim",
  event = "FileType qf",
  keys = {
    {
      "<leader>qq",
      function()
        require("quicker").toggle()
      end,
      desc = "Toggle quickfix",
    },
    {
      "<leader>ql",
      function()
        require("quicker").toggle({ loclist = true })
      end,
      desc = "Toggle loclist",
    },
  },
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {},
  config = function(_, opts)
    local quicker = require("quicker")
    quicker.setup(opts)
    vim.keymap.set("n", ">", function()
      quicker.expand({ before = 2, after = 2, add_to_existing = true })
    end, {
      desc = "Expand quickfix context",
    })
    vim.keymap.set("n", "<", function()
      quicker.collapse()
    end, {
      desc = "Collapse quickfix context",
    })
  end,
}
