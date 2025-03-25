return {
	{
		'nvim-telescope/telescope.nvim', branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim', "2kabhishek/nerdy.nvim" },
		config = function()
			require('telescope').load_extension('nerdy');
		end
	}
}
