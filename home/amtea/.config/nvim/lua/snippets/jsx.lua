local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local f = ls.function_node

local function get_visual(_, parent)
    if #parent.snippet.env.SELECT_RAW > 0 then
        return parent.snippet.env.SELECT_RAW -- Если есть выделенный текст, возвращаем его
    else
        return { "" } -- Иначе возвращаем пустую строку
    end
end

ls.add_snippets("all", {
    s("wrap_tag", {
        t("<"), i(1, "tag"), t(">"),  -- Первый вводимый узел: название тега
        d(2, function(_, parent)
            return sn(nil, { t(get_visual(_, parent)) }) -- Подставляет выделенный текст
        end, {}),
        t("</"), f(function(args) return args[1][1] end, { 1 }), t(">"), -- Закрывающий тег
    })
})

