return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"eandrju/cellular-automaton.nvim",
		},
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })()
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = false,
				ensure_installed = {
					-- languages
					"bash",
					-- "c",
					-- "clojure",
					-- "fennel",
					"go",
					"gomod",
					"gosum",
					-- "groovy",
					"java",
					"javascript",
					-- "kotlin",
					"lua",
					-- "proto",
					"python",
					-- "rust",
					"scheme",
					"sql",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					-- markup
					"css",
					"html",
					"markdown",
					"markdown_inline",
					"mermaid",
					"xml",
					"asm",
					-- config
					"dot",
					"toml",
					"yaml",
					-- data
					"csv",
					"json",
					"json5",
					-- utility
					"diff",
					"ssh_config",
					"printf",
					"disassembly",
					"dockerfile",
					"git_config",
					"git_rebase",
					"gitcommit",
					"gitignore",
					"http",
					"query",
				},
				highlight = {
					enable = true,
					disable = function(lang, buf)
						local max_filesize = 500 * 1024 -- 100 KB
						local ok, stats = pcall(
							vim.loop.fs_stat,
							vim.api.nvim_buf_get_name(buf)
						)
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
					additional_vim_regex_highlighting = false,
				},
				ignore_install = {},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<C-backspace>",
					},
				},
				modules = {},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["a="] = {
								query = "@assignment.outer",
								desc = "Select outer part of an assignment",
							},
							["i="] = {
								query = "@assignment.inner",
								desc = "Select inner part of an assignment",
							},
							["r="] = {
								query = "@assignment.rhs",
								desc = "Select right hand side of an assignment",
							},

							["aa"] = {
								query = "@parameter.outer",
								desc = "Select outer part of a parameter/argument",
							},
							["ia"] = {
								query = "@parameter.inner",
								desc = "Select inner part of a parameter/argument",
							},

							--[[ ["ai"] = {
								query = "@conditional.outer",
								desc = "Select outer part of a conditional",
							},
							["ii"] = {
								query = "@conditional.inner",
								desc = "Select inner part of a conditional",
							}, ]]

							["al"] = {
								query = "@loop.outer",
								desc = "Select outer part of a loop",
							},
							["il"] = {
								query = "@loop.inner",
								desc = "Select inner part of a loop",
							},

							["ac"] = {
								query = "@call.outer",
								desc = "Select outer part of a function call",
							},
							["ic"] = {
								query = "@call.inner",
								desc = "Select inner part of a function call",
							},

							["af"] = {
								query = "@function.outer",
								desc = "Select outer part of a method/function definition",
							},
							["if"] = {
								query = "@function.inner",
								desc = "Select inner part of a method/function definition",
							},

							["at"] = {
								query = "@class.outer",
								desc = "Select outer part of a type",
							},
							["it"] = {
								query = "@class.inner",
								desc = "Select inner part of a type",
							},

							["an"] = {
								query = "@block.outer",
								desc = "Select inner part of a block",
							},
							["in"] = {
								query = "@block.inner",
								desc = "Select outer part of a block",
							},
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						--[[ goto_next_start = {
							["]m"] = "@function.outer",
							["]i"] = "@conditional.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]I"] = "@conditional.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[i"] = "@conditional.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[I"] = "@conditional.outer",
						}, ]]
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>man"] = "@parameter.inner",
							["<leader>mfn"] = "@function.outer",
							["<leader>mcn"] = "@class.outer",
						},
						swap_previous = {
							["<leader>map"] = "@parameter.inner",
							["<leader>mfp"] = "@function.outer",
							["<leader>mcp"] = "@class.outer",
						},
					},
				},
				sync_install = false,
			})
			vim.keymap.set("n", "<leader>mir", "<cmd>CellularAutomaton make_it_rain<CR>")
		end
	}
}
