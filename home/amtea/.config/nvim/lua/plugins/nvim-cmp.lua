return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"windwp/nvim-autopairs",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			local cmp                                 = require("cmp")
			local luasnip                             = require("luasnip")
			local ts_utils                            = require("nvim-treesitter.ts_utils")
			local cmp_autopairs                       = require("nvim-autopairs.completion.cmp")
			local default_handler                     = cmp_autopairs.filetypes["*"]["("].handler

			require("nvim-autopairs").setup({})

			local ts_node_func_parens_disabled        = {
				named_imports   = true, -- ecma imports
				use_declaration = true, -- rust `use`
			}

			cmp_autopairs.filetypes["*"]["("].handler = function(char, item, bufnr, rules, commit_character)
				local node_type = ts_utils.get_node_at_cursor():type()
				if ts_node_func_parens_disabled[node_type] then
					if item.data then
						item.data.funcParensDisabled = true
					else
						char = ""
					end
				end
				default_handler(char, item, bufnr, rules, commit_character)
			end

			cmp.setup({
				completion = { autocomplete = false },
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand({})
							else
								cmp.confirm({ select = true })
							end
						else
							fallback()
						end
					end),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							cmp.complete()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "luasnip" },
					{ name = "buffer" },
				}),
				formatting = {
					format = function(entry, vim_item)
						vim_item.menu = ({
							nvim_lsp = "[LSP]",
							luasnip = "[LuaSnip]",
							buffer = "[Buffer]",
							path = "[Path]",
						})[entry.source.name] or "[Other]"
						return vim_item
					end,
				}
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" }
				}
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" }
				}, {
					{ name = "cmdline" }
				}),
				matching = { disallow_symbol_nonprefix_matching = false }
			})

			cmp.event:on(
				"confirm_done",
				cmp_autopairs.on_confirm_done({ sh = false })
			)

			require('nvim-ts-autotag').setup({
				opts = {
					enable_close          = true,
					enable_rename         = true,
					enable_close_on_slash = false,
				},
				per_filetype = {
					["html"] = { enable_close = false }
				}
			})
		end,
	},
}
