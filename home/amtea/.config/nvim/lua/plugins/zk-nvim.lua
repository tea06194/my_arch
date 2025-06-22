return {
	{
		"zk-org/zk-nvim",
		config = function()
			require("zk").setup({
				picker = "fzf_lua",
				lsp = {
					-- `config` is passed to `vim.lsp.start_client(config)`
					config = {
						cmd      = { "zk", "lsp" },
						name     = "zk",
						-- on_attach = ...
						-- etc, see `:h vim.lsp.start_client()`
					},

					-- automatically attach buffers in a zk notebook that match the given filetypes
					auto_attach = {
						enabled = true,
						filetypes = { "markdown" },
					},
				},
			})

			local opts = { noremap = true, silent = false }
			-- Create a new note after asking for its title.
			vim.api.nvim_set_keymap("n", "<leader>zkn", "<Cmd>ZkNew<CR>", opts)
			vim.api.nvim_set_keymap("n", "<leader>zkN", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", opts)
			-- Open notes.
			vim.api.nvim_set_keymap("n", "<leader>zko", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
			-- Open notes associated with the selected tags.
			vim.api.nvim_set_keymap("n", "<leader>zkt", "<Cmd>ZkTags<CR>", opts)
			-- Search for the notes matching a given query.
			vim.api.nvim_set_keymap("n", "<leader>zkf",
				"<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", opts)
			-- Search for the notes matching the current visual selection.
			vim.api.nvim_set_keymap("v", "<leader>zkf", ":'<,'>ZkMatch<CR>", opts)
		end
	}
}
