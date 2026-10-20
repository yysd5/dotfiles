-- CIでnvim設定の起動確認をするスクリプト
-- 使い方: nvim --headless -c "luafile .github/scripts/nvim-smoke.lua"
-- 起動・ファイル読み込み時のエラーと、lua_lsのattachを確認する
--
-- v:errmsgはプラグインがsilent!で握りつぶしたエラーも拾ってしまうため、
-- 利用者に見えるエラーが残る:messagesとvim.notifyのERRORで判定する

local errors = {}

local function record(msg)
  table.insert(errors, msg)
end

local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  if level == vim.log.levels.ERROR then
    record("notify: " .. tostring(msg))
  end
  return orig_notify(msg, level, opts)
end

-- headlessではUIEnterが来ないので、VeryLazyのプラグインを明示的に読み込む
vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })

-- filetypeごとに遅延読み込みされる設定を通す
local tmpdir = vim.fn.tempname()
vim.fn.mkdir(tmpdir, "p")
local lua_file = vim.fn.stdpath("config") .. "/init.lua"
local files = { lua_file }
for _, name in ipairs({ "sample.py", "sample.ts", "sample.go", "sample.md", "sample.sh", "sample.json" }) do
  table.insert(files, tmpdir .. "/" .. name)
end
for _, path in ipairs(files) do
  local ok, err = pcall(vim.cmd.edit, vim.fn.fnameescape(path))
  if not ok then
    record("edit " .. vim.fn.fnamemodify(path, ":t") .. ": " .. tostring(err))
  end
end

-- lua_lsがattachするか確認する(事前にmasonでインストールしておく)
local lua_buf = vim.fn.bufnr(lua_file)
local attached = vim.wait(60000, function()
  return #vim.lsp.get_clients({ bufnr = lua_buf, name = "lua_ls" }) > 0
end, 500)
if not attached then
  record("lsp: lua_ls did not attach to init.lua within 60s")
end

-- 非同期のエラー通知が出るまで少し待つ
vim.wait(2000)

for _, line in ipairs(vim.split(vim.fn.execute("messages"), "\n")) do
  if line:match("E%d+:") or line:match("^Error") then
    record("message: " .. line)
  end
end

if #errors > 0 then
  io.stderr:write("nvim smoke test FAILED\n")
  for _, e in ipairs(errors) do
    io.stderr:write("  - " .. e .. "\n")
  end
  vim.cmd("cquit 1")
else
  io.stdout:write("nvim smoke test passed\n")
  vim.cmd("qall!")
end
