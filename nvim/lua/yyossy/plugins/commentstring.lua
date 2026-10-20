-- コメントアウトはNeovim標準のgc/gccを使う
-- tsx/jsx等でカーソル位置に応じたcommentstringにするため、
-- ts-context-commentstringの計算結果を標準のgcに渡す
return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    enable_autocmd = false,
  },
  config = function(_, opts)
    require("ts_context_commentstring").setup(opts)

    local get_option = vim.filetype.get_option
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.filetype.get_option = function(filetype, option)
      return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
        or get_option(filetype, option)
    end
  end,
}
