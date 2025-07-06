return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			local gitsigns = require("gitsigns")
			gitsigns.setup {}

			vim.keymap.set(
				"n",
				"<leader>gbl",
				"<cmd>Gitsigns blame_line<CR>",
				{ desc = "blame current line", noremap = true }
			)
			vim.keymap.set(
				"n",
				"<leader>hv",
				":Gitsigns preview_hunk<CR>",
				{ desc = "preview hunk" }
			)
			vim.keymap.set(
				"n",
				"[h",
				":Gitsigns prev_hunk<CR>",
				{ desc = "go to prev hunk" }
			)
			vim.keymap.set(
				"n",
				"]h",
				":Gitsigns next_hunk<CR>",
				{ desc = "go to next hunk" }
			)
			vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk)

			vim.keymap.set('v', '<leader>hs', function()
				gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
			end)

			vim.keymap.set('v', '<leader>hr', function()
				gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
			end)
		end,
	},
}
