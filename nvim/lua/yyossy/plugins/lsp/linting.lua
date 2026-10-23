return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      markdown = { "markdownlint" },
      typescript = { "eslint_d" },
    }

    -- 実行ファイルが無いlinterは飛ばす
    -- (masonがインストールを終える前の初回起動などでエラーを出さないため)
    local function try_lint()
      local names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        if type(linter) == "function" then
          linter = linter()
        end
        local cmd = linter and linter.cmd
        if type(cmd) == "function" then
          cmd = cmd()
        end
        return cmd ~= nil and vim.fn.executable(cmd) == 1
      end, lint.linters_by_ft[vim.bo.filetype] or {})
      if #names > 0 then
        lint.try_lint(names)
      end
    end

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = try_lint,
    })

    vim.keymap.set("n", "<leader>cl", try_lint, { desc = "Trigger linting for current file" })
  end,
}
