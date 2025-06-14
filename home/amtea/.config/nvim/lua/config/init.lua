local opts = { noremap = true, silent = true }

-- SHELL --
vim.opt.shell = '/bin/bash'
vim.opt.shellcmdflag = '-i -c'

-- ENV --
vim.env.NVIM_CFG = vim.fn.stdpath("config")

-- vim.env.ALACRITTY_CFG = vim.env.APPDATA .. "/alacritty/"
vim.env.PATH = "/home/amtea/.nvm/versions/node/v22.14.0/bin:" .. vim.env.PATH

local function load_custom_env(path)
	local file = io.open(path, "r")
	if not file then return end

	for line in file:lines() do
		local key, value = line:match("^([%w_]+)%s*=%s*(.+)$")
		if key and value then
			vim.fn.setenv(key, value)
		end
	end

	file:close()
end

load_custom_env(os.getenv("HOME") .. "/.config/.nvimenv")

-- LEADER --
vim.g.mapleader = " "
vim.keymap.set("n", "<Space>", "<Nop>", opts)

-- LANG --
vim.env.LANG = "en_US.UTF-8"

vim.keymap.set('i', '<C-х>', '<C-[>', opts)
vim.keymap.set('i', '<C-к>', '<C-r>', opts)
--
-- vim.keymap.set('i', '<C-ц>', '<C-w>', opts)
-- vim.keymap.set('i', '<C-щ>', '<C-o>', opts)

-- local function escape(str)
-- 	local escape_chars = [[;,."|\]]
-- 	return vim.fn.escape(str, escape_chars) end
--
-- local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
-- local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
-- local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
-- local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]
-- local langmap = vim.fn.join({
-- 	escape(ru_shift) .. ";" .. escape(en_shift),
-- 	escape(ru) .. ";" .. escape(en),
-- }, ",")
--
-- vim.opt.langmap = langmap
-- vim.opt.langmap =
-- "йq,цw,уe,кr,еt,нy,гu,шi,щo,зp,х[,ъ],фa,ыs,вd,аf,пg,рh,оj,лk,дl,ж\\;,э',ё`,яz,чx,сc,мv,иb,тn,ьm,б\\,,ю.,ЙQ,ЦW,УE,КR,ЕT,НY,ГU,ШI,ЩO,ЗP,Х{,Ъ},ФA,ЫS,ВD,АF,ПG,РH,ОJ,ЛK,ДL,Ж:,Э\",ЯZ,ЧX,СC,МV,ИB,ТN,ЬM,Б<,Ю>,Ё~"

-- STATUSLINE --
vim.opt.statusline = "%{bufnr()} %<%f %h%m%r%=%-14.(%l,%c%V%) %P"
vim.opt.showmode = false

-- EDITOR --
vim.opt.number = true
vim.opt.numberwidth = 1

vim.opt.signcolumn = 'yes'

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

vim.opt.list = true
vim.opt.listchars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<"

vim.opt.cursorline = true

-- Comment in gitconfig
vim.api.nvim_create_autocmd("FileType", {
	pattern = "gitconfig",
	callback = function()
		vim.opt_local.commentstring = "# %s"
	end,
})

-- TERMINAL --
vim.api.nvim_create_autocmd('TermOpen', {
	pattern = '*',
	callback = function()
		vim.opt_local.cursorlineopt = 'number'
		vim.opt_local.cursorcolumn = false
		vim.opt_local.scrolloff = 0
		vim.opt_local.sidescrolloff = 0
	end,
})

-- DIAGNOSTIC --
vim.diagnostic.config({
	virtual_text = true,   -- Включаем виртуальный текст
	signs = true,          -- Включаем значки на полях
	underline = true,      -- Подчёркиваем проблемные участки
	update_in_insert = false, -- Не обновлять диагностику в режиме вставки
	severity_sort = false, -- Не сортировать диагностику по уровню серьёзности
})

vim.api.nvim_create_autocmd('User', {
	pattern = 'LazyVimStarted',
	callback = function()
		local stats = require('lazy').stats()
		print('Startup in: ' .. stats.startuptime .. 'ms')
	end
})
