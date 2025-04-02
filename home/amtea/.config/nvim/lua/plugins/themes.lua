return {
	{
		'sainnhe/sonokai',
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.g.sonokai_colors_override = {
			-- 	fg = {'#ff0000', '196'}
			-- }
			vim.g.sonokai_enable_italic = true
			vim.cmd.colorscheme('sonokai')
		end
	}
}
