local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  'folke/which-key.nvim',
  'neovim/nvim-lspconfig',
  -- 'sprockmonty/wal.vim', -- colorschemes
  'ludovicchabant/vim-gutentags',
  'folke/twilight.nvim', -- dim inactive paragraph
  'farmergreg/vim-lastplace', -- restore cursor position
  'junegunn/vim-easy-align', -- align by character: 'v<enter>|'
  'jszakmeister/vim-togglecursor', -- toggle cursor in insert mode in terminals
  'tpope/vim-speeddating', -- increment and decrement dates
  'vim-scripts/utl.vim', -- generalized link/file/document opener
  'sainnhe/gruvbox-material', --color scheme
  -- 'tomtom/tcomment_vim', -- toggle comments (gcc, vgc...)
  --'tpope/vim-repeat', -- extend repeat '.' to include stuff in mappings
  'rhysd/conflict-marker.vim',
  'chrisbra/csv.vim', -- replaced by treesitter? csv syntax and filetype plugin
  'lewis6991/gitsigns.nvim',
  'opdavies/toggle-checkbox.nvim',
  {
    "RedsXDD/neopywal.nvim",
    name = "neopywal",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("neopywal").setup({
        transparent_background = true,
      })
    end,
  },
  {
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
  },
  {
    'reedes/vim-litecorrect', -- autocorrect as you type
    ft = {
      'markdown',
      'pandoc',
      'markdown.pandoc',
    },
  },
  {
    '3rd/image.nvim',
    config = function()
      require('image').setup({
        enabled = true,
        filetypes = { 'markdown', 'vimwiki', 'pandoc' },
      })
    end,
  },
  { 
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-calc',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  },  
  { 
    'justinmk/vim-gtfo', -- open directory for current file in finder (gof) or terminal (got)
    config = function()
      vim.g["gtfo#terminals"] = { mac = "/Users/desanso/Applications/Kitty.app"}
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
        surrounds = {
          ["m"] = {
              add = { "[", "]{.mark}" },
              find = function()
                  return M.get_selection({ pattern = "(%[)().-(]{%.mark})()" })
              end,
              delete = "^(%[)().-(]{%.mark})()$",
          },
          ["f"] = {
              add = { "[", "]{.fragment .highlight-current-green}" },
              find = function()
                  return M.get_selection({ pattern = "(%[)().-(]{%.fragment .highlight-current-red})()" })
              end,
              delete = "^(%[)().-(]{%.mark})()$",
          },
          ["x"] = {
              add = { "[", "]{.fragment .highlight-current-green fragment-index=1}" },
              find = function()
                  return M.get_selection({ pattern = "(%[)().-(]{%.fragment .highlight-current-red})()" })
              end,
              delete = "^(%[)().-(]{%.mark})()$",
          },
        }
      })
    end
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        width = 78, -- width of the Zen window
        height = 1, -- height of the Zen window
        options = {
          signcolumn = "no", -- disable signcolumn
          number = false, -- disable number column
          -- relativenumber = false, -- disable relative numbers
          cursorline = false, -- disable cursorline
          -- cursorcolumn = false, -- disable cursor column
          foldcolumn = "0", -- disable fold column
          -- list = false, -- disable whitespace characters
        },
      },
    }
  },
  { 
    'dsanson/vim-ris', -- RIS bibliography files
    ft = "ris"
  },
  {
    'dag/vim-fish',
    ft = 'fish',
  },
  {
    "lervag/vimtex",
    init = function()
      vim.g.tex_flavor  = 'latex'
      vim.g.tex_conceal = 'abdmgs'
    end,
    ft = 'tex',
  },
  {
    "nvim-lua/popup.nvim",
    dependencies = { "nvim-lua/plenary.nvim", },
  },
  {
    'nvim-telescope/telescope.nvim', 
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim', 
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension('fzf')
    end
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        }
      }
    end,
  },
  {
    "nvim-telescope/telescope-symbols.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", },
  },
  {
    "nvim-telescope/telescope-project.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", },
    config = function() 
      require('telescope').load_extension('project')
    end,
  },
  {
    'crispgm/telescope-heading.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function() 
      require('telescope').load_extension('heading')
    end
  },
  {
    'jvgrootveld/telescope-zoxide',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require("telescope").load_extension('zoxide')
    end
  },
  { 
    "nvim-telescope/telescope-bibtex.nvim",
    dependencies = {'nvim-telescope/telescope.nvim'},
    config = function ()
      require"telescope".setup {
        extensions = {
          bibtex = {
            -- Depth for the *.bib file
            depth = 1,
            -- Custom format for citation label
            custom_formats = {},
            -- Format to use for citation label.
            -- Try to match the filetype by default, or use 'plain'
            format = '',
            -- Path to global bibliographies (placed outside of the project)
            global_files = {'/Users/desanso/Documents/d/research/zotero.bib'},
            -- Define the search keys to use in the picker
            search_keys = { 'author', 'year', 'title' },
            -- Template for the formatted citation
            citation_format = '{{author}} ({{year}}), {{title}}.',
            -- Only use initials for the authors first name
            citation_trim_firstname = true,
            -- Max number of authors to write in the formatted citation
            -- following authors will be replaced by "et al."
            citation_max_auth = 2,
            -- Context awareness disabled by default
            context = false,
            -- Fallback to global/directory .bib files if context not found
            -- This setting has no effect if context = false
            context_fallback = true,
            -- Wrapping in the preview window is disabled by default
            wrap = false,
          },
        }
      }
      require"telescope".load_extension("bibtex")
    end,
  },
  {
    'cameron-wags/rainbow_csv.nvim',
    config = true,
    ft = {
        'csv',
        'tsv',
        'csv_semicolon',
        'csv_whitespace',
        'csv_pipe',
        'rfc_csv',
        'rfc_semicolon'
    },
    cmd = {
        'RainbowDelim',
        'RainbowDelimSimple',
        'RainbowDelimQuoted',
        'RainbowMultiDelim'
    }
  },

  {
   'nat-418/boole.nvim',
    config = function()
      require('boole').setup({
        mappings = {
          increment = '<C-a>',
          decrement = '<C-x>'
        },
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require'todo-comments'.setup()
    end
  },
  {
    "folke/trouble.nvim",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
    opts = {}, -- for default options, refer to the configuration section for custom setup.
  },
  {
    "camspiers/luarocks",
    dependencies = {
      "rcarriga/nvim-notify", -- Optional dependency
    },
    opts = {
      rocks = { "lyaml", "lunajson" } -- Specify LuaRocks packages to install
    }
  },
  {
    dir = '~/Software/cmp-pandoc.nvim',
    ft = {'pandoc', 'markdown', 'rmd', 'markdown.pandoc', 'markdown.pandoc.carnap'},
    dependencies = {
      'nvim-lua/plenary.nvim',
      "camspiers/luarocks",
    },
    config = function() 
      require'cmp_pandoc'.setup({
        filetypes = { "pandoc", "markdown", "rmd", 'markdown.pandoc', 'markdown.pandoc.carnap' },
        bibliography = {
          path = '/Users/desanso/Documents/d/research/zotero.json',
          documentation = true,
          fields = { "type", "title", "author", "year" },
        },
        crossref = {
          documentation = true,
          enable_nabla = false,
        }
      })
    end,
    ft = { "pandoc", "markdown", "rmd", "markdown.pandoc", "markdown.pandoc.carnap" },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function() 
    require("neo-tree").setup {
     close_if_last_window = true,
     window = {
       position = "left",
       width = 30,
     },
     sources = {
       "filesystem",
       "buffers",
       "document_symbols",
     },
     document_symbols = {
       follow_cursor = true,
       renderers = {
         root = {
           {"indent"},
           {"icon", default="" },
           -- {"name", zindex = 0},
         },
         symbol = {
           {"indent", with_expanders = true},
           {"kind_icon", default="" },
           {"container",
           content = {
             {"name", zindex = 10},
             -- {"kind_name", zindex = 20, align = "right"},
             }
           }
         },
       },
       kinds = {
         String = { icon = "", hl = "" }
       },
     },
    }
    end
  },
})


