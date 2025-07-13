return {
	{
		"sindrets/diffview.nvim",
		config = function()
			vim.keymap.set("n", "<leader>gdo", ":DiffviewOpen<CR>", { desc = "diffview open" })
			vim.keymap.set("n", "<leader>gdO", ":DiffviewOpen origin<CR>", { desc = "diffview open origin" })
			vim.keymap.set("n", "<leader>gdc", ":DiffviewClose<CR>", { desc = "diffview close" })
		end,
	},
}
