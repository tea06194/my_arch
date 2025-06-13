return {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		keys = {
			{ "<leader>Db", "<cmd>lua require'dap'.toggle_breakpoint() <CR>", desc = "Toggle Debug breakpoint" }
		},
		config = function()
			local dap = require("dap")

			dap.adapters["pwa-node"] = {
				type = "server",
				host = 'localhost',
				port = '${port}',
				executable = {
					command = "js-debug-adapter",
					args = { '${port}' }
				}
			}

			dap.configurations.javascript = {
				-- {
				-- 	type = 'pwa-node',
				-- 	request = 'launch',
				-- 	name = 'Node launch',
				-- 	program = '${file}',
				-- 	cwd = '${workspaceFolder}',
				-- },
				{
					type = "pwa-node",
					request = "attach",
					name = "Node attach",
					-- processId = require("dap.utils").pick_process(),
					cwd = '${workspaceFolder}',
					port = 9229,
					-- sourceMaps = true,
					-- resolveSourceMapLocations = {
					-- 	"${workspaceFolder}/**",
					-- 	"!**/node_modules/**",
					-- },
					-- skipFiles = { "<node_internals>/**" },
					-- cwd = vim.fn.getcwd()
				}
			}
			dap.configurations.typescript = {
				{
					type = "pwa-node",
					request = "attach",
					name = "Node attach",
					cwd = '${workspaceFolder}',
					port = 9229,
					sourceMaps = true,
					outFiles = { "${workspaceFolder}/dist/**/*.js" },
					resolveSourceMapLocations = {
						"${workspaceFolder}/**",
						"!**/node_modules/**",
					},
					skipFiles = { "<node_internals>/**" },
					-- cwd = vim.fn.getcwd()
				}
			}

			vim.keymap.set("n", "<F2>", function()
				dap.terminate()
			end, { desc = "Stop debugging" })

			vim.keymap.set("n", "<F5>", function()
				dap.continue()
			end, { desc = "Continue debugging" })

			vim.keymap.set("n", "<F6>", function()
				dap.repl.open()
			end, { desc = "Open REPL" })

			vim.keymap.set("n", "<F7>", function()
				dap.run_to_cursor()
			end, { desc = "Run debugging to cursor" })

			vim.keymap.set("n", "<F10>", function()
				dap.step_over()
			end, { desc = "Step over" })

			vim.keymap.set("n", "<F11>", function()
				dap.step_into()
			end, { desc = "Step into" })

			vim.keymap.set("n", "<F12>", function()
				dap.step_out()
			end, { desc = "Step out" })

			vim.keymap.set("n", "<leader>Db", function()
				dap.toggle_breakpoint()
			end, {
				desc = "Toggle Debug breakpoint",
			})

			vim.keymap.set("n", "<leader>DB", function()
				local condition = vim.fn.input "Breakpoint condition: "
				dap.set_breakpoint(condition)
			end, {
				desc = "Toggle Debug conditional Breakpoint",
			})
		end
	}
}
