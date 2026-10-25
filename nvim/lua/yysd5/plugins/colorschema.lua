return {
  {
    "folke/tokyonight.nvim",
    --priority = 1000, -- make sure to load this before all the other start plugins
    --lazy = false,
    config = function()
      -- local bg = "#011628"
      -- local bg_dark = "#011423"
      -- local bg_highlight = "#143652"
      -- local bg_search = "#0A64AC"
      -- local bg_visual = "#275378"
      -- local fg = "#CBE0F0"
      -- local fg_dark = "#B4D0E9"
      -- local fg_gutter = "#627E97"
      -- local border = "#547998"
      --
      require("tokyonight").setup({
        style = "storm",
        --   on_colors = function(colors)
        --     colors.bg = bg
        --     colors.bg_dark = bg_dark
        --     colors.bg_float = bg_dark
        --     colors.bg_highlight = bg_highlight
        --     colors.bg_popup = bg_dark
        --     colors.bg_search = bg_search
        --     colors.bg_sidebar = bg_dark
        --     colors.bg_statusline = bg_dark
        --     colors.bg_visual = bg_visual
        --     colors.border = border
        --     colors.fg = fg
        --     colors.fg_dark = fg_dark
        --     colors.fg_float = fg
        --     colors.fg_gutter = fg_gutter
        --     colors.fg_sidebar = fg_dark
        --   end,
      })
      -- load the colorscheme here
      --vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    -- priority = 1000,
    --lazy = false,
    config = function()
      -- Default options:
      require("kanagawa").setup({
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors) -- add/modify highlights
          return {}
        end,
        theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
          dark = "wave", -- try "dragon" !
          light = "lotus",
        },
      })

      -- setup must be called before loading
      --vim.cmd("colorscheme kanagawa")
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    --priority = 1000,
    --lazy = false,
    config = function()
      -- Default options
      require("nightfox").setup({
        options = {
          -- Compiled file's destination location
          compile_path = vim.fn.stdpath("cache") .. "/nightfox",
          compile_file_suffix = "_compiled", -- Compiled file suffix
          transparent = false, -- Disable setting background
          terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
          dim_inactive = false, -- Non focused panes set to alternative background
          module_default = true, -- Default enable value for modules
          colorblind = {
            enable = false, -- Enable colorblind support
            simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
            severity = {
              protan = 0, -- Severity [0,1] for protan (red)
              deutan = 0, -- Severity [0,1] for deutan (green)
              tritan = 0, -- Severity [0,1] for tritan (blue)
            },
          },
          styles = { -- Style to be applied to different syntax groups
            comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
            conditionals = "NONE",
            constants = "NONE",
            functions = "NONE",
            keywords = "NONE",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
            variables = "NONE",
          },
          inverse = { -- Inverse highlight for different types
            match_paren = false,
            visual = true,
            search = false,
          },
          modules = { -- List of various plugins and additional options
            -- ...
          },
        },
        palettes = {},
        specs = {},
        groups = {
          all = {
            WinSeparator = { fg = "#EBEFFD" },
          },
        },
      })

      -- setup must be called before loading
      vim.cmd("colorscheme nightfox")
      -- vim.cmd("colorscheme carbonfox")

      -- Set the highlight for the current line number (absolute line number)
      -- vim.cmd([[
      --   highlight CursorLineNr guifg=#00ffff guibg=NONE gui=NONE
      -- ]])
    end,
  },
  {
    "sainnhe/everforest",
    priority = 1000,
    lazy = false,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      -- vim.g.everforest_enable_italic = true
      vim.g.everforest_disable_italic_comment = true
      vim.g.everforest_background = "hard"
      vim.g.everforest_better_performance = true
      -- vim.cmd.colorscheme("everforest")
    end,
  },
  {
    "shaunsingh/nord.nvim",
    -- priority = 1000,
    -- lazy = false,
    config = function()
      require("lualine").setup({
        options = {
          -- ... your lualine config
          theme = "nord",
          -- ... your lualine config
        },
      })
      -- vim.cmd.colorscheme("nord")
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    -- priority = 1000,
    -- lazy = false,
    config = function()
      local c = require("vscode.colors").get_colors()
      require("vscode").setup({
        -- Alternatively set style in setup
        -- style = 'light'

        -- Enable transparent background
        transparent = false,

        -- Enable italic comment
        italic_comments = false,

        -- Underline `@markup.link.*` variants
        underline_links = true,

        -- Disable nvim-tree background color
        disable_nvimtree_bg = false,

        -- Apply theme colors to terminal
        terminal_colors = true,

        -- -- Override colors (see ./lua/vscode/colors.lua)
        -- color_overrides = {
        --   vscLineNumber = "#FFFFFF",
        -- },
        --
        -- Override highlight groups (see ./lua/vscode/theme.lua)
        group_overrides = {
          -- this supports the same val table as vim.api.nvim_set_hl
          -- use colors from this colorscheme by requiring vscode.colors!
          Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
        },
      })
      -- vim.cmd.colorscheme("vscode")
      -- -- Set the highlight for the current line number (absolute line number)
      -- vim.cmd([[
      --   highlight CursorLineNr guifg=#00ffff guibg=NONE gui=NONE
      -- ]])
    end,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    -- priority = 1000,
    -- lazy = false,
    -- Add in any other configuration;
    --   event = foo,
    --   config = bar
    --   end,
    config = function()
      -- vim.cmd.colorscheme("oxocarbon")
    end,
  },
}
