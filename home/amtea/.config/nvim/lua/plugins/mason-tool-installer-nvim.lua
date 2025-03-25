return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			require("mason-tool-installer").setup {
				ensure_installed = {
					"lua-language-server",
					"bash-language-server",
					"css-lsp",
					"css-variables-language-server",
					"cssmodules-language-server",
					"html-lsp",
					"json-lsp",
					"stylelint",
					"stylelint-lsp",
					"typescript-language-server",
					"hyprls",
				}
			}
			--
			-- vim.api.nvim_create_autocmd('User', {
			-- 	pattern = 'MasonToolsStartingInstall',
			-- 	callback = function()
			-- 		vim.schedule(function()
			-- 			print 'mason-tool-installer is starting'
			-- 		end)
			-- 	end,
			-- })
			-- vim.api.nvim_create_autocmd('User', {
			-- 	pattern = 'MasonToolsUpdateCompleted',
			-- 	callback = function(e)
			-- 		vim.schedule(function()
			-- 			print(vim.inspect(e.data), "toolInst") -- print the table that lists the programs that were installed
			-- 		end)
			-- 	end,
			-- })
		end,
	}
}
