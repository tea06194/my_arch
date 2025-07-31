return {
	{
		'stevearc/conform.nvim',
		config = function()
			local util = require("lspconfig.util")
			local function has_prettier_config(bufnr)
				bufnr = bufnr or vim.api.nvim_get_current_buf()
				local fname = vim.api.nvim_buf_get_name(bufnr)
				local root = util.root_pattern(
					".prettierrc", ".prettierrc.json", ".prettierrc.js",
					"prettier.config.js", "prettier.config.cjs"
				)(fname)
				return root ~= nil
			end

			require("conform").setup({
				formatters_by_ft = {
					javascript      = { "prettier", lsp_format = "fallback" },
					javascriptreact = { "prettier", lsp_format = "fallback" },
					typescript      = { "prettier", lsp_format = "fallback" },
					typescriptreact = { "prettier", lsp_format = "fallback" },
					json            = { "prettier", lsp_format = "fallback" },
					css             = { "stylelint", lsp_format = "fallback" },
					scss            = { "stylelint", lsp_format = "fallback" },
					markdown        = { "mdformat", lsp_format = "fallback" },

					sh              = { "beautysh", lsp_format = "fallback" },
					bash            = { "beautysh", lsp_format = "fallback" },
					zsh             = { "beautysh", lsp_format = "fallback" }
				},

				formatters = {
					beautysh = {
						prepend_args = {
							"--indent-size", "4",
							"--tab",
							"--force-function-style", "paronly",
						},
					},
				},
			})

			vim.keymap.set("n", "<space>lfr", function()
				local bufnr       = vim.api.nvim_get_current_buf()
				local ft          = vim.bo[bufnr].filetype

				local conform_fts = {
					javascript      = true,
					javascriptreact = true,
					typescript      = true,
					typescriptreact = true,
					json            = true,
					html            = true,
					yaml            = true,
					css             = true,
					scss            = true,
					markdown        = true,

					sh              = true,
					bash            = true,
					zsh             = true,
				}

				local use_conform = conform_fts[ft] and (
					(ft ~= "css" and ft ~= "scss" and has_prettier_config(bufnr))

					or ft == "css" or ft == "scss" or "markdown"

					or ft == "sh" or ft == "bash" or ft == "zsh"
				)

				if use_conform then
					require("conform").format({
						bufnr      = bufnr,
						lsp_format = "fallback", -- если CLI-утилита упадёт — вызовем LSP
					})
				else
					vim.lsp.buf.format({ bufnr = bufnr, async = false, timeout_ms = 10000 })
				end
			end, { desc = "format" })
		end
	}
}
