local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.setup()
	return {
		leader = { key = "g", mods = "CTRL", timeout_milliseconds = 1000 },

		keys = {
			-- ==================== Pane ====================

			-- ペイン分割
			{ key = "\\", mods = "LEADER", action = act.SplitHorizontal },
			{ key = "-", mods = "LEADER", action = act.SplitVertical },

			-- ペイン移動(vim風)
			{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
			{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
			{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
			{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

			-- ペインを入れ替え（tmuxのPrefix + {, Prefix + }相当）
			{
				key = "{",
				mods = "LEADER|SHIFT",
				action = act.RotatePanes("CounterClockwise"),
			},
			{
				key = "}",
				mods = "LEADER|SHIFT",
				action = act.RotatePanes("Clockwise"),
			},

			-- ペインを閉じる（tmuxのPrefix + x相当）
			-- TODO: 確認付きにしたいかも
			{
				key = "x",
				mods = "LEADER",
				action = act.CloseCurrentPane({ confirm = true }),
			},

			-- ==================== Tab ====================

			-- 新しいタブを作成（tmuxのPrefix + c相当）
			{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },

			-- タブの名前を変更（tmuxのPrefix + ,相当）
			{
				key = ",",
				mods = "LEADER",
				action = act.PromptInputLine({
					description = "タブ名を入力:",
					action = wezterm.action_callback(function(window, pane, line)
						if line then
							window:active_tab():set_title(line)
						end
					end),
				}),
			},

			-- 前のタブに移動（tmuxのPrefix + p相当）
			{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },

			-- 次のタブに移動（tmuxのPrefix + n相当）
			{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },

			-- 数字キーで指定したタブに移動（tmuxのPrefix + 数字相当）
			{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
			{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
			{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
			{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
			{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
			{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
			{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
			{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
			{ key = "9", mods = "LEADER", action = act.ActivateTab(8) },

			-- タブを閉じる（tmuxのPrefix + &相当）
			-- TODO: 確認付きにしたいかも
			{
				key = "&",
				mods = "LEADER|SHIFT",
				action = act.CloseCurrentTab({ confirm = true }),
			},

			-- ==================== Workspace ====================

			{
				mods = "LEADER",
				key = "w",
				action = wezterm.action_callback(function(win, pane)
					-- workspace のリストを作成
					local workspaces = {}
					for i, name in ipairs(wezterm.mux.get_workspace_names()) do
						table.insert(workspaces, {
							id = name,
							--label = string.format("%d. %s", i, name),
							label = string.format("%s", name),
						})
					end
					local current = wezterm.mux.get_active_workspace()
					-- 選択メニューを起動
					win:perform_action(
						act.InputSelector({
							action = wezterm.action_callback(function(_, _, id, label)
								if not id and not label then
									wezterm.log_info("Workspace selection canceled") -- 入力が空ならキャンセル
								else
									win:perform_action(act.SwitchToWorkspace({ name = id }), pane) -- workspace を移動
								end
							end),
							title = "Select workspace",
							choices = workspaces,
							fuzzy = false,
							-- fuzzy_description = string.format("Select workspace: %s -> ", current), -- requires nightly build
						}),
						pane
					)
				end),
			},

			{
				-- Rename workspace
				mods = "LEADER",
				key = "$",
				action = act.PromptInputLine({
					description = "(wezterm) Rename workspace:",
					action = wezterm.action_callback(function(win, pane, line)
						if line then
							wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
						end
					end),
				}),
			},

			{
				-- Create new workspace
				mods = "LEADER|SHIFT",
				key = "W",
				action = act.PromptInputLine({
					description = "(wezterm) Create new workspace:",
					action = wezterm.action_callback(function(window, pane, line)
						if line then
							window:perform_action(
								act.SwitchToWorkspace({
									name = line,
								}),
								pane
							)
						end
					end),
				}),
			},

			-- ==================== Copy mode ====================

			-- コピーモード
			{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },

			-- コピーモード内の設定（vimスタイル）
			{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }), mode = "copy" },
			{
				key = "y",
				mods = "NONE",
				action = act.Multiple({
					act.CopyTo("ClipboardAndPrimarySelection"),
					act.CopyMode("Close"),
				}),
				mode = "copy",
			},
		},

		-- vi modeをコピーモードのデフォルトにする
		key_tables = {
			copy_mode = wezterm.gui.default_key_tables().copy_mode,
		},
	}
end

return M

