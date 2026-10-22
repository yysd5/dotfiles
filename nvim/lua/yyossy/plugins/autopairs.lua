-- This plugin will help us auto close surrounding characters
-- like parens, brackets, curly braces, quotes, single quotes and tags

return {
  "windwp/nvim-autopairs",
  -- 補完確定時の括弧の補完はblink.cmpのauto_bracketsが行う
  event = { "InsertEnter" },
  config = function()
    -- import nvim-autopairs
    local autopairs = require("nvim-autopairs")

    -- configure autopairs
    autopairs.setup({
      check_ts = true, -- enable treesitter
      ts_config = {
        lua = { "string" }, -- don't add pairs in lua string treesitter nodes
        javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
        java = false, -- don't check treesitter on java
      },
    })
  end,
}
