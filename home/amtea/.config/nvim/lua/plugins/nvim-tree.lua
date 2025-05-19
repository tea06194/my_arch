return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = true,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>tree", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
	},
	config = function()
		require("nvim-tree").setup({
			hijack_netrw     = false,
			hijack_directories = {
				enable    = false,
				auto_open = false,
			},
			git = { enable = false },
			filters = { dotfiles = true },
			filesystem_watchers = { enable = false },
		})
	end,
}
