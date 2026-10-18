local wezterm = require("wezterm")

local M = {}

function M.setup()
	return {
		-- フォント設定
		font = wezterm.font("Hack Nerd Font Mono"),
		font_size = 12.5,

		-- ----- Oxocarbon start -----
		-- カラースキーム設定
		color_scheme = "Oxocarbon Dark (Gogh)",

		-- カスタム色設定（ANSI色を上書き）
		colors = {
			-- ANSIカラーのカスタマイズ
			ansi = {
				"#161616", -- black
				"#3ddbd9", -- red
				"#33b1ff", -- green
				"#ee5396", -- yellow
				"#42be65", -- blue
				"#be95ff", -- magenta
				"#ff7eb6", -- cyan
				"#f2f4f8", -- white
			},
			brights = {
				"#585858", -- bright black
				"#3ddbd9", -- bright red
				"#33b1ff", -- bright green
				"#ee5396", -- bright yellow
				"#42be65", -- bright blue
				"#be95ff", -- bright magenta
				"#ff7eb6", -- bright cyan
				"#f2f4f8", -- bright white
			},

			-- 背景色設定
			background = "#0e1018", -- ダークなネイビーブルー

			-- その他の色設定
			cursor_bg = "#f2f4f8", -- カーソルの背景色
			cursor_fg = "#161616", -- カーソルの前景色
			selection_bg = "#353a45", -- 選択範囲の背景色
			selection_fg = "#f2f4f8", -- 選択範囲の前景色

			-- ----- Oxocarbon end -----
		},
	}
end

return M