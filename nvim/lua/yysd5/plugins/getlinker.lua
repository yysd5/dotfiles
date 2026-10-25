return {
  "ruifm/gitlinker.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("gitlinker").setup({
      opts = {
        remote = nil, -- force the use of a specific remote
        -- adds current line nr in the url for normal mode
        add_current_line_on_normal_mode = true,
        -- callback for what to do with the url
        action_callback = require("gitlinker.actions").copy_to_clipboard,
        -- print the url after performing the action
        print_url = true,
      },
      callbacks = {
        ["github.com"] = require("gitlinker.hosts").get_github_type_url,
        ["bitbucket.org"] = require("gitlinker.hosts").get_bitbucket_type_url,
      },
      mappings = nil, -- disable the default mapping
    })

    -- Normal mode: copy link for current line
    vim.keymap.set("n", "<leader>gy", function()
      require("gitlinker").get_buf_range_url("n")
    end, { desc = "Copy link for current line" })

    -- Visual mode: copy link for selected lines
    vim.keymap.set("v", "<leader>gy", function()
      require("gitlinker").get_buf_range_url("v")
    end, { desc = "Copy link for selected lines" })
  end,
}
