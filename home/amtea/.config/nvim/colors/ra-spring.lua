-- Ra Spring Theme for Neovim
-- A clean, light theme converted from VSCode's Ra Spring

local M = {}

-- Color Palette
local colors = {
  white = "#ffffff",
  black = "#000000",
  dark_gray = "#303030",
  medium_gray = "#777777",
  light_gray = "#bbbbbb",
  very_light_gray = "#f0f0f0",
  sidebar_bg = "#f8f8f8",
  status_line_bg = "#e8e8e8",
  blue = "#0066CC",
  green = "#009900",
  orange = "#CC6600",
  purple = "#883399",
  teal = "#009999",
  pink = "#CC66CC",
  red = "#FF6666",
  yellow = "#CCCC00",
  comments = "#AAAAAA",
  warning = "#e9a700",
  error = "#e51400",

  -- Various transparent colors for overlays
  selection = "#00000020",
  line_highlight = "#00000008",
  highlight_bg = "#00000010",
  find_highlight = "#00000030",

  -- Border colors
  border = "#00000018",
}

    -- local palette = {
    --        'black':      ['#181819',   '232'],
    --        'bg_dim':     ['#222327',   '232'],
    --        'bg0':        ['#2c2e34',   '235'],
    --        'bg1':        ['#33353f',   '236'],
    --        'bg2':        ['#363944',   '236'],
    --        'bg3':        ['#3b3e48',   '237'],
    --        'bg4':        ['#414550',   '237'],
    --        'bg_red':     ['#ff6077',   '203'],
    --        'diff_red':   ['#55393d',   '52'],
    --        'bg_green':   ['#a7df78',   '107'],
    --        'diff_green': ['#394634',   '22'],
    --        'bg_blue':    ['#85d3f2',   '110'],
    --        'diff_blue':  ['#354157',   '17'],
    --        'diff_yellow':['#4e432f',   '54'],
    --        'fg':         ['#e2e2e3',   '250'],
    --        'red':        ['#fc5d7c',   '203'],
    --        'orange':     ['#f39660',   '215'],
    --        'yellow':     ['#e7c664',   '179'],
    --        'green':      ['#9ed072',   '107'],
    --        'blue':       ['#76cce0',   '110'],
    --        'purple':     ['#b39df3',   '176'],
    --        'grey':       ['#7f8490',   '246'],
    --        'grey_dim':   ['#595f6f',   '240'],
    --        'none':       ['NONE',      'NONE']
    --        }
