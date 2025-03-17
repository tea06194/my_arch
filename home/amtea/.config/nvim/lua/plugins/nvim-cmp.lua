return {
  {
    "neovim/nvim-lspconfig",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      -- "hrsh7th/cmp-vsnip", -- Закомментировано (Vsnip)
      -- "hrsh7th/vim-vsnip", -- Закомментировано (Vsnip)
      -- "L3MON4D3/LuaSnip", -- Закомментировано (LuaSnip)
      -- "saadparwaiz1/cmp_luasnip", -- Закомментировано (LuaSnip)
      -- "echasnovski/mini.snippets", -- Закомментировано (mini.snippets)
      -- "abeldekat/cmp-mini-snippets", -- Закомментировано (mini.snippets)
      -- "SirVer/ultisnips", -- Закомментировано (UltiSnips)
      -- "quangnguyen30192/cmp-nvim-ultisnips", -- Закомментировано (UltiSnips)
      -- "dcampos/nvim-snippy", -- Закомментировано (Snippy)
      -- "dcampos/cmp-snippy", -- Закомментировано (Snippy)
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- Закомментировано (Vsnip)
            -- require('luasnip').lsp_expand(args.body) -- Закомментировано (LuaSnip)
            -- require('snippy').expand_snippet(args.body) -- Закомментировано (Snippy)
            -- vim.fn["UltiSnips#Anon"](args.body) -- Закомментировано (UltiSnips)
            -- vim.snippet.expand(args.body) -- Закомментировано (Neovim v0.10+)
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          -- { name = "vsnip" }, -- Закомментировано (Vsnip)
          -- { name = "luasnip" }, -- Закомментировано (LuaSnip)
          -- { name = "ultisnips" }, -- Закомментировано (UltiSnips)
          -- { name = "snippy" }, -- Закомментировано (Snippy)
        }, {
          { name = "buffer" },
        })
      })

      cmp.setup.cmdline({"/", "?"}, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        }, {
          { name = "cmdline" }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })
    end,
  },
}
