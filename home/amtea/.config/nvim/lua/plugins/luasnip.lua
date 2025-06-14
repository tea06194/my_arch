return {
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			-- local ls = require("luasnip")
			-- ls.config.set_config {
			-- 	cut_selection_keys = "<Tab>",
			-- }
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	}
}