-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<Tab>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources({
    {
      name = 'nvim_lsp',
      option = {
        markdown_oxide = {
          keyword_pattern = [[\(\k\| \|\/\|#\)\+]]
        }
      }
    },
    { name = 'cmp_pandoc' },
    -- { name = 'marksman' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- -- refresh codelens on TextChanged and InsertLeave as well
-- vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave', 'CursorHold', 'LspAttach' }, {
--     pattern = { "*.md", "*.markdown" },
--     buffer = bufnr,
--     callback = vim.lsp.codelens.refresh,
-- })
--
-- -- trigger codelens refresh
-- vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })


-- Setup lspconfig.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

capabilities.workspace = {
    didChangeWatchedFiles = {
      dynamicRegistration = true,
    },
}


-- lspconfig
local lsp = require "lspconfig"

lsp.markdown_oxide.setup({
    capabilities = capabilities, 
    on_attach = on_attach 
})

lsp.bashls.setup {
  capabilities = capabilities
}
lsp.cssls.setup {
  capabilities = capabilities
}
lsp.dotls.setup {
  capabilities = capabilities
}
lsp.eslint.setup {
  capabilities = capabilities
}
lsp.gopls.setup {
  capabilities = capabilities
}
--lsp.hls.setup {
--   capabilities = capabilities
--}
lsp.html.setup {
  capabilities = capabilities
}
lsp.jsonls.setup {
  capabilities = capabilities
}
lsp.pyright.setup {
  capabilities = capabilities
}
lsp.r_language_server.setup {
  capabilities = capabilities
}
lsp.nil_ls.setup {
  capabilities = capabilities
}
lsp.vimls.setup {
  capabilities = capabilities
}
lsp.yamlls.setup {
  capabilities = capabilities
}
lsp.lua_ls.setup {}

lsp.ltex.setup{
  on_attach = on_attach,
  autostart = true,
  filetypes = { 'markdown', 'tex', 'plaintex', 'rst'  },
  settings = {
    ltex = {
      disabledRules = {
        ["en"]    = { "MORFOLOGIK_RULE_EN", "WHITESPACE_RULE" },
        ["en-US"] = { "MORFOLOGIK_RULE_EN_US", "WHITESPACE_RULE" },
      },
    },
  },
}

lsp.lemminx.setup{}

--lsp.marksman.setup{}

-- colorscheme
local neopywal = require("neopywal")
neopywal.setup()
--vim.cmd.colorscheme("neopywal")

-- litecorrect
vim.g.user_dict    = {
  maybe        = {'mabye'},
  homogeneous  = {'homogenous'},
  possibility  = {'possiblity'},
  qaḍiyya      = {'qadiyya'},
  ḥikāya       = {'hikaya'},
  kalām        = {'kalam'},
  Kalām        = {'Kalam'},
  ḥadīth       = {'hadith'},
  inshāʾ       = {'insha'},
  faḥwā        = {'fahwa'},
  maʿnā        = {'mana'},
  maʿānī       = {'maani'},
  maḍmūn       = {'madmun'},
  ḥukman       = {'hukman'},
  ḥaqīqiya     = {'haqiqiya'},
  lafẓ         = {'lafz'},
  khārjiyya    = {'kharjiyya'},
  Dawānī       = {'Dawani'},
  Jalāl        = {'Jalal'},
  Āmidī        = {'Amidi'},
  Ḥillī        = {'Hilli'},
  Dashtakī     = {'Dashtaki'},
  Astarābādī   = {'Astarabadi'},
  Ṭūsī         = {'Tusi'},
  Abharī       = {'Abhari'},
  Taftāzānī    = {'Taftazani'},
  Kātibī       = {'Katibi'},
  Samarqandī   = {'Samarqandi'},
  Jurjānī      = {'Jurjani'},
  Kammūna      = {'Kammuna'},
  Qādī         = {'Qadi'},
  Jabbār       = {'Jabbar'},
  Sakākī       = {'Sakaki'},
  Muʿtazilah   = {'Mutazilah'},
  Qurʾān       = {'Quran'},
  Yaḥyā        = {'Yahya'},
  ʿAdī         = {'Adi'},
  Sirāfī       = {'Sirafi'},
  Tawḥīdī      = {'Tawhidi'},
  Fārābī       = {'Farabi'},
  Abū          = {'Abu'},
  Mattā        = {'Matta'},
  Baghdādī     = {'Baghdadi'},
  Baṣrī        = {'Basri'},
  Ashʿarī      = {'Ashari'},
  Muʿtazila    = {'Mutazila'},
  Muʿtazilī    = {'Mutazili', 'Mutazali'},
  Mutakallimūn = {'Mutakallimun','Mutakalimun'},
  Bāqillānī    = {'Baqillani'},
  Muḥammad     = {'Muhammad', 'Muhammed'},
  Shīʿite      = {'Shiite'},
  Shīʿism      = {'Shiism'},
  Shīʿa        = {'Shia'},
  tawḥīd       = {'tawhid'},
  Qūshjī       = {'Qushji'},
  ʿanhu        = {'anhu'},
  Tajrīd       = {'Tajrid'},
  Rāzī         = {'Razi'},
  Ījī          = {'Iji'},
  Ghazālī      = {'Ghazali'},
  Sīnā         = {'Sina'},
  Naẓẓām       = {'Nazzam'},
  taṣdīq       = {'tasdiq'},
  taṣawwur     = {'tasawwur'},
  Qusṭās       = {'Qustas'},
  Sharḥ        = {'Sharh'},
} 

vim.cmd([[
  augroup litecorrect
    autocmd!
    autocmd FileType markdown call litecorrect#init(g:user_dict)
    autocmd FileType pandoc call litecorrect#init(g:user_dict)
  augroup END
]])

require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    },
    heading = {
      treesitter = true,
    },
    bookmarks = {
      selected_browser = 'firefox',
    },
  }
}

