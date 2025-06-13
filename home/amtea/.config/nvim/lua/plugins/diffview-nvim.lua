return {
	{
		"sindrets/diffview.nvim",
		lazy = true,
		config = function()
			vim.keymap.set("n", "<leader>gdO", ":DiffviewOpen origin<CR>")
			vim.keymap.set("n", "<leader>gdo", ":DiffviewOpen<CR>")
			vim.keymap.set("n", "<leader>gdc", ":DiffviewClose<CR>")
		end,
	},
}
