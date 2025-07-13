return {
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require('lint')
			local max_file_size = 1024 * 1024 -- 1MB

			lint.linters_by_ft = {
				javascript = { 'eslint_d' },
				typescript = { 'eslint_d' },
				javascriptreact = { 'eslint_d' },
				typescriptreact = { 'eslint_d' },
			}

			local lint_group = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
				group = lint_group,
				callback = function()
					local bufnr = vim.api.nvim_get_current_buf()
					local name = vim.api.nvim_buf_get_name(bufnr)

					if name ~= "" and vim.fn.filereadable(name) == 1 then
						local stat = vim.uv.fs_stat(name)
						if not stat or stat.size <= max_file_size then
							lint.try_lint()
						end
					end
				end,
			})
		end
	}
}
