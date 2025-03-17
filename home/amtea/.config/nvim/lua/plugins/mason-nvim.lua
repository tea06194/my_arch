local lsp_configs = {
	-- ["hyprls"] = {
	-- 	config = function ()
	-- 	end
	-- },
}

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
						require("lspconfig")[server_name].setup({})
					end
				end
			})
		end,
	},
}