function M.setup()
  -- Reset all highlights
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end

  vim.g.colors_name = "ra-spring"
  vim.o.background = "light"

  -- Check for termguicolors support and enable it
  if vim.fn.has("termguicolors") == 1 then
    vim.o.termguicolors = true
  end

  local highlight = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- Editor UI Elements
  highlight("Normal", { fg = colors.dark_gray, bg = colors.white })
  highlight("NormalFloat", { fg = colors.dark_gray, bg = colors.white })
  highlight("Cursor", { fg = colors.white, bg = colors.dark_gray })
  highlight("CursorLine", { bg = colors.line_highlight })
  highlight("CursorColumn", { bg = colors.line_highlight })
  highlight("ColorColumn", { bg = colors.line_highlight })
  highlight("LineNr", { fg = colors.light_gray })
  highlight("CursorLineNr", { fg = colors.medium_gray })
  highlight("SignColumn", { bg = colors.white })
  highlight("Folded", { fg = colors.medium_gray, bg = colors.very_light_gray })
  highlight("FoldColumn", { fg = colors.medium_gray, bg = colors.white })
  highlight("VertSplit", { fg = colors.border, bg = colors.white })
  highlight("StatusLine", { fg = colors.dark_gray, bg = colors.status_line_bg })
  highlight("StatusLineNC", { fg = colors.medium_gray, bg = colors.very_light_gray })
  highlight("Search", { bg = colors.find_highlight })
  highlight("IncSearch", { bg = colors.find_highlight, bold = true })
  highlight("Visual", { bg = colors.selection })
  highlight("VisualNOS", { bg = colors.selection })
  highlight("NonText", { fg = colors.light_gray })
  highlight("SpecialKey", { fg = colors.light_gray })
  highlight("Title", { fg = colors.blue, bold = true })
  highlight("Directory", { fg = colors.blue })
  highlight("MatchParen", { bg = colors.highlight_bg, bold = true })
  highlight("Conceal", { fg = colors.medium_gray })

  -- Popup menu
  highlight("Pmenu", { fg = colors.dark_gray, bg = colors.very_light_gray })
  highlight("PmenuSel", { fg = colors.dark_gray, bg = colors.white })
  highlight("PmenuSbar", { bg = colors.very_light_gray })
  highlight("PmenuThumb", { bg = colors.medium_gray })

  -- Tabs
  highlight("TabLine", { fg = colors.dark_gray, bg = colors.very_light_gray })
  highlight("TabLineFill", { fg = colors.dark_gray, bg = colors.very_light_gray })
  highlight("TabLineSel", { fg = colors.dark_gray, bg = colors.white })

  -- Spelling
  highlight("SpellBad", { undercurl = true, sp = colors.red })
  highlight("SpellCap", { undercurl = true, sp = colors.yellow })
  highlight("SpellLocal", { undercurl = true, sp = colors.blue })
  highlight("SpellRare", { undercurl = true, sp = colors.purple })

  -- Diff
  highlight("DiffAdd", { fg = colors.green, bg = colors.white })
  highlight("DiffChange", { fg = colors.blue, bg = colors.white })
  highlight("DiffDelete", { fg = colors.red, bg = colors.white })
  highlight("DiffText", { fg = colors.dark_gray, bg = colors.highlight_bg })

  -- Messages
  highlight("ErrorMsg", { fg = colors.red })
  highlight("WarningMsg", { fg = colors.warning })
  highlight("MoreMsg", { fg = colors.blue })
  highlight("Question", { fg = colors.blue })

  -- Diagnostics
  highlight("DiagnosticError", { fg = colors.red })
  highlight("DiagnosticWarn", { fg = colors.warning })
  highlight("DiagnosticInfo", { fg = colors.blue })
  highlight("DiagnosticHint", { fg = colors.green })
  highlight("DiagnosticUnderlineError", { undercurl = true, sp = colors.red })
  highlight("DiagnosticUnderlineWarn", { undercurl = true, sp = colors.warning })
  highlight("DiagnosticUnderlineInfo", { undercurl = true, sp = colors.blue })
  highlight("DiagnosticUnderlineHint", { undercurl = true, sp = colors.green })

  -- Syntax Highlighting
  highlight("Comment", { fg = colors.comments })
  highlight("Constant", { fg = colors.orange })
  highlight("String", { fg = colors.orange })
  highlight("Character", { fg = colors.blue })
  highlight("Number", { fg = colors.orange })
  highlight("Boolean", { fg = colors.blue })
  highlight("Float", { fg = colors.orange })

  highlight("Identifier", { fg = colors.green })
  highlight("Function", { fg = colors.purple })

  highlight("Statement", { fg = colors.blue })
  highlight("Conditional", { fg = colors.blue })
  highlight("Repeat", { fg = colors.blue })
  highlight("Label", { fg = colors.blue })
  highlight("Operator", { fg = colors.dark_gray })
  highlight("Keyword", { fg = colors.blue })
  highlight("Exception", { fg = colors.blue })

  highlight("PreProc", { fg = colors.blue })
  highlight("Include", { fg = colors.blue })
  highlight("Define", { fg = colors.blue })
  highlight("Macro", { fg = colors.blue })
  highlight("PreCondit", { fg = colors.blue })

  highlight("Type", { fg = colors.teal })
  highlight("StorageClass", { fg = colors.blue })
  highlight("Structure", { fg = colors.blue })
  highlight("Typedef", { fg = colors.blue })

  highlight("Special", { fg = colors.purple })
  highlight("SpecialChar", { fg = colors.orange })
  highlight("Tag", { fg = colors.blue })
  highlight("Delimiter", { fg = colors.dark_gray })
  highlight("SpecialComment", { fg = colors.comments, bold = true })
  highlight("Debug", { fg = colors.pink })

  highlight("Underlined", { underline = true })
  highlight("Ignore", { fg = colors.light_gray })
  highlight("Error", { fg = colors.red })
  highlight("Todo", { fg = colors.purple, bold = true })

  -- TreeSitter Syntax Highlighting
  highlight("@comment", { link = "Comment" })
  highlight("@error", { link = "Error" })
  highlight("@none", { bg = "NONE", fg = "NONE" })
  highlight("@preproc", { link = "PreProc" })
  highlight("@define", { link = "Define" })
  highlight("@operator", { link = "Operator" })

  -- Punctuation
  highlight("@punctuation.delimiter", { fg = colors.dark_gray })
  highlight("@punctuation.bracket", { fg = colors.dark_gray })
  highlight("@punctuation.special", { fg = colors.blue })

  -- Literals
  highlight("@string", { link = "String" })
  highlight("@string.regex", { fg = colors.orange })
  highlight("@string.escape", { fg = colors.orange, bold = true })
  highlight("@string.special", { fg = colors.orange })
  highlight("@character", { link = "Character" })
  highlight("@character.special", { fg = colors.orange })
  highlight("@boolean", { link = "Boolean" })
  highlight("@number", { link = "Number" })
  highlight("@float", { link = "Float" })

  -- Functions
  highlight("@function", { link = "Function" })
  highlight("@function.builtin", { fg = colors.purple })
  highlight("@function.call", { fg = colors.purple })
  highlight("@function.macro", { fg = colors.purple })
  highlight("@method", { fg = colors.purple })
  highlight("@method.call", { fg = colors.purple })
  highlight("@constructor", { fg = colors.teal })
  highlight("@parameter", { fg = colors.green })

  -- Keywords
  highlight("@keyword", { link = "Keyword" })
  highlight("@keyword.function", { fg = colors.blue })
  highlight("@keyword.operator", { fg = colors.blue })
  highlight("@keyword.return", { fg = colors.blue })
  highlight("@conditional", { link = "Conditional" })
  highlight("@repeat", { link = "Repeat" })
  highlight("@debug", { link = "Debug" })
  highlight("@label", { link = "Label" })
  highlight("@include", { link = "Include" })
  highlight("@exception", { link = "Exception" })

  -- Types
  highlight("@type", { link = "Type" })
  highlight("@type.builtin", { fg = colors.teal })
  highlight("@type.definition", { fg = colors.teal })
  highlight("@type.qualifier", { fg = colors.blue })
  highlight("@storageclass", { link = "StorageClass" })
  highlight("@attribute", { fg = colors.green })
  highlight("@field", { fg = colors.green })
  highlight("@property", { fg = colors.green })

  -- Identifiers
  highlight("@variable", { fg = colors.dark_gray })
  highlight("@variable.builtin", { fg = colors.blue })
  highlight("@constant", { fg = colors.orange })
  highlight("@constant.builtin", { fg = colors.blue })
  highlight("@constant.macro", { fg = colors.orange })
  highlight("@namespace", { fg = colors.teal })
  highlight("@symbol", { fg = colors.green })

  -- Text
  highlight("@text", { fg = colors.dark_gray })
  highlight("@text.strong", { bold = true })
  highlight("@text.emphasis", { italic = true })
  highlight("@text.underline", { underline = true })
  highlight("@text.strike", { strikethrough = true })
  highlight("@text.title", { fg = colors.blue, bold = true })
  highlight("@text.literal", { fg = colors.orange })
  highlight("@text.uri", { fg = colors.blue, underline = true })
  highlight("@text.math", { fg = colors.blue })
  highlight("@text.reference", { fg = colors.teal })
  highlight("@text.todo", { link = "Todo" })
  highlight("@text.note", { fg = colors.blue, bold = true })
  highlight("@text.warning", { fg = colors.warning, bold = true })
  highlight("@text.danger", { fg = colors.red, bold = true })

  -- Tags
  highlight("@tag", { link = "Tag" })
  highlight("@tag.attribute", { fg = colors.green })
  highlight("@tag.delimiter", { fg = colors.dark_gray })

  -- LSP Semantic Tokens
  highlight("@lsp.type.namespace", { link = "@namespace" })
  highlight("@lsp.type.type", { link = "@type" })
  highlight("@lsp.type.class", { link = "@type" })
  highlight("@lsp.type.enum", { link = "@type" })
  highlight("@lsp.type.interface", { link = "@type" })
  highlight("@lsp.type.struct", { link = "@type" })
  highlight("@lsp.type.parameter", { link = "@parameter" })
  highlight("@lsp.type.variable", { link = "@variable" })
  highlight("@lsp.type.property", { link = "@property" })
  highlight("@lsp.type.enumMember", { link = "@constant" })
  highlight("@lsp.type.function", { link = "@function" })
  highlight("@lsp.type.method", { link = "@method" })
  highlight("@lsp.type.macro", { link = "@function.macro" })
  highlight("@lsp.type.keyword", { link = "@keyword" })
  highlight("@lsp.type.comment", { link = "@comment" })
  highlight("@lsp.type.string", { link = "@string" })
  highlight("@lsp.type.number", { link = "@number" })
  highlight("@lsp.type.regexp", { link = "@string.regex" })
  highlight("@lsp.type.operator", { link = "@operator" })
  highlight("@lsp.type.decorator", { link = "@attribute" })
  highlight("@lsp.type.builtinType", { link = "@type.builtin" })
  highlight("@lsp.type.typeParameter", { link = "@type" })
  highlight("@lsp.type.lifetime", { link = "@storageclass" })
  highlight("@lsp.type.escapeSequence", { link = "@string.escape" })
  highlight("@lsp.type.formatSpecifier", { link = "@punctuation.special" })
  highlight("@lsp.type.comment.documentation", { link = "@comment" })
  highlight("@lsp.type.unresolvedReference", { link = "@error" })
  highlight("@lsp.type.boolean", { link = "@boolean" })

  -- Plugin: nvim-cmp
  highlight("CmpItemAbbr", { fg = colors.dark_gray })
  highlight("CmpItemAbbrDeprecated", { fg = colors.light_gray, strikethrough = true })
  highlight("CmpItemAbbrMatch", { fg = colors.blue, bold = true })
  highlight("CmpItemAbbrMatchFuzzy", { fg = colors.blue, bold = true })
  highlight("CmpItemKind", { fg = colors.medium_gray })
  highlight("CmpItemKindClass", { fg = colors.teal })
  highlight("CmpItemKindColor", { fg = colors.orange })
  highlight("CmpItemKindConstant", { fg = colors.orange })
  highlight("CmpItemKindConstructor", { fg = colors.teal })
  highlight("CmpItemKindEnum", { fg = colors.teal })
  highlight("CmpItemKindEnumMember", { fg = colors.orange })
  highlight("CmpItemKindEvent", { fg = colors.purple })
  highlight("CmpItemKindField", { fg = colors.green })
  highlight("CmpItemKindFile", { fg = colors.blue })
  highlight("CmpItemKindFolder", { fg = colors.blue })
  highlight("CmpItemKindFunction", { fg = colors.purple })
  highlight("CmpItemKindInterface", { fg = colors.teal })
  highlight("CmpItemKindKeyword", { fg = colors.blue })
  highlight("CmpItemKindMethod", { fg = colors.purple })
  highlight("CmpItemKindModule", { fg = colors.teal })
  highlight("CmpItemKindOperator", { fg = colors.blue })
  highlight("CmpItemKindProperty", { fg = colors.green })
  highlight("CmpItemKindReference", { fg = colors.medium_gray })
  highlight("CmpItemKindSnippet", { fg = colors.yellow })
  highlight("CmpItemKindStruct", { fg = colors.teal })
  highlight("CmpItemKindText", { fg = colors.dark_gray })
  highlight("CmpItemKindTypeParameter", { fg = colors.teal })
  highlight("CmpItemKindUnit", { fg = colors.orange })
  highlight("CmpItemKindValue", { fg = colors.orange })
  highlight("CmpItemKindVariable", { fg = colors.green })
  highlight("CmpItemMenu", { fg = colors.medium_gray })

  -- Plugin: Telescope
  highlight("TelescopeNormal", { fg = colors.dark_gray, bg = colors.white })
  highlight("TelescopeBorder", { fg = colors.border, bg = colors.white })
  highlight("TelescopePromptBorder", { fg = colors.border, bg = colors.white })
  highlight("TelescopeResultsBorder", { fg = colors.border, bg = colors.white })
  highlight("TelescopePreviewBorder", { fg = colors.border, bg = colors.white })
  highlight("TelescopeMatching", { fg = colors.blue, bold = true })
  highlight("TelescopePromptPrefix", { fg = colors.purple })
  highlight("TelescopeSelection", { bg = colors.very_light_gray })
  highlight("TelescopeSelectionCaret", { fg = colors.blue })

  -- Plugin: NvimTree
  highlight("NvimTreeNormal", { fg = colors.dark_gray, bg = colors.sidebar_bg })
  highlight("NvimTreeRootFolder", { fg = colors.blue, bold = true })
  highlight("NvimTreeFolderName", { fg = colors.blue })
  highlight("NvimTreeFolderIcon", { fg = colors.blue })
  highlight("NvimTreeEmptyFolderName", { fg = colors.medium_gray })
  highlight("NvimTreeOpenedFolderName", { fg = colors.blue, bold = true })
  highlight("NvimTreeIndentMarker", { fg = colors.light_gray })
  highlight("NvimTreeGitDirty", { fg = colors.orange })
  highlight("NvimTreeGitNew", { fg = colors.green })
  highlight("NvimTreeGitDeleted", { fg = colors.red })
  highlight("NvimTreeSpecialFile", { fg = colors.purple, underline = true })
  highlight("NvimTreeExecFile", { fg = colors.green, bold = true })
  highlight("NvimTreeImageFile", { fg = colors.purple })

  -- Plugin: GitSigns
  highlight("GitSignsAdd", { fg = colors.green })
  highlight("GitSignsChange", { fg = colors.blue })
  highlight("GitSignsDelete", { fg = colors.red })
  highlight("GitSignsCurrentLineBlame", { fg = colors.medium_gray, italic = true })

  -- Plugin: Git Blame
  highlight("GitBlame", { fg = colors.medium_gray, italic = true })

  -- Plugin: Diffview
  highlight("DiffviewFilePanelTitle", { fg = colors.blue, bold = true })
  highlight("DiffviewFilePanelCounter", { fg = colors.purple, bold = true })
  highlight("DiffviewFilePanelFileName", { fg = colors.dark_gray })
  highlight("DiffviewNormal", { link = "NvimTreeNormal" })
  highlight("DiffviewCursorLine", { bg = colors.line_highlight })
  highlight("DiffviewVertSplit", { fg = colors.border, bg = colors.white })
  highlight("DiffviewSignColumn", { bg = colors.sidebar_bg })
  highlight("DiffviewStatusLine", { bg = colors.status_line_bg, fg = colors.dark_gray })
  highlight("DiffviewStatusLineNC", { bg = colors.very_light_gray, fg = colors.medium_gray })
  highlight("DiffviewEndOfBuffer", { fg = colors.sidebar_bg, bg = colors.sidebar_bg })
  highlight("DiffviewFilePanelRootPath", { fg = colors.blue, italic = true })
  highlight("DiffviewFilePanelPath", { fg = colors.medium_gray, italic = true })
  highlight("DiffviewFilePanelInsertions", { fg = colors.green })
  highlight("DiffviewFilePanelDeletions", { fg = colors.red })
  highlight("DiffviewStatusAdded", { fg = colors.green })
  highlight("DiffviewStatusUntracked", { fg = colors.blue })
  highlight("DiffviewStatusModified", { fg = colors.orange })
  highlight("DiffviewStatusRenamed", { fg = colors.purple })
  highlight("DiffviewStatusCopied", { fg = colors.blue })
  highlight("DiffviewStatusTypeChange", { fg = colors.yellow })
  highlight("DiffviewStatusUnmerged", { fg = colors.orange })
  highlight("DiffviewStatusUnknown", { fg = colors.red })
  highlight("DiffviewStatusDeleted", { fg = colors.red })
  highlight("DiffviewStatusBroken", { fg = colors.red })

  -- Plugin: Fugitive
  highlight("fugitiveHeader", { fg = colors.blue, bold = true })
  highlight("fugitiveHeading", { fg = colors.purple, bold = true })
  highlight("fugitiveHunk", { fg = colors.medium_gray })
  highlight("fugitiveSymbolicRef", { fg = colors.blue })
  highlight("fugitiveCount", { fg = colors.purple })
  highlight("fugitiveInstruction", { fg = colors.blue, italic = true })
  highlight("fugitiveStagedHeading", { fg = colors.green, bold = true })
  highlight("fugitiveStagedModifier", { fg = colors.green })
  highlight("fugitiveUnstagedHeading", { fg = colors.orange, bold = true })
  highlight("fugitiveUnstagedModifier", { fg = colors.orange })
  highlight("fugitiveUntrackedHeading", { fg = colors.blue, bold = true })
  highlight("fugitiveUntrackedModifier", { fg = colors.blue })

  -- Plugin: LuaLine
  highlight("LualineMode", { fg = colors.white, bg = colors.blue, bold = true })
  highlight("LualineModeCommand", { fg = colors.white, bg = colors.purple, bold = true })
  highlight("LualineModeInsert", { fg = colors.white, bg = colors.green, bold = true })
  highlight("LualineModeNormal", { fg = colors.white, bg = colors.blue, bold = true })
  highlight("LualineModeReplace", { fg = colors.white, bg = colors.red, bold = true })
  highlight("LualineModeVisual", { fg = colors.white, bg = colors.purple, bold = true })
  highlight("LualineBranch", { fg = colors.blue, bg = colors.very_light_gray })
  highlight("LualineFileName", { fg = colors.dark_gray, bg = colors.very_light_gray })
  highlight("LualineFileNameModified", { fg = colors.orange, bg = colors.very_light_gray, bold = true })
  highlight("LualineFileNameReadOnly", { fg = colors.red, bg = colors.very_light_gray })
  highlight("LualineProgress", { fg = colors.purple, bg = colors.very_light_gray })
  highlight("LualineLocation", { fg = colors.dark_gray, bg = colors.very_light_gray })
  highlight("LualineFileFormat", { fg = colors.dark_gray, bg = colors.very_light_gray })
  highlight("LualineFileEncoding", { fg = colors.dark_gray, bg = colors.very_light_gray })
  highlight("LualineFileType", { fg = colors.dark_gray, bg = colors.very_light_gray })
  highlight("LualineDiagnosticError", { fg = colors.red, bg = colors.very_light_gray })
  highlight("LualineDiagnosticWarn", { fg = colors.warning, bg = colors.very_light_gray })
  highlight("LualineDiagnosticInfo", { fg = colors.blue, bg = colors.very_light_gray })
  highlight("LualineDiagnosticHint", { fg = colors.green, bg = colors.very_light_gray })

  -- Plugin: LSP
  highlight("LspReferenceText", { bg = colors.highlight_bg })
  highlight("LspReferenceRead", { bg = colors.highlight_bg })
  highlight("LspReferenceWrite", { bg = colors.highlight_bg })
  highlight("LspCodeLens", { fg = colors.medium_gray, italic = true })
  highlight("LspInlayHint", { fg = colors.medium_gray, bg = colors.very_light_gray, italic = true })

  -- Plugin: Mason
  highlight("MasonHeader", { fg = colors.white, bg = colors.blue, bold = true })
  highlight("MasonHeaderSecondary", { fg = colors.white, bg = colors.green, bold = true })
  highlight("MasonHighlight", { fg = colors.blue })
  highlight("MasonHighlightBlock", { fg = colors.white, bg = colors.blue })
  highlight("MasonHighlightBlockBold", { fg = colors.white, bg = colors.blue, bold = true })
  highlight("MasonHighlightSecondary", { fg = colors.green })
  highlight("MasonHighlightBlockSecondary", { fg = colors.white, bg = colors.green })
  highlight("MasonHighlightBlockBoldSecondary", { fg = colors.white, bg = colors.green, bold = true })
  highlight("MasonMuted", { fg = colors.medium_gray })
  highlight("MasonMutedBlock", { fg = colors.white, bg = colors.medium_gray })
  highlight("MasonMutedBlockBold", { fg = colors.white, bg = colors.medium_gray, bold = true })
  highlight("MasonError", { fg = colors.red })

  -- Plugin: Multicursor
  highlight("MultiCursor", { bg = colors.selection, fg = colors.dark_gray })
  highlight("MultiCursorMain", { bg = colors.selection, fg = colors.dark_gray, bold = true })

  -- Plugin: Nvim Surround
  highlight("NvimSurroundHighlight", { bg = colors.highlight_bg })

  -- Plugin: Oil
  highlight("OilDir", { fg = colors.blue })
  highlight("OilDirIcon", { fg = colors.blue })
  highlight("OilLink", { fg = colors.green })
  highlight("OilLinkTarget", { fg = colors.green, italic = true })
  highlight("OilCopy", { fg = colors.blue, bold = true })
  highlight("OilMove", { fg = colors.purple, bold = true })
  highlight("OilChange", { fg = colors.yellow, bold = true })
  highlight("OilCreate", { fg = colors.green, bold = true })
  highlight("OilDelete", { fg = colors.red, bold = true })
  highlight("OilPermissionNone", { fg = colors.light_gray })
  highlight("OilPermissionRead", { fg = colors.medium_gray })
  highlight("OilPermissionWrite", { fg = colors.orange })
  highlight("OilPermissionExecute", { fg = colors.green })

  -- Plugin: LuaSnip
  highlight("LuasnipSnippetActive", { bg = colors.highlight_bg })
  highlight("LuasnipInsert", { fg = colors.green, bold = true })
  highlight("LuasnipChoice", { fg = colors.orange, bold = true })

  -- Extra highlights for specific filetypes
  -- HTML/JSX/TSX
  highlight("htmlTag", { fg = colors.dark_gray })
  highlight("htmlEndTag", { fg = colors.dark_gray })
  highlight("htmlTagName", { fg = colors.blue })
  highlight("htmlArg", { fg = colors.green })

  -- CSS
  highlight("cssTagName", { fg = colors.blue })
  highlight("cssClassName", { fg = colors.blue })
  highlight("cssIdentifier", { fg = colors.blue })
  highlight("cssProp", { fg = colors.green })
  highlight("cssColor", { fg = colors.orange })
  highlight("cssValueNumber", { fg = colors.orange })
  highlight("cssValueLength", { fg = colors.orange })
  highlight("cssAtRule", { fg = colors.blue })

  -- Markdown
  highlight("markdownHeadingDelimiter", { fg = colors.blue, bold = true })
  highlight("markdownH1", { fg = colors.blue, bold = true })
  highlight("markdownH2", { fg = colors.blue, bold = true })
  highlight("markdownH3", { fg = colors.blue, bold = true })
  highlight("markdownH4", { fg = colors.blue, bold = true })
  highlight("markdownH5", { fg = colors.blue, bold = true })
  highlight("markdownH6", { fg = colors.blue, bold = true })
  highlight("markdownCode", { fg = colors.orange })
  highlight("markdownCodeBlock", { fg = colors.orange })
  highlight("markdownBlockquote", { fg = colors.medium_gray, italic = true })
  highlight("markdownListMarker", { fg = colors.blue })
  highlight("markdownOrderedListMarker", { fg = colors.blue })
  highlight("markdownRule", { fg = colors.blue })
  highlight("markdownLinkText", { fg = colors.blue, underline = true })
  highlight("markdownUrl", { fg = colors.blue, underline = true })

  -- Terminal colors
  vim.g.terminal_color_0 = colors.black
  vim.g.terminal_color_1 = colors.red
  vim.g.terminal_color_2 = colors.green
  vim.g.terminal_color_3 = colors.yellow
  vim.g.terminal_color_4 = colors.blue
  vim.g.terminal_color_5 = colors.purple
  vim.g.terminal_color_6 = colors.teal
  vim.g.terminal_color_7 = colors.medium_gray
  vim.g.terminal_color_8 = colors.light_gray
  vim.g.terminal_color_9 = colors.red
  vim.g.terminal_color_10 = colors.green
  vim.g.terminal_color_11 = colors.yellow
  vim.g.terminal_color_12 = colors.blue
  vim.g.terminal_color_13 = colors.purple
  vim.g.terminal_color_14 = colors.teal
  vim.g.terminal_color_15 = colors.white
end

return M
