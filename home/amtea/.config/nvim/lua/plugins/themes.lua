return {
	{
		'sainnhe/sonokai',
		lazy = false,
		priority = 1000,
		config = function()
			local light = {
				black = { "#181819", "255" },
				bg_dim = { "#f8f8f8", "254" },
				bg0 = { "#ffffff", "231" },
				bg1 = { "#f0f0f0", "255" },
				bg2 = { "#e8e8e8", "255" },
				bg3 = { "#e0e0e0", "254" },
				bg4 = { "#d8d8d8", "254" },
				bg_red = { "#ff6077", "203" },
				diff_red = { "#ffebee", "203" },
				bg_green = { "#a7df78", "107" },
				diff_green = { "#d9ffcf", "107" },
				bg_blue = { "#7091ff", "110" },
				diff_blue = { "#e6fdff", "110" },
				diff_yellow = { "#ffffdc", "179" },
				fg = { "#303030", "236" },
				red = { "#e61616", "203" },
				orange = { "#cf7d00", "215" },
				yellow = { "#00b0b0", "179" },
				green = { "#009f00", "107" },
				blue = { "#4255ff", "110" },
				purple = { "#c900c9", "176" },
				grey = { "#7f8490", "246" },
				grey_dim = { "#595f6f", "240" },
				none = { "NONE", "NONE" },
			}
			vim.keymap.set(
				"n",
				"<leader>lg",
				function ()
					vim.g.sonokai_colors_override = light
					vim.cmd.colorscheme('sonokai')
					vim.api.nvim_set_hl(0, "MatchParen", {
						bg='#5adfe6',
						fg='#000000'
					})
				end
			)
			vim.keymap.set(
				"n",
				"<leader>dr",
				function ()
					vim.g.sonokai_colors_override = {
						none = {'NONE', 'NONE'}
					}
					vim.cmd.colorscheme('sonokai')
					vim.api.nvim_set_hl(0, "MatchParen", {
						bg='#5adfe6',
						fg='#000000'
					})
				end
			)
			vim.g.sonokai_enable_italic = true
			vim.cmd.colorscheme('sonokai')
			vim.api.nvim_set_hl(0, "MatchParen", {
				bg='#5adfe6',
				fg='#000000'
			})
		end
	}
}

