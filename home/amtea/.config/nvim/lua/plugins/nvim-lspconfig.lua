local opts = { noremap = true, silent = true }

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/lazydev.nvim",
		},
		config = function()
			require("lazydev").setup()

			vim.lsp.config("*",
				{
					on_attach = function (client, buffnr)
						if client.server_capabilities.semanticTokensProvider then
							client.server_capabilities.semanticTokensProvider = nil
						end

						vim.keymap.set(
							"n",
							"gd",
							vim.lsp.buf.definition,
							vim.tbl_extend('force', { buffer = buffnr }, opts)
						)
						vim.keymap.set(
							"n",
							"gr",
							vim.lsp.buf.references,
							vim.tbl_extend('force', { buffer = buffnr }, opts)
						)
						vim.keymap.set(
							"n",
							"gi",
							vim.lsp.buf.implementation,
							vim.tbl_extend('force', { buffer = buffnr }, opts)
						)
						vim.keymap.set(
							{ "n", "i" },
							"<C-s>",
							vim.lsp.buf.signature_help,
							vim.tbl_extend('force', { buffer = buffnr }, opts)
						)
						vim.keymap.set(
							{ "n", "i" },
							"<C-a>",
							vim.lsp.buf.hover,
							vim.tbl_extend('force', { buffer = buffnr }, opts)
						)
						vim.keymap.set(
							"n",
							"<space>rn",
							vim.lsp.buf.rename,
							vim.tbl_extend('force', { buffer = buffnr }, opts)
						)
					end
				}
			)

			vim.keymap.set(
				"n",
				"<leader>lr",
				"<cmd>LspRestart<cr>",
				opts
			)
			vim.keymap.set(
				{ "n", "v" },
				"<leader>ca",
				vim.lsp.buf.code_action,
				opts
			)

			vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
				pattern = {"*.hl", "hypr*.conf"},
				callback = function()
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
