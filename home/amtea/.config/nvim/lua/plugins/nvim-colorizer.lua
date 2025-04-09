return {
	{
		'norcalli/nvim-colorizer.lua',
		config = function ()
			vim.opt.termguicolors = true

			require('colorizer').setup({
				'lua',
				'javascript',
				'javascriptreact',
				'typescript',
				'typescriptreact',
				'json',
				jsonc = {
					RRGGBBAA = true;
				},
				'html',
				'css',
			})
		end
	},
}
