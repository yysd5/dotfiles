-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

--------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
-- keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
-- keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management (<leader>w)
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current split" })

-- tab management (<leader><Tab>)
keymap.set("n", "<leader><Tab>o", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader><Tab>x", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader><Tab>n", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader><Tab>p", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader><Tab>f", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Map Ctrl+S to :w (save)
vim.keymap.set("n", "<C-s>", "<Cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<Esc><Cmd>w<CR>a", { desc = "Save file" })

-- terminal
-- exit terminal-job mode with <Esc> or jk
keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true }) -- exit terminal-job mode with <Esc>
vim.api.nvim_set_keymap("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    -- Remap <C-h> to act as backspace in terminal mode
    vim.keymap.set("t", "<C-h>", "<BS>", { noremap = true, silent = true, buffer = true })

    -- Remap <C-k> to delete everything after the cursor (kill-line behavior)
    vim.keymap.set("t", "<C-k>", "<C-\\><C-n>i<C-k>", { noremap = true, silent = true, buffer = true })
  end,
})

-- Toggle command-line window with <leader>u
keymap.set("n", "<leader>u", function()
  -- Close the command-line window if it is open
  if vim.fn.getcmdwintype() ~= "" then
    vim.cmd("close")
  else
    -- Open the command-line window (command history)
    vim.api.nvim_feedkeys("q:", "n", false)
  end
end, { desc = "Toggle Command-Line Window" })

-- マニュアル(nvim/manual/index.html)をブラウザで開く
vim.api.nvim_create_user_command("NvimManual", function()
  vim.ui.open(vim.fn.stdpath("config") .. "/manual/index.html")
end, { desc = "Open nvim manual in browser" })
keymap.set("n", "<leader>H", "<cmd>NvimManual<CR>", { desc = "Open nvim manual" })
