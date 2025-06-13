local opts = { noremap = true, silent = true }
local M = require("config.functions.utils")
local described = M.described

-- WINDOWS NAVIGATION --
-- (t)
vim.keymap.set('t', '<A-h>', '<C-\\><C-N><C-w>h', opts)
vim.keymap.set('t', '<A-j>', '<C-\\><C-N><C-w>j', opts)
vim.keymap.set('t', '<A-k>', '<C-\\><C-N><C-w>k', opts)
vim.keymap.set('t', '<A-l>', '<C-\\><C-N><C-w>l', opts)

-- (i)
vim.keymap.set('i', '<A-h>', '<C-\\><C-N><C-w>h', opts)
vim.keymap.set('i', '<A-j>', '<C-\\><C-N><C-w>j', opts)
vim.keymap.set('i', '<A-k>', '<C-\\><C-N><C-w>k', opts)
vim.keymap.set('i', '<A-l>', '<C-\\><C-N><C-w>l', opts)

-- (n)
vim.keymap.set('n', '<A-h>', '<C-w>h', opts)
vim.keymap.set('n', '<A-j>', '<C-w>j', opts)
vim.keymap.set('n', '<A-k>', '<C-w>k', opts)
vim.keymap.set('n', '<A-l>', '<C-w>l', opts)

-- TERMINAL --
-- Open terminal bottom
vim.keymap.set('n', '<leader>th', ':belowright sp | terminal<CR> i', opts)

-- Open terminal right
vim.keymap.set('n', '<leader>tv', ':belowright vsp | terminal<CR> i', opts)

-- Open external terminal to wd
vim.keymap.set('n', '<leader>tx', function()
	vim.fn.system('kitty --directory="' .. vim.fn.getcwd() .. '" &')
end, opts)

-- To normal from (t)
vim.keymap.set('t', '<C-[>', '<C-\\><C-n>', opts)

-- i_CTRL-R in (t)
vim.keymap.set('t', '<C-R>', function()
	return '<C-\\><C-N>"' .. vim.fn.getcharstr() .. 'pi'
end, vim.tbl_extend("force", opts, { expr = true }))

-- DIFF --
function ToggleDiff()
	if vim.wo.diff then
		vim.cmd("windo diffoff")
	else
		vim.cmd("windo diffthis")
	end
end

function ToggleDiffContext()
	local diffopt = vim.opt.diffopt:get()
	if vim.tbl_contains(diffopt, "context:0") then
		vim.opt.diffopt:remove("context:0")
		print("Diff context выключен")
	else
		vim.opt.diffopt:append("context:0")
		print("Diff context включен")
	end
end

vim.keymap.set("n", "<leader>do", ToggleDiff, described(opts, "Toggle Diff Mode"))
vim.keymap.set("n", "<leader>dc", ToggleDiffContext, described(opts, "Toggle Diff Context"))
vim.keymap.set('n', '<leader>dg', '<cmd>diffget<CR>', { desc = 'Get hunk from other diff' })
vim.keymap.set('n', '<leader>dp', '<cmd>diffput<CR>', { desc = 'Put hunk to other diff' })
-- DIAGNOSTIC --

vim.keymap.set('n', '<C-W>d', function ()
	vim.diagnostic.open_float()
	vim.diagnostic.open_float()
end, opts)
-- vim.keymap.set(
-- 	"n",
-- 	"<leader>diag",
-- 	function()
-- 		vim.diagnostic.enable(not vim.diagnostic.is_enabled())
-- 	end,
-- 	described(opts, "Toggle diagnostic virtual_lines")
-- )

-- COLORTHEME --

-- EDIT --

-- Move current line(s) ---

vim.keymap.set("n", "<leader>j", ":m .+1<CR>==")
vim.keymap.set("n", "<leader>k", ":m .-2<CR>==")
vim.keymap.set("v", "<leader>j", ":'<,'>m '>+1<CR>gv=gv")
vim.keymap.set("v", "<leader>k", ":'<,'>m '<-2<CR>gv=gv")

-- EDITOR --
vim.keymap.set("n", "<leader>cl", function() vim.opt.cursorline = not vim.opt.cursorline:get() end, opts)
vim.keymap.set("n", "<leader>cc", function() vim.opt.cursorcolumn = not vim.opt.cursorcolumn:get() end, opts)

vim.keymap.set("n", "<leader>cfp", function() vim.fn.setreg("+", vim.fn.expand("%:p")) end, opts)
