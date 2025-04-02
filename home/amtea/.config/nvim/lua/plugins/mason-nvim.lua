local lsp_configs = {
	-- ["hyprls"] = {
	-- 	config = function ()
	-- 	end
	-- },
}

local opts = { noremap = true, silent = true }

return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local mason = require "mason"
			local mason_lspconfig = require("mason-lspconfig")
			mason.setup {
				PATH = "append",
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			}
			mason_lspconfig.setup()

			mason_lspconfig.setup_handlers({
				function(server_name)
					local config = lsp_configs[server_name]
					if config then
						require("lspconfig")[server_name].setup(config)
					else
						require("lspconfig")[server_name].setup({
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
						})
					end
				end
			})
		end,
	},
}
