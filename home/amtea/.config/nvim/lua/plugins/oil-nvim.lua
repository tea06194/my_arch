return {
	{
		'stevearc/oil.nvim',
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
		config = function()
			require("oil").setup()

			vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "open oil" })
			vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "open oil" })
			vim.keymap.set("n", "<leader>E", "<cmd>Oil --float<CR>", { desc = "open oil float" })
		end,
	}
}
