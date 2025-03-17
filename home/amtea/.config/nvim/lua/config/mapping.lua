local opts = { noremap = true, silent = true}

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
vim.keymap.set('n', '<leader>tt', ':belowright sp | terminal<CR> i', opts)

-- Open terminal right
vim.keymap.set('n', '<leader>tv', ':belowright vsp | terminal<CR> i', opts)


-- To normal from (t)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)

-- i_CTRL-R in (t)
vim.keymap.set('t', '<C-R>', function()
    return '<C-\\><C-N>"' .. vim.fn.nr2char(vim.fn.getchar()) .. 'pi'
end, { noremap = true, expr = true })

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

vim.keymap.set("n", "<leader>td", ToggleDiff, { desc = "Toggle Diff Mode" })
vim.keymap.set("n", "<leader>cd", ToggleDiffContext, { desc = "Toggle Diff Context" })

-- DIAGNOSTIC --
vim.keymap.set(
	"n",
	"<leader>d",
	function()
		vim.diagnostic.enable(not vim.diagnostic.is_enabled())
	end,
	{ desc = "Toggle diagnostic virtual_lines" }
)

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

-- COLORTHEME --
-- Toggle background
local function set_background(bg)
    vim.o.background = bg -- Устанавливаем светлую или тёмную тему
    local theme = vim.g.colors_name -- Получаем текущую тему
    print("(" .. theme .. " - " .. bg .. ")") -- Вывод информации
end

vim.keymap.set("n", "<F5>", function() set_background('dark') end, opts)
vim.keymap.set("n", "<F6>", function() set_background('light') end, opts)
