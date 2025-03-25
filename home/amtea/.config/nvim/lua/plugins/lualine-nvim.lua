return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
		'nvim-tree/nvim-web-devicons',
		'arkav/lualine-lsp-progress'
	},
	config = function ()
		local colors = {
			yellow = '#ECBE7B',
			cyan = '#008080',
			darkblue = '#081633',
			green = '#98be65',
			orange = '#FF8800',
			violet = '#a9a1e1',
			magenta = '#c678dd',
			blue = '#51afef',
			red = '#ec5f67'
		}

		require('lualine').setup({
			sections = {
				lualine_x =  {
					{
						function()
							local clients = vim.lsp.get_clients({bufnr = vim.api.nvim_get_current_buf()})
							local lsp_names = {}

							for _, client in pairs(clients) do
								table.insert(lsp_names, client.name)
							end

							return table.concat(lsp_names, ", ") or "no_lsp"
						end,
						icon = '󱏒',
						color = { fg = '#c678dd', gui = 'bold' },
					},
					{
						'lsp_progress',
						colors = {
							percentage  = colors.cyan,
							title  = colors.cyan,
							message  = colors.cyan,
							spinner = colors.cyan,
							lsp_client_name = colors.magenta,
							use = true,
						},
						separators = {
							component = ' ',
							progress = ' | ',
							message = {
								pre = '(',
								post = ')',
								commenced = 'In Progress',
								completed = 'Completed',
							},
							percentage = { pre = '', post = '%% ' },
							title = { pre = '', post = ': ' },
							lsp_client_name = { pre = '[', post = ']' },
							spinner = { pre = '', post = '' },
						},
						display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage' } },
						timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
						spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
					},
					'filesize',
					'encoding',
					'fileformat',
					'filetype'
				}
			},
			tabline= {
				lualine_a = {
					{
						'filename',
						path = 3,
					},
				}
			}
		})
	end
}
