return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
        python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
        xml = { "xmlformatter" },
      },
      -- 保存時の自動整形は既定でオフ。トグルで有効にしたときだけ整形する
      -- (バッファ単位の設定があればグローバルより優先する)
      -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#autoformat-with-extra-features
      format_on_save = function(bufnr)
        local enabled = vim.b[bufnr].autoformat
        if enabled == nil then
          enabled = vim.g.autoformat
        end
        if not enabled then
          return
        end
        -- Disable autoformat for files in a certain path
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
          return
        end
        -- ...additional logic...
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
    })

    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
      conform.format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })

    -- Toggle autoformat on save globally
    vim.keymap.set("n", "<leader>tA", function()
      vim.g.autoformat = not vim.g.autoformat
      local status = vim.g.autoformat and "enabled" or "disabled"
      vim.notify("Autoformat on save " .. status, vim.log.levels.INFO)
    end, { desc = "Toggle autoformat on save globally" })

    -- Toggle autoformat on save for current buffer
    vim.keymap.set("n", "<leader>ta", function()
      local current = vim.b.autoformat
      if current == nil then
        current = vim.g.autoformat
      end
      vim.b.autoformat = not current
      local status = vim.b.autoformat and "enabled" or "disabled"
      vim.notify("Autoformat on save " .. status .. " for current buffer", vim.log.levels.INFO)
    end, { desc = "Toggle autoformat on save for current buffer" })
  end,
}
