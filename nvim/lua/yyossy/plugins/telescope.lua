return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim", -- vim.ui.selectをTelescopeで表示する
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        file_ignore_patterns = { "%.git/" }, -- exclude .git directory
        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }, -- exclude .git directory
        path_display = { "absolute" },
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            width = 0.99, -- 画面幅の99%を使用してより広く
            height = 0.90, -- 画面高さの90%を使用
            preview_width = 0.4,
            results_width = 0.6,
          },
        },
        dynamic_preview_title = true, -- 動的プレビュータイトル
        winblend = 0, -- 透明度設定（0=不透明）
        border = true, -- ボーダーを表示
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-d>"] = actions.results_scrolling_down, -- scroll results down
            ["<C-u>"] = actions.results_scrolling_up, -- scroll results up
            ["<C-f>"] = actions.preview_scrolling_down, -- scroll preview down
            ["<C-b>"] = actions.preview_scrolling_up, -- scroll preview up
          },
          n = {
            ["<C-d>"] = actions.results_scrolling_down, -- scroll results down
            ["<C-u>"] = actions.results_scrolling_up, -- scroll results up
            ["<C-f>"] = actions.preview_scrolling_down, -- scroll preview down
            ["<C-b>"] = actions.preview_scrolling_up, -- scroll preview up
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          additional_args = function(opts)
            return { "--hidden" }
          end,
        },
        lsp_references = {
          layout_config = {
            width = 0.9,
            height = 0.8,
            preview_width = 0.45,
          },
          path_display = { "absolute" },
          entry_maker = function(entry)
            local filename = entry.filename
            local lnum = entry.lnum
            local col = entry.col
            local text = entry.text

            return {
              value = entry,
              display = filename,
              ordinal = filename .. " " .. text,
              filename = filename,
              lnum = lnum,
              col = col,
              text = text,
            }
          end,
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")

    -- Define last search term storage
    local last_search_term = ""

    -- Custom function: prompt input with last used string
    local function live_grep_with_input(text, opts)
      local input = text or vim.fn.input("Grep > ", last_search_term)
      if input == "" then
        return
      end
      last_search_term = input
      require("telescope.builtin").live_grep(vim.tbl_extend("force", { default_text = input }, opts or {}))
    end

    -- Custom function: prompt input with fuzzy search
    local function live_grep_fuzzy_with_input(text)
      live_grep_with_input(text, { fuzzy = true })
    end

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fR", "<cmd>Telescope resume<cr>", { desc = "Telescope: resume" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    --keymap.set("n", "<leader>fs", live_grep_with_input, { desc = "Find string in cwd (persistent input)" })
    keymap.set("n", "<leader>fS", live_grep_fuzzy_with_input, { desc = "Find string in cwd (fuzzy search)" })
    -- keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fc", function()
      local word = vim.fn.expand("<cWORD>")
      if word ~= "" then
        live_grep_with_input(word)
      end
    end, { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fC", function()
      local word = vim.fn.expand("<cWORD>")
      if word ~= "" then
        live_grep_fuzzy_with_input(word)
      end
    end, { desc = "Find string under cursor in cwd (fuzzy search)" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    keymap.set("n", "<leader>/", function()
      require("telescope.builtin").current_buffer_fuzzy_find({
        -- no fuzzy
        fuzzy = false,
        case_mode = "smart_case",
      })
    end, { desc = "Find in current buffer" })

    keymap.set("n", "<leader>fq", "<cmd>Telescope quickfix<cr>", { desc = "Telescope: quickfix" })

    -- Search and command history
    keymap.set("n", "<leader>fh", "<cmd>Telescope search_history<cr>", { desc = "Search history" })
    keymap.set("n", "<leader>ch", "<cmd>Telescope command_history<cr>", { desc = "Command history" })

    -- Git integration
    keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Telescope: Git status" })
    keymap.set("n", "<leader>gb", "<cmd>Telescope git_bcommits<cr>", { desc = "Telescope: Git buffer commits" })
  end,
}
