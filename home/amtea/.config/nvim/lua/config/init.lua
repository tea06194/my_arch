local opts = { noremap = true, silent = true}

-- SHELL --
vim.opt.shell = '/bin/bash'
vim.opt.shellcmdflag = '-i -c'

-- ENV --
vim.env.NVIM_CFG = vim.fn.stdpath("config")
-- vim.env.ALACRITTY_CFG = vim.env.APPDATA .. "/alacritty/"
vim.env.PATH = "/home/amtea/.nvm/versions/node/v22.14.0/bin:" .. vim.env.PATH

-- LEADER --
vim.g.mapleader = " "
vim.keymap.set("n", "<Space>", "<Nop>", opts)

-- LANG --
vim.env.LANG = "en_US.UTF-8"

vim.opt.langmap = "йq,цw,уe,кr,еt,нy,гu,шi,щo,зp,х[,ъ],фa,ыs,вd,аf,пg,рh,оj,лk,дl,ж\\;,э',ё`,яz,чx,сc,мv,иb,тn,ьm,б\\,,ю.,ЙQ,ЦW,УE,КR,ЕT,НY,ГU,ШI,ЩO,ЗP,Х{,Ъ},ФA,ЫS,ВD,АF,ПG,РH,ОJ,ЛK,ДL,Ж:,Э\",ЯZ,ЧX,СC,МV,ИB,ТN,ЬM,Б<,Ю>,Ё~"

vim.keymap.set('i', '<C-ц>', '<C-w>', opts)
vim.keymap.set('i', '<C-х>', '<C-[>', opts)
vim.keymap.set('i', '<C-щ>', '<C-o>', opts)

-- STATUSLINE --
vim.opt.statusline = "%{bufnr()} %<%f %h%m%r%=%-14.(%l,%c%V%) %P"
vim.opt.showmode = false

-- EDITOR --
vim.opt.number = true
vim.opt.numberwidth = 1

vim.opt.signcolumn = 'yes'

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

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

-- TEMP CYCLE THEMES ------------------------------------------------------------------------------------------------------------

-- local themes = {} -- Список тем
-- local theme_index = 1 -- Индекс текущей темы
--
-- -- Функция для получения всех доступных тем
-- local function get_all_themes()
--     themes = {} -- Очищаем список перед сбором
--     local files_vim = vim.api.nvim_get_runtime_file("colors/*.vim", true) -- Ищем .vim
--     local files_lua = vim.api.nvim_get_runtime_file("colors/*.lua", true) -- Ищем .lua
--
--     local files = vim.list_extend(files_vim, files_lua) -- Объединяем два списка
--     for _, file in ipairs(files) do
--         local name = file:match("([^/\\]+)%.vim$") or file:match("([^/\\]+)%.lua$")
--         if name then
--             themes[#themes + 1] = name
--         end
--     end
-- end
--
-- -- Функция переключения тем вперёд или назад
-- local function cycle_theme(direction)
--     if #themes == 0 then
--         get_all_themes() -- Если список пуст, обновляем его
--     end
--
--     if #themes == 0 then
--         print("Нет доступных тем!")
--         return
--     end
--
--     -- Изменяем индекс в зависимости от направления
--     theme_index = (theme_index - 1 + direction) % #themes + 1
--     local new_theme = themes[theme_index] -- Получаем новую тему
--     vim.cmd("colorscheme " .. new_theme) -- Устанавливаем тему
--     print("(" .. new_theme .. " - " .. vim.o.background .. ")") -- Вывод текущей темы
-- end
--
-- -- Кеймапы для переключения тем
-- vim.keymap.set("n", "<F7>", function() cycle_theme(-1) end, opts) -- Назад
-- vim.keymap.set("n", "<F8>", function() cycle_theme(1) end,  opts) -- Вперёд
--
-- get_all_themes()

-------------------------------------------------------------------------------------------------------------------------------------

-- DIAGNOSTIC --
vim.diagnostic.config({
    virtual_text = true,  -- Включаем виртуальный текст
    signs = true,         -- Включаем значки на полях
    underline = true,     -- Подчёркиваем проблемные участки
    update_in_insert = false,  -- Не обновлять диагностику в режиме вставки
    severity_sort = false,     -- Не сортировать диагностику по уровню серьёзности
})

--------------------------------------------------------------------------------------------------------------------------------------
-- local function wrap_in_tag()
-- 	local start_row = unpack(vim.api.nvim_buf_get_mark(0, "<"))
-- 	local end_row = unpack(vim.api.nvim_buf_get_mark(0, ">"))
--
-- 	local tag = vim.fn.input("Enter tag name: "):match("%S+")
-- 	if not tag or tag == "" then return end
--
-- 	local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
-- 	print(vim.inspect(lines))
-- 	if not lines or #lines == 0 then return end
--
-- 	if #lines == 1 then
-- 		-- Line
-- 		local line = lines[1]
-- 		local trimmed = line:match("^%s*(.-)%s*$")
-- 		local indent = line:match("^(%s*)") or ""
-- 		lines[1] = indent .. "<" .. tag .. ">" .. trimmed .. "</" .. tag .. ">"
-- 	else
-- 		-- Multiline
-- 		table.insert(lines, 1, "<" .. tag .. ">")
-- 		table.insert(lines, "</" .. tag .. ">")
--
-- 		vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, lines)
--
-- 		vim.cmd(string.format("normal! %dGV%dG=", start_row, end_row + 2))
-- 		-- vim.lsp.buf.format({
-- 		--   async = true,
-- 		--   range = {
-- 		-- 	["start"] = { start_row, 0 },
-- 		-- 	["end"] = { end_row + 2, 0 },
-- 		--   }
-- 		-- })
-- 		return
-- 	end
--
-- 	vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, lines)
--
-- 	vim.cmd(string.format("normal! %dGV%dG=", start_row, end_row))
-- end
--
-- vim.api.nvim_create_user_command("WrapInTag", wrap_in_tag, { range = true })
-- vim.keymap.set("v", "<leader>w", ":WrapInTag<CR>", opts)
--
