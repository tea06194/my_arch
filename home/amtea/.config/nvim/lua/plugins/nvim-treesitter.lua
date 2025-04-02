return {
	"nvim-treesitter/nvim-treesitter",
	build = function()
		require("nvim-treesitter.install").update({ with_sync = true })()
	end,
	config = function ()
		require("nvim-treesitter.configs").setup({
			modules= {},
			sync_install = false,
			ignore_install = {},
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
			}
		})
	end
}
