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

-- Open external terminal to wd
vim.keymap.set('n',	'<leader>xt', function ()
		vim.fn.system('kitty --directory="' .. vim.fn.getcwd() ..'" &')
end, opts)

-- To normal from (t)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)

-- i_CTRL-R in (t)
vim.keymap.set('t', '<C-R>', function()
    return '<C-\\><C-N>"' .. vim.fn.nr2char(vim.fn.getchar()) .. 'pi'
end, opts)

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

vim.keymap.set("n", "<leader>diff", ToggleDiff, { desc = "Toggle Diff Mode", table.unpack(opts)})
vim.keymap.set("n", "<leader>diffc", ToggleDiffContext, { desc = "Toggle Diff Context", table.unpack(opts) })

-- DIAGNOSTIC --
vim.keymap.set(
	"n",
	"<leader>diag",
	function()
		vim.diagnostic.enable(not vim.diagnostic.is_enabled())
	end,
	{ desc = "Toggle diagnostic virtual_lines", table.unpack(opts) }
)

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

-- COLORTHEME --
-- Toggle background
local function set_background(bg)
    vim.o.background = bg -- Устанавливаем светлую или тёмную тему
    local theme = vim.g.colors_name -- Получаем текущую тему
    print("(" .. theme .. " - " .. bg .. ")") -- Вывод информации
end

-- vim.keymap.set("n", "<F5>", function() set_background('dark') end, opts)
-- vim.keymap.set("n", "<F6>", function() set_background('light') end, opts)

local function clear_highlights_and_set_colortheme(name)
  -- Очищаем все highlight-группы
  vim.cmd("hi clear")

  -- Сбрасываем настройки пользовательских групп
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  -- Опционально: обнуляем `Normal` для более чистого сброса
  vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
  vim.cmd("colorscheme " .. name)
end

vim.keymap.set("n", "<F4>", function()  clear_highlights_and_set_colortheme('sonokai') end, opts)

-- EDITOR --
vim.keymap.set("n", "<leader>cl", function () vim.opt.cursorline = not vim.opt.cursorline:get() end, opts)

