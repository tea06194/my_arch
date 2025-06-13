return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup {}
			vim.keymap.set(
				"n",
				"<leader>gbl",
				"<cmd>Gitsigns blame_line<CR>",
				{ desc = "blame current line", noremap = true }
			)
			vim.keymap.set(
				"n",
				"<leader>gv",
				":Gitsigns preview_hunk<CR>",
				{ desc = "preview hunk" }
			)
			vim.keymap.set(
				"n",
				"[g",
				":Gitsigns prev_hunk<CR>",
				{ desc = "go to prev hunk" }
			)
			vim.keymap.set(
				"n",
				"]g",
				":Gitsigns next_hunk<CR>",
				{ desc = "go to next hunk" }
			)
		end,
	},
}
