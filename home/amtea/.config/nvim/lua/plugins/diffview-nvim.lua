return {
	{
		"sindrets/diffview.nvim",
		config = function()
			vim.keymap.set("n", "<leader>gdo", ":DiffviewOpen<CR>", { desc = "Diffview open" })
			vim.keymap.set("n", "<leader>gdO", ":DiffviewOpen origin<CR>", { desc = "Diffview open origin" })
			vim.keymap.set("n", "<leader>gdc", ":DiffviewClose<CR>", { desc = "Diffview close" })
		end,
	},
}
