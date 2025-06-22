return {
	{
		'saghen/blink.cmp',
		version = '1.*',
		-- enabled = false,
		dependencies = {
			'L3MON4D3/LuaSnip',
			"moyiz/blink-emoji.nvim",
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			completion = {
				menu = {
					draw = {
						components = {
							label_description = {
								width = {
									fill = true,
									max = 60
								},
							}
						}
					}
				}
			},
			keymap = { preset = 'enter' },
			signature = { enabled = false },
			snippets = { preset = 'luasnip' },
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer', 'emoji' },
				providers = {
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 15, -- Tune by preference
						-- min_keyword_length = 2,
						opts = {
							---@type string|table|fun():table
							trigger = { ":" }
						},
						should_show_items = function()
							return true
						end
					}
				},
			},
		},
		opts_extend = { "sources.default" }
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {}
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {}
	},
}
