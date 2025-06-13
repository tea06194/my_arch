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

			vim.lsp.config("*",
				{
					on_attach = function(client, bufnr)
						client.server_capabilities.semanticTokensProvider = nil

						vim.keymap.set(
							"n",
							"<space>lgd",
							vim.lsp.buf.definition,
							vim.tbl_extend('force', { buffer = bufnr }, opts)
						)
						vim.keymap.set(
							"n",
							"<space>lgr",
							vim.lsp.buf.references,
							vim.tbl_extend('force', { buffer = bufnr }, opts)
						)
						vim.keymap.set(
							"n",
							"<space>lgi",
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
							"<space>lrn",
							vim.lsp.buf.rename,
							vim.tbl_extend('force', { buffer = bufnr }, opts)
						)
						vim.keymap.set(
							"n",
							"<space>lfr", function()
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
									async = false,
									timeout_ms = 10000
								})
							end,
							vim.tbl_extend('force', { buffer = bufnr }, opts)
						)
						vim.keymap.set(
							{ "n", "v" },
							"<leader>lca",
							vim.lsp.buf.code_action,
							opts
						)
						vim.keymap.set("n", "<leader>lrs", function()
							local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })
							local seen = {}

							vim.diagnostic.reset()

							for _, buf_client in ipairs(buf_clients) do
								local name = buf_client.name
								if not seen[name] then
									seen[name] = true
									vim.cmd("LspRestart " .. name)
								end
							end

							vim.notify("LSP restarted", vim.log.levels.INFO)
						end, { desc = "Reset diagnostics & restart LSP" })
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

			vim.lsp.config("cssmodules_ls", {
			})

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
