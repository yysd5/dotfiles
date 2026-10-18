local wezterm = require("wezterm")

-- モジュールファイルのパスを正しく指定（絶対パス）
local base_dir = "/Users/y_yoshida/dotfiles/wezterm/"
local keys = dofile(base_dir .. "wezterm_keys.lua")
local appearance = dofile(base_dir .. "wezterm_appearance.lua")
local general = dofile(base_dir .. "wezterm_general.lua")

local config = {}

-- 各モジュールから設定を取得してマージ
local key_config = keys.setup()
local appearance_config = appearance.setup()
local general_config = general.setup()

-- すべての設定をマージ
for k, v in pairs(key_config) do
	config[k] = v
end

for k, v in pairs(appearance_config) do
	config[k] = v
end

for k, v in pairs(general_config) do
	config[k] = v
end

return config
