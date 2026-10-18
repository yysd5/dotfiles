local M = {}

function M.setup()
	return {
		-- マウス操作設定
		enable_tab_bar = true,
		use_fancy_tab_bar = false,
		enable_scroll_bar = false,

		-- スクロールバッファサイズ
		scrollback_lines = 10000,
	}
end

return M

