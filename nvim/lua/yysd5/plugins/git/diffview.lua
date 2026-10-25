return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  keys = {
    -- 小文字はHEADとの比較、大文字は作業ツリーとの比較
    { "<leader>gdo", "<cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
    { "<leader>gdc", "<cmd>DiffviewClose<CR>", desc = "Close Diffview" },
    {
      "<leader>gdd",
      "<cmd>DiffviewOpen origin/develop...HEAD<CR>",
      desc = "Open Diffview with origin/develop and HEAD",
    },
    {
      "<leader>gdD",
      "<cmd>DiffviewOpen origin/develop --<CR>",
      desc = "Open Diffview with origin/develop and Working Directory",
    },
    { "<leader>gdm", "<cmd>DiffviewOpen origin/main...HEAD<CR>", desc = "Open Diffview with origin/main and HEAD" },
    { "<leader>gdn", "<cmd>DiffviewOpen origin/master...HEAD<CR>", desc = "Open Diffview with origin/master and HEAD" },
    {
      "<leader>gdM",
      "<cmd>DiffviewOpen origin/main --<CR>",
      desc = "Open Diffview with origin/main and Working Directory",
    },
    {
      "<leader>gdN",
      "<cmd>DiffviewOpen origin/master --<CR>",
      desc = "Open Diffview with origin/master and Working Directory",
    },
    { "<leader>gdh", "<cmd>DiffviewFileHistory<CR>", desc = "Open DiffviewFileHistory" },
  },
  opts = {
    view = {
      default = {
        layout = "diff2_horizontal",
      },
    },
    hooks = {
      -- Expand all folds when entering diff mode by default
      -- https://github.com/sindrets/diffview.nvim/issues/437
      diff_buf_win_enter = function()
        vim.opt_local.foldenable = false
      end,
    },
  },
  config = function(_, opts)
    require("diffview").setup(opts)
  end,
}
