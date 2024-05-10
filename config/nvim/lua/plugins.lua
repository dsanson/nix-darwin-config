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
  'sprockmonty/wal.vim', -- colorschemes
  'reedes/vim-litecorrect', -- autocorrect as you type
  'ludovicchabant/vim-gutentags',
  'folke/twilight.nvim', -- dim inactive paragraph
  'farmergreg/vim-lastplace', -- restore cursor position
  'junegunn/vim-easy-align', -- align by character: 'v<enter>|'
  'jszakmeister/vim-togglecursor', -- toggle cursor in insert mode in terminals
  'tpope/vim-speeddating', -- increment and decrement dates
  'vim-scripts/utl.vim', -- generalized link/file/document opener
  'sainnhe/gruvbox-material', --color scheme
  'tomtom/tcomment_vim', -- toggle comments (gcc, vgc...)
  --'tpope/vim-repeat', -- extend repeat '.' to include stuff in mappings
  'rhysd/conflict-marker.vim',
  'airblade/vim-gitgutter',
  'chrisbra/csv.vim', -- replaced by treesitter? csv syntax and filetype plugin
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
    build = 'make',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension('fzf')
    end
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

-- require("nvim-treesitter.configs").setup({
--   highlight = {
--     enable = true,
--     disable = function(lang, buf)
--       local max_filesize = 300 * 1024 -- 300 KB
--       local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
--       if ok and stats and stats.size > max_filesize then
--         return true
--       end
--     end,
--   },
--   indent = { enable = true, disable = {"markdown"} },
-- })
--


--
--   use {
--     "jakewvincent/mkdnflow.nvim",
--     config = function()
--       require('mkdnflow').setup({
--           modules = {
--               bib = false,
--               buffers = false, 
--               conceal = false,
--               cursor = true,
--               folds = false,
--               links = true,
--               lists = true,
--               maps = true,
--               paths = true,
--               tables = true,
--               yaml = false,
--           },
--           filetypes = {md = true, rmd = true, markdown = true, pandoc = true},
--           create_dirs = true,             
--           perspective = {
--               priority = 'root',
--               fallback = 'first',
--               root_tell = '.root',
--               nvim_wd_heel = false,
--               update = false
--           },    
--           wrap = false,
--           silent = false,
--           links = {
--               style = 'markdown',
--               name_is_source = false,
--               conceal = false,
--               context = 0,
--               implicit_extension = 'md',
--               transform_implicit = false,
--               transform_explicit = false, 
--           },
--           new_file_template = {
--               use_template = false,
--               placeholders = {
--                   before = {
--                       title = "link_title",
--                       date = "os_date"
--                   },
--                   after = {}
--               },
--               template = "# {{ title }}"
--           },
--           to_do = {
--               symbols = {' ', '-', 'X'},
--               update_parents = true,
--               not_started = ' ',
--               in_progress = '-',
--               complete = 'X'
--           },
--           tables = {
--               trim_whitespace = true,
--               format_on_move = true,
--               auto_extend_rows = false,
--               auto_extend_cols = false
--           },
--           yaml = {
--               bib = { override = false }
--           },
--           mappings = {
--               MkdnEnter = {{'n', 'v'}, '<CR>'},
--               MkdnTab = false,
--               MkdnSTab = false,
--               MkdnNextLink = {'n', '<Tab>'},
--               MkdnPrevLink = {'n', '<S-Tab>'},
--               MkdnNextHeading = {'n', ']]'},
--               MkdnPrevHeading = {'n', '[['},
--               MkdnGoBack = false,
--               MkdnGoForward = false,
--               MkdnCreateLink = false, -- see MkdnEnter
--               MkdnCreateLinkFromClipboard = {{'n', 'v'}, '<leader>p'}, -- see MkdnEnter
--               MkdnFollowLink = false, -- see MkdnEnter
--               MkdnDestroyLink = {'n', '<M-CR>'},
--               MkdnTagSpan = {'v', '<M-CR>'},
--               MkdnMoveSource = {'n', '<F2>'},
--               MkdnYankAnchorLink = {'n', 'yaa'},
--               MkdnYankFileAnchorLink = {'n', 'yfa'},
--               MkdnIncreaseHeading = {'n', '+'},
--               MkdnDecreaseHeading = {'n', '-'},
--               MkdnToggleToDo = {{'n', 'v'}, '<C-Space>'},
--               MkdnNewListItem = false,
--               MkdnNewListItemBelowInsert = {'n', 'o'},
--               MkdnNewListItemAboveInsert = {'n', 'O'},
--               MkdnExtendList = false,
--               MkdnUpdateNumbering = {'n', '<leader>nn'},
--               MkdnTableNextCell = {'i', '<Tab>'},
--               MkdnTablePrevCell = {'i', '<S-Tab>'},
--               MkdnTableNextRow = false,
--               MkdnTablePrevRow = {'i', '<M-CR>'},
--               MkdnTableNewRowBelow = {'n', '<leader>ir'},
--               MkdnTableNewRowAbove = {'n', '<leader>iR'},
--               MkdnTableNewColAfter = {'n', '<leader>ic'},
--               MkdnTableNewColBefore = {'n', '<leader>iC'},
--               MkdnFoldSection = {'n', '<leader>f'},
--               MkdnUnfoldSection = {'n', '<leader>F'}
--           }
--       })
--     end
--   }
-- }

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      ---require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  mapping = {
    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c'}),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<tab>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'cmp_pandoc' },
    { name = 'marksman' },
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

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.

-- lspconfig
local lsp = require "lspconfig"
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

lsp.marksman.setup{}

-- colorscheme
vim.opt.termguicolors = true
-- vim.cmd('source ~/.vimrc_background')
vim.cmd('colorscheme wal')

-- litecorrect
vim.g.user_dict    = {
  maybe        = {'mabye'},
  ['then']     = {'hten'},
  homogeneous  = {'homogenous'},
  possibility  = {'possiblity'},
  qaḍḍiya      = {'qaddiya'},
  ḥikāya       = {'hikaya'},
  kalām        = {'kalam'},
  Kalām        = {'Kalam'},
  ḥadīth       = {'hadith'},
  inshāʾ       = {'insha'},
  faḥwā        = {'fahwa'},
  qaḍiyya      = {'qadiyya'},
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
  Taftazānī    = {'Taftazani'},
  Kātibī       = {'Katibi'},
  Samarqandī   = {'Samarqandi'},
  Jurjānī      = {'Jurjani'},
  Kammūna      = {'Kammuna'},
  Qādī         = {'Qadi'},
  Jabbār       = {'Jabbar'},
  Sakākī       = {'Sakaki'},
  Muʿtazilah   = {'Mutazilah'},
  Qurʾān       = {'Quran'},
  Yaḥyá        = {'Yahya'},
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
  Muʿtazilī    = {'Mutazili'},
  Muʿtazilī    = {'Mutazali'},
  Mutakallimūn = {'Mutakallimun'},
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

