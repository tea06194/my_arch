return {
	{
		"jake-stewart/multicursor.nvim",
		lazy = true,
		keys = {
			{ "<up>",      mode = { "n", "x" }, desc = "Line add Cursor 1" },
			{ "<down>",    mode = { "n", "x" }, desc = "Line add Cursor -1" },
			{ "<leader>n", mode = { "n", "x" }, desc = "Match add Cursor 1" },
		},
		config = function()
			local mc = require("multicursor-nvim")

			vim.keymap.set("i", "<left>", "<Left>", { silent = true })
			vim.keymap.set("i", "<right>", "<Right>", { silent = true })
			mc.setup()

			local set = vim.keymap.set

			-- Add or skip cursor above/below the main cursor.
			set({ "n", "x" }, "<up>",
			function() mc.lineAddCursor(-1) end)
			set({ "n", "x" }, "<down>",
			function() mc.lineAddCursor(1) end)
			set({ "n", "x" }, "<leader><up>",
			function() mc.lineSkipCursor(-1) end)
			set({ "n", "x" }, "<leader><down>",
			function() mc.lineSkipCursor(1) end)

			-- Add or skip adding a new cursor by matching word/selection
			set({ "n", "x" }, "<leader>n",
			function() mc.matchAddCursor(1) end)
			set({ "n", "x" }, "<leader>s",
			function() mc.matchSkipCursor(1) end)
			set({ "n", "x" }, "<leader>N",
			function() mc.matchAddCursor(-1) end)
			set({ "n", "x" }, "<leader>S",
			function() mc.matchSkipCursor(-1) end)

			set("n", "<esc>", function()
				if not mc.cursorsEnabled() then
					mc.enableCursors()
				elseif mc.hasCursors() then
					mc.clearCursors()
				else
					-- Default <esc> handler.
				end
			end)
		end
	}
}
