local opts = { noremap = true, silent = true }
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/neodev.nvim",
		},
		config = function()
			require("neodev").setup()
			-- setup_lua()
			-- setup_ts()
			vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>")
			vim.keymap.set(
				{ "n", "v" },
				"<leader>a",
				vim.lsp.buf.code_action,
				opts
			)
			vim.keymap.set(
				"n",
				"<leader>gd",
				vim.lsp.buf.definition,
				opts
			)
			vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
				pattern = {"*.hl", "hypr*.conf"},
				callback = function(event)
					print(string.format("starting hyprls for %s", vim.inspect(event)))
					vim.lsp.start {
						name = "hyprlang",
						cmd = {"hyprls"},
						root_dir = vim.fn.getcwd(),
					}
				end
			})
		end,
	}
}
