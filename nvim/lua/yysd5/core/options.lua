vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt -- for conciseness

-- tips: you can use "h" command to know more about options like ":h autoindent"

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)
-- opt.statuscolumn = [[%!v:lnum . '│' . (v:lnum == line('.') ? '0' : abs(v:lnum - line('.')))]]

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
-- opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive
opt.smartcase = false

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- window separators
opt.fillchars = {
  vert = "▎", -- thick left block for vertical separator
  horiz = "━", -- horizontal line for horizontal separator
  horizup = "┻",
  horizdown = "┳",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}

-- turn off swapfile
opt.swapfile = false

-- Automatically reload file when it changes outside of Neovim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})
