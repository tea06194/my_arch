return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = {
			'nvim-tree/nvim-web-devicons',
			'arkav/lualine-lsp-progress',
			'tpope/vim-obsession'
		},
		config = function()
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

			local function git_aware_filename()
				local fullpath = vim.fn.expand('%:p')

				-- Если это не Git diff view, возвращаем nil для использования встроенного "filename"
				if not fullpath:match('diffview://') then
					return nil
				end

				-- Git diff view логика - возвращаем только filename
				return vim.fn.expand('%:t')
			end

			local function git_stage_info()
				local fullpath = vim.fn.expand('%:p')

				if not fullpath:match('diffview://') then
					return nil
				end

				local stage = fullpath:match(':(%d+):')
				if stage then
					local stage_names = {
						['0'] = 'result',
						['1'] = '$orig',
						['2'] = 'HEAD',
						['3'] = 'MERGE_HEAD'
					}
					return stage_names[stage]
				end

				local sha = fullpath:match('/%.git/([a-f0-9]+)/')
				if sha then
					return sha:sub(1, 7)
				end

				return nil
			end

			require('lualine').setup({
				options = {
					always_show_tabline = false,
				},
				sections = {
					lualine_c = {
						{
							function()
								local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
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
								percentage      = colors.cyan,
								title           = colors.cyan,
								message         = colors.cyan,
								spinner         = colors.cyan,
								lsp_client_name = colors.magenta,
								use             = true,
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
							timer = { progress_enddelay = 100, spinner = 1000, lsp_client_name_enddelay = 100 },
							spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
						},
					},
					lualine_x = {
						{
							function()
								local linters = require("lint").get_running()
								if #linters == 0 then
									return "󰦕"
								end
								return "󱉶 " .. table.concat(linters, ", ")
							end
						},
						'filesize',
						'encoding',
						'fileformat',
						'filetype'
					}
				},
				inactive_sections = {
					lualine_c = {}
				},
				tabline = {
					lualine_z = {
						{
							"tabs",
							mode = 1,

						},
					}
				},
				winbar = {
					lualine_a = {
						{
							function()
								local git_result = git_aware_filename()
								if git_result then
									return git_result
								else
									return require('lualine.components.filename'):new({
										path = 3,
										shorting_target = 10,
									}):update_status()
								end
							end,
							separator = '',
							color = function()
								return vim.bo.modified and { fg = "#e61616" } or nil
							end
						},
						{
							git_stage_info,
							separator = '',
							color = { gui = 'bold' },
							cond = function()
								return git_stage_info() ~= nil
							end
						}
					},
					lualine_z = {
						{
							function()
								local status = vim.fn.ObsessionStatus()

								return #status == 0 and '[]' or status
							end,
							color = function()
								local status = vim.fn.ObsessionStatus()
								local color = { gui = 'bold' }

								if #status == 0 then
									color.fg = "grey"
									color.bg = "black"
								elseif status == "[S]" then
									color.bg = "grey"
								end

								return color
							end
						}
					}
				},
				inactive_winbar = {
					lualine_a = {
						{
							'filename',
							path = 3,
							shorting_target = 10,
						}
					}
				}
			})
		end
	}
}
