local opts = { noremap = true, silent = true }
-- local preferred_formatters = {
-- 	biome = true,
-- 	eslint = true,
-- 	["stylelint_lsp"] = true,
-- }

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/lazydev.nvim",
		},
		config = function()
			require("lazydev").setup()

			local lspconfig = require("lspconfig")

			vim.lsp.config("*",
				{
					on_attach = function(client, bufnr)
						client.server_capabilities.semanticTokensProvider = nil

						vim.keymap.set(
							"n",
							"gd",
							vim.lsp.buf.definition,
							vim.tbl_extend('force', { buffer = bufnr }, opts)
						)
						vim.keymap.set(
							"n",
							"gr",
							vim.lsp.buf.references,
							vim.tbl_extend('force', { buffer = bufnr }, opts)
						)
						vim.keymap.set(
							"n",
							"gi",
							vim.lsp.buf.implementation,
							vim.tbl_extend('force', { buffer = bufnr }, opts)
						)
						vim.keymap.set(
							{ "n", "i" },
							"<C-s>",
							vim.lsp.buf.signature_help,
							vim.tbl_extend('force', { buffer = bufnr }, opts)
						)
						vim.keymap.set(
							{ "n", "i" },
							"<C-a>",
							vim.lsp.buf.hover,
							vim.tbl_extend('force', { buffer = bufnr }, opts)
						)
						vim.keymap.set(
							"n",
							"<space>rn",
							vim.lsp.buf.rename,
							vim.tbl_extend('force', { buffer = bufnr }, opts)
						)
						vim.keymap.set(
							"n",
							"<space>fr", function()
								-- local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })
								-- local has_preferred = false;
								--
								-- for _, buf_client in ipairs(buf_clients) do
								-- 	if preferred_formatters[buf_client.name] then
								-- 		has_preferred = true;
								-- 		break
								-- 	end
								-- end

								vim.lsp.buf.format({
									-- async = true,
									-- bufnr = bufnr,
									-- filter = function(format_client)
									-- 	if has_preferred then
									-- 		print("preffered formatter: " .. format_client.name)
									-- 		return preferred_formatters[format_client.name]
									-- 	end
									-- 	return format_client.server_capabilities.documentFormattingProvider ~= nil
									-- end,
								})
							end,
							vim.tbl_extend('force', { buffer = bufnr }, opts)
						)
					end
				}
			)

			vim.lsp.config("lua_ls", {
				root_markers = {
					"init.lua",
					".luarc.json",
					".luarc.jsonc",
					".luacheckrc",
					".stylua.toml",
					"stylua.toml",
					"selene.toml",
					"selene.yml",
					".git"
				}
			})

			vim.keymap.set("n", "<leader>lr", function()
				vim.diagnostic.reset()
				vim.cmd("LspRestart")
				vim.notify("LSP restarted", vim.log.levels.INFO)
			end, { desc = "Reset diagnostics & restart LSP" })
			vim.keymap.set(
				{ "n", "v" },
				"<leader>ca",
				vim.lsp.buf.code_action,
				opts
			)

			vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
				pattern = { "*.hl", "hypr*.conf" },
				callback = function()
					vim.lsp.start {
						name = "hyprlang",
						cmd = { "hyprls" },
						root_dir = vim.fn.getcwd(),
					}
				end
			})
		end,
	}
}
