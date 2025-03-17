-- ra-spring-mod-tea.lua
-- Port of Ra Spring Mod By Tea theme to Neovim Lua

local colors = {
    black = "#000000",  -- hsl(0, 0%, 0%)
    blue = "#0066cc",   -- hsl(210, 100%, 40%)
    blue2 = "#000080",  -- hsl(240, 100%, 25%)
    cadmium_violet = "#7a4f7a",  -- hsl(283, 42%, 42%)
    cyan = "#009999",   -- hsl(180, 100%, 30%)
    cyan2 = "#80c080",  -- hsl(150, 50%, 60%)
    cyan3 = "#00cccc",  -- hsl(180, 100%, 40%)
    green = "#009900",  -- hsl(120, 100%, 30%)
    grey = "#ababab",   -- hsl(0, 0%, 67%)
    grey2 = "#303030",  -- hsl(0, 0%, 19%)
    orange = "#cc6600", -- hsl(30, 100%, 40%)
    pink = "#cc66cc",   -- hsl(300, 50%, 60%)
    purple = "#993399", -- hsl(290, 50%, 40%)
    red = "#ff6666",    -- hsl(0, 100%, 70%)
    white = "#ffffff",  -- hsl(0, 0%, 100%)
    yellow = "#999966", -- hsl(60, 20%, 50%)
    yellow2 = "#ffff00", -- hsl(60, 100%, 50%)

    -- Добавлены новые цвета для замены прозрачных
    line_highlight = "#f0f0f0",  -- Замена для color(var(black) alpha(0.031))
    selection = "#e0e0e0",       -- Замена для color(var(black) alpha(0.13))
    visual = "#e0e0e0",          -- Замена для selection
    search = "#e0e0e0",          -- Замена для findMatch
    inc_search = "#d0d0d0",      -- Замена для findMatchHighlight
    pmenu = "#f0f0f0",           -- Замена для list_activeSelection
    pmenu_sel = "#e0e0e0",       -- Замена для list_hover
    color_column = "#f0f0f0",    -- Замена для lineHighlight
}

local function setup_highlights()
    vim.cmd("highlight clear")
    vim.cmd("syntax reset")

    -- General
    vim.api.nvim_set_hl(0, "Normal", { fg = colors.grey2, bg = colors.white })
    vim.api.nvim_set_hl(0, "Cursor", { fg = colors.grey2, bg = colors.grey2 })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.line_highlight })
    vim.api.nvim_set_hl(0, "LineNr", { fg = colors.grey })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.grey2 })
    vim.api.nvim_set_hl(0, "Visual", { bg = colors.visual })
    vim.api.nvim_set_hl(0, "Search", { bg = colors.search })
    vim.api.nvim_set_hl(0, "IncSearch", { bg = colors.inc_search })
    vim.api.nvim_set_hl(0, "MatchParen", { bg = colors.visual })
    vim.api.nvim_set_hl(0, "Pmenu", { bg = colors.pmenu })
    vim.api.nvim_set_hl(0, "PmenuSel", { bg = colors.pmenu_sel })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.white, fg = colors.grey2 })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = colors.white, fg = colors.grey2 })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = colors.grey, bg = colors.white })
    vim.api.nvim_set_hl(0, "Folded", { fg = colors.grey, bg = colors.white })
    vim.api.nvim_set_hl(0, "FoldColumn", { fg = colors.grey, bg = colors.white })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = colors.white })
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = colors.color_column })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = colors.white })

    -- Syntax
    vim.api.nvim_set_hl(0, "Comment", { fg = colors.grey, italic = true })
    vim.api.nvim_set_hl(0, "Constant", { fg = colors.orange })
    vim.api.nvim_set_hl(0, "String", { fg = colors.green })
    vim.api.nvim_set_hl(0, "Character", { fg = colors.green })
    vim.api.nvim_set_hl(0, "Number", { fg = colors.orange })
    vim.api.nvim_set_hl(0, "Boolean", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Float", { fg = colors.orange })
    vim.api.nvim_set_hl(0, "Identifier", { fg = colors.green })
    vim.api.nvim_set_hl(0, "Function", { fg = colors.purple })
    vim.api.nvim_set_hl(0, "Statement", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Conditional", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Repeat", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Label", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Operator", { fg = colors.grey2 })
    vim.api.nvim_set_hl(0, "Keyword", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Exception", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "PreProc", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Include", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Define", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Macro", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "PreCondit", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Type", { fg = colors.cyan })
    vim.api.nvim_set_hl(0, "StorageClass", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Structure", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Typedef", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Special", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "SpecialChar", { fg = colors.orange })
    vim.api.nvim_set_hl(0, "Tag", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Delimiter", { fg = colors.grey2 })
    vim.api.nvim_set_hl(0, "SpecialComment", { fg = colors.grey })
    vim.api.nvim_set_hl(0, "Debug", { fg = colors.pink })
    vim.api.nvim_set_hl(0, "Underlined", { underline = true })
    vim.api.nvim_set_hl(0, "Ignore", { fg = colors.grey2 })
    vim.api.nvim_set_hl(0, "Error", { fg = colors.red, bg = colors.white })
    vim.api.nvim_set_hl(0, "Todo", { fg = colors.cyan2, bg = colors.white, bold = true })
end

setup_highlights()
