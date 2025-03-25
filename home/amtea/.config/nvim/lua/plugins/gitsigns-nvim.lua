return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup {}
			vim.keymap.set(
				"n",
				"<leader>gib",
				"<cmd>Gitsigns blame_line<CR>",
				{ desc = "blame current line", noremap = true }
			)
            vim.keymap.set(
                "n",
                "<leader>gv",
                ":Gitsigns preview_hunk<CR>",
                { desc = "preview hunk" }
            )
            vim.keymap.set(
                "n",
                "<leader>ga",
                ":Gitsigns stage_hunk<CR>",
                { desc = "stage hunk" }
            )
            vim.keymap.set(
                "n",
                "<leader>gA",
                ":Gitsigns stage_buffer<CR>",
                { desc = "stage buffer" }
            )
            vim.keymap.set(
                "n",
                "<leader>gr",
                ":Gitsigns reset_hunk<CR>",
                { desc = "reset hunk" }
            )
            vim.keymap.set(
                "n",
                "<leader>gR",
                ":Gitsigns prev_buffer<CR>",
                { desc = "reset buffer" }
            )
            vim.keymap.set(
                "n",
                "[g",
                ":Gitsigns prev_hunk<CR>",
                { desc = "go to prev hunk" }
            )
            vim.keymap.set(
                "n",
                "]g",
                ":Gitsigns next_hunk<CR>",
                { desc = "go to next hunk" }
            )
        end,
    },
}
