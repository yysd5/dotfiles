return {
  "j-morano/buffer_manager.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local buffer_manager = require("buffer_manager")
    buffer_manager.setup({
      select_menu_item_commands = {
        edit = { key = "<CR>", command = "edit" },
        split = { key = "<C-h>", command = "split" },
        vsplit = { key = "<C-v>", command = "vsplit" },
        delete = { key = "<C-x>", command = "bdelete" },
      },
      line_keys = "1234567890",
      focus_alternate_buffer = false,
      width = 0.9, -- 画面幅の割合(固定列数だと狭い画面ではみ出す)
      height = 30,
      short_file_names = false,
      show_depth = true,
      short_term_names = true,
      loop_nav = true,
      highlight = "",
      win_extra_options = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      format_function = nil,
      order_buffers = nil,
      show_indicators = "before",
    })

    -- Specify a custom color for the modified buffers
    vim.api.nvim_set_hl(0, "BufferManagerModified", { fg = "#B4FFAD" })

    vim.keymap.set("n", "<leader>d", function()
      require("buffer_manager.ui").toggle_quick_menu()
    end, { desc = "Open Buffer Manager" })

    -- https://github.com/j-morano/buffer_manager.nvim?tab=readme-ov-file#reorder-buffers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "buffer_manager",
      callback = function()
        vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { buffer = true })
        vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { buffer = true })
      end,
    })
  end,
}
