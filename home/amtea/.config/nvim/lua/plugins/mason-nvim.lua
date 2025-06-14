return {
	{
		"mason-org/mason.nvim",
		event="VeryLazy",
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
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

			mason_lspconfig.setup(
				{
					automatic_enable = true,
					ensure_installed = {
						"hyprls",
						"lua_ls",
						"ts_ls",
						"css_variables",
						"jsonls",
						"cssls",
						"bashls",
						"eslint",
						"html",
						"stylelint_lsp",
						"cssmodules_ls"
					}
				}
			)
		end,
	},
}
