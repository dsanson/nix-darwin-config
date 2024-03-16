local g  = vim.g
local o  = vim.o
local wo = vim.wo
local bo = vim.bo

-- packer bootstrap
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- packer autoupdate
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

require('packer').startup(function()

  use 'wbthomason/packer.nvim' -- Packer can manage itself

  use 'neovim/nvim-lspconfig' -- configuration of vim lsp client

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all"
        ensure_installed = {
          "bash",
          "bibtex",
          "c",
          "css",
          "dockerfile",
          "dot",
          "fish",
          "gitignore",
          "haskell",
          "html",
          "javascript",
          "json",
          "latex",
          "lua",
          "make",
          "markdown",
          "nix",
          "python",
          "r",
          "ruby",
          "rust",
          "scss",
          "vim",
          "yaml"
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        -- List of parsers to ignore installing (for "all")
        -- ignore_install = { "javascript" },

        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

        highlight = {
          -- `false` will disable the whole extension
          enable = true,

          -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
          -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
          -- the name of the parser)
          -- list of language that will be disabled
          -- disable = { "c", "rust" },
          -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
          disable = function(lang, buf)
            local max_filesize = 300 * 1024 -- 300 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        indent = {
          enable = true,
          disable = {"markdown"}
        },
      }
    end
  }

  -- completions
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-calc'
  -- use 'cbarrete/completion-vcard'
  -- use 'dmitmel/cmp-digraphs'
  use 'hrsh7th/nvim-cmp'
  --- use 'dylanaraps/wal.vim'
  use 'sprockmonty/wal.vim'
  
  use { 
    'nat-418/boole.nvim',
    config = function() 
      require('boole').setup({
        mappings = {
          increment = '<C-a>',
          decrement = '<C-x>'
        },
      })
    end 
  }


  -- translation
  use { 
    'uga-rosa/translate.nvim',
    config = function()
      require("translate").setup({
        default = {
            command = "deepl_free",
            output = "insert",
        },
        preset = {
            output = {
                insert = {
                    base = "bottom",
                    off = 1,
                },
            },
        },
      })
      vim.g['deepl_api_auth_key'] = 'e2a67d25-a60b-4fc6-8a20-2e1a8eed33c1:fx'
    end 
  }
  -- snippets
  -- use 'L3MON4D3/LuaSnip'
  -- use 'saadparwaiz1/cmp_luasnip'

  -- use({
	-- "L3MON4D3/LuaSnip",
	-- -- follow latest release.
	-- tag = "v1.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- -- install jsregexp (optional!:).
	-- run = "make install_jsregexp",
  --   config = function() 
  --      require("luasnip.loaders.from_snipmate").lazy_load()
  --      require("luasnip").add_snippets('pandoc', snippets)
  --   end 
  -- })

  -- tags
  use 'ludovicchabant/vim-gutentags'


  use 'nvim-lua/plenary.nvim'
  use { 
    'nvim-lua/popup.nvim', 
    requires = 'nvim-lua/plenary.nvim'
  }
 
  -- use {
  --   '~/Software/cmp-pandoc-references',
  --   rocks = {'lunajson'},
  -- }

  use {
    --'aspeddro/cmp-pandoc.nvim',
    '~/Software/cmp-pandoc.nvim',
    use_rocks = {'lyaml','lunajson'},
    ft = {'pandoc', 'markdown', 'rmd', 'markdown.pandoc', 'markdown.pandoc.carnap'},
    requires = {
      'nvim-lua/plenary.nvim',
      -- 'jbyuki/nabla.nvim' -- optional
    },
    config = function() 
      require'cmp_pandoc'.setup({
        -- What types of files cmp-pandoc works.
        -- 'pandoc', 'markdown' and 'rmd' (Rmarkdown)
        -- @type: table of string
        filetypes = { "pandoc", "markdown", "rmd", 'markdown.pandoc', 'markdown.pandoc.carnap' },
        -- Customize bib documentation
        bibliography = {
          -- Global default bibliograph file
          path = '/Users/desanso/Documents/d/research/zotero.json',
          -- Enable bibliography documentation
          -- @type: boolean
          documentation = true,
          -- Fields to show in documentation
          -- @type: table of string
          fields = { "type", "title", "author", "year" },
        },
        -- Crossref
        crossref = {
          -- Enable documetation
          -- @type: boolean
          documentation = true,
          -- Use nabla.nvim to render LaTeX equation to ASCII
          -- @type: boolean
          enable_nabla = false,
        }
      })
    end 
  }


  use {
    'nvim-telescope/telescope-fzf-native.nvim', 
    run = 'make',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension('fzf')
    end
  }
  
  use { "nvim-telescope/telescope-bibtex.nvim",
    requires = {
      {'nvim-telescope/telescope.nvim'},
    },
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
  }

  use {
    'nvim-telescope/telescope-symbols.nvim', 
    requires = { 'nvim-telescope/telescope.nvim' },
  }

  use {
    'nvim-telescope/telescope-project.nvim',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension('project')
    end
  }

  use {
    'jvgrootveld/telescope-zoxide',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require("telescope").load_extension('zoxide')
    end
  }

  use {
    'crispgm/telescope-heading.nvim',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = function() 
      require('telescope').load_extension('heading')
    end
  }

  use {
      'cameron-wags/rainbow_csv.nvim',
      config = function()
          require 'rainbow_csv'.setup()
      end,
      -- optional lazy-loading below
      module = {
          'rainbow_csv',
          'rainbow_csv.fns'
      },
      ft = {
          'csv',
          'tsv',
          'csv_semicolon',
          'csv_whitespace',
          'csv_pipe',
          'rfc_csv',
          'rfc_semicolon'
      }
  }

  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
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
  }

  use 'kkharji/sqlite.lua'

  use {
    'dhruvmanila/telescope-bookmarks.nvim',
    tag = '*',
    -- Uncomment if the selected browser is Firefox, Waterfox or buku
    requires = {
      'kkharji/sqlite.lua',
    },
    config = function() 
      require('telescope').load_extension('bookmarks')
    end,
  }

  use {
    'nvim-telescope/telescope.nvim', 
    requires = { 'nvim-lua/plenary.nvim' },
  }

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- see remappings.lua
      }
    end
  }

  use {
    "jakewvincent/mkdnflow.nvim",
    config = function()
      require('mkdnflow').setup({
          modules = {
              bib = false,
              buffers = false, 
              conceal = false,
              cursor = true,
              folds = false,
              links = true,
              lists = true,
              maps = true,
              paths = true,
              tables = true,
              yaml = false,
          },
          filetypes = {md = true, rmd = true, markdown = true, pandoc = true},
          create_dirs = true,             
          perspective = {
              priority = 'root',
              fallback = 'first',
              root_tell = '.root',
              nvim_wd_heel = false,
              update = false
          },    
          wrap = false,
          silent = false,
          links = {
              style = 'markdown',
              name_is_source = false,
              conceal = false,
              context = 0,
              implicit_extension = 'md',
              transform_implicit = false,
              transform_explicit = false, 
          },
          new_file_template = {
              use_template = false,
              placeholders = {
                  before = {
                      title = "link_title",
                      date = "os_date"
                  },
                  after = {}
              },
              template = "# {{ title }}"
          },
          to_do = {
              symbols = {' ', '-', 'X'},
              update_parents = true,
              not_started = ' ',
              in_progress = '-',
              complete = 'X'
          },
          tables = {
              trim_whitespace = true,
              format_on_move = true,
              auto_extend_rows = false,
              auto_extend_cols = false
          },
          yaml = {
              bib = { override = false }
          },
          mappings = {
              MkdnEnter = {{'n', 'v'}, '<CR>'},
              MkdnTab = false,
              MkdnSTab = false,
              MkdnNextLink = {'n', '<Tab>'},
              MkdnPrevLink = {'n', '<S-Tab>'},
              MkdnNextHeading = {'n', ']]'},
              MkdnPrevHeading = {'n', '[['},
              MkdnGoBack = false,
              MkdnGoForward = false,
              MkdnCreateLink = false, -- see MkdnEnter
              MkdnCreateLinkFromClipboard = {{'n', 'v'}, '<leader>p'}, -- see MkdnEnter
              MkdnFollowLink = false, -- see MkdnEnter
              MkdnDestroyLink = {'n', '<M-CR>'},
              MkdnTagSpan = {'v', '<M-CR>'},
              MkdnMoveSource = {'n', '<F2>'},
              MkdnYankAnchorLink = {'n', 'yaa'},
              MkdnYankFileAnchorLink = {'n', 'yfa'},
              MkdnIncreaseHeading = {'n', '+'},
              MkdnDecreaseHeading = {'n', '-'},
              MkdnToggleToDo = {{'n', 'v'}, '<C-Space>'},
              MkdnNewListItem = false,
              MkdnNewListItemBelowInsert = {'n', 'o'},
              MkdnNewListItemAboveInsert = {'n', 'O'},
              MkdnExtendList = false,
              MkdnUpdateNumbering = {'n', '<leader>nn'},
              MkdnTableNextCell = {'i', '<Tab>'},
              MkdnTablePrevCell = {'i', '<S-Tab>'},
              MkdnTableNextRow = false,
              MkdnTablePrevRow = {'i', '<M-CR>'},
              MkdnTableNewRowBelow = {'n', '<leader>ir'},
              MkdnTableNewRowAbove = {'n', '<leader>iR'},
              MkdnTableNewColAfter = {'n', '<leader>ic'},
              MkdnTableNewColBefore = {'n', '<leader>iC'},
              MkdnFoldSection = {'n', '<leader>f'},
              MkdnUnfoldSection = {'n', '<leader>F'}
          }
      })
    end
  }

  -- telekasten for zettel
  use {
    'renerocksai/telekasten.nvim',
    requires = {
      'nvim-telescope/telescope.nvim',
      -- 'renerocksai/calendar-vim'
    },
    config = function()
      require('telekasten').setup {

        -- Main paths
        home = vim.fn.expand("~/d/zettel"),
        -- daily = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/journal"),
        -- weekly = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/journal"),
        template_new_note = vim.fn.expand("~/d/zettel/_templates/telekasten_note.md"),
  --       -- template_new_daily = 'daily.md',   -- template for new daily notes
  --       -- template_new_weekly = 'weekly.md',  -- template for new weekly notes
  --
  --       -- Image subdir for pasting
  --         -- subdir name
  --         -- or nil if pasted images shouldn't go into a special subdir
  --       image_subdir = "img",
  --
        -- File extension for note files
        extension    = ".md",
  --
  --       -- use telekasten filetype?
        take_over_my_home = false,  
        auto_set_filetype = false, 
  --
  --       -- Generate note filenames. One of:
  --         -- "title" (default) - Use title if supplied, uuid otherwise
  --         -- "uuid" - Use uuid
  --         -- "uuid-title" - Prefix title by uuid
  --         -- "title-uuid" - Suffix title with uuid
        new_note_filename = "title",
        -- file uuid type ("rand" or input for os.date such as "%Y%m%d%H%M")
        uuid_type = "%Y%m%d%H%M",
  --       -- UUID separator
        uuid_sep = "-",
  --
  --       -- Flags for creating non-existing notes
  --       follow_creates_nonexisting = true,    -- create non-existing on follow
  --       dailies_create_nonexisting = true,    -- create non-existing dailies
  --       weeklies_create_nonexisting = true,   -- create non-existing weeklies
  --
        -- Image link style",
  --         -- wiki:     ![[image name]]
  --         -- markdown: ![](image_subdir/xxxxx.png)
        image_link_style = "wiki",
  --
        -- Default sort option: 'filename', 'modified'
        sort = "filename",
  --
        -- Make syntax available to markdown buffers and telescope previewers
        install_syntax = false,
  --
        -- Tag notation: '#tag', ':tag:', 'yaml-bare'
        tag_notation = "#tag",
  --
        -- When linking to a note in subdir/, create a [[subdir/title]] link
        -- instead of a [[title only]] link
        subdirs_in_links = false,
  --
        -- Command palette theme: dropdown (window) or ivy (bottom panel)
        command_palette_theme = "ivy",
  --
        -- Tag list theme:
          -- get_cursor: small tag list at cursor; ivy and dropdown like above
        show_tags_theme = "ivy",
  --
  --       -- Previewer for media files (images mostly)
  --         -- "telescope-media-files" if you have telescope-media-files.nvim installed
  --         -- "catimg-previewer" if you have catimg installed
  --         -- "viu-previewer" if you have viu installed
  --       media_previewer = "viu-previewer",
  --
        -- Calendar integration
        plug_into_calendar = false,         -- use calendar integration
  --       calendar_opts = {
  --         weeknm = 4,                      -- calendar week display mode:
  --                                          --   1 .. 'WK01'
  --                                          --   2 .. 'WK 1'
  --                                          --   3 .. 'KW01'
  --                                          --   4 .. 'KW 1'
  --                                          --   5 .. '1'
  --
  --         calendar_monday = 1,             -- use monday as first day of week:
  --                                          --   1 .. true
  --                                          --   0 .. false
  --
  --         calendar_mark = 'left-fit',      -- calendar mark placement
  --                                          -- where to put mark for marked days:
  --                                          --   'left'
  --                                          --   'right'
  --                                          --   'left-fit'
  --       },
  --
  --       vaults = {
  --         personal = {
  --           -- configuration for personal vault. E.g.:
  --           -- home = "/home/user/vaults/personal",
  --         }
  --       },
  --
      }
    end
  }



  -- zettel
  -- use {
  --   "mickael-menu/zk-nvim",
  --   requires = { 'junegunn/fzf' },
  --   config = function()
  --     require("zk").setup({
  --       picker = "fzf",
  --
  --       lsp = {
  --         -- `config` is passed to `vim.lsp.start_client(config)`
  --         config = {
  --           cmd = { "zk", "lsp" },
  --           name = "zk",
  --           -- on_attach = ...
  --           -- etc, see `:h vim.lsp.start_client()`
  --         },
  --
  --         -- automatically attach buffers in a zk notebook that match the given filetypes
  --         auto_attach = {
  --           enabled = true,
  --           filetypes = { "markdown", "pandoc", "markdown.pandoc" },
  --         },
  --       },
  --     })
  --   end,
  -- }

  use {
    'tom-anders/telescope-vim-bookmarks.nvim',
    requires = {
      'nvim-telescope/telescope.nvim'
    },
    config = function()
      require('telescope').load_extension('vim_bookmarks')
    end,
  }

  use {
    "AckslD/nvim-neoclip.lua",
    requires = {
      -- you'll need at least one of these
      {'nvim-telescope/telescope.nvim'},
      -- {'ibhagwan/fzf-lua'},
    },
    config = function()
      require('neoclip').setup()
      require('telescope').load_extension('neoclip')
    end,
  }

 
  -- git
  use 'rhysd/conflict-marker.vim'
  use 'airblade/vim-gitgutter'

  -- use {
  --   'edluffy/hologram.nvim',
  -- }
  -- require('hologram').setup{ auto_display = true }
  --
  -- use {'Vaisakhkm2625/hologram-math-preview.nvim'}
  -- tweaks
  -- use 'RRethy/nvim-base16' -- color schemes
  use 'sainnhe/gruvbox-material' --color scheme
  -- use 'Konfekt/FastFold' -- speed up folding
  use 'justinmk/vim-gtfo' -- open directory for current file in finder (gof) or terminal (got)
  use 'tomtom/tcomment_vim' -- toggle comments (gcc, vgc...)
  use 'tpope/vim-repeat' -- extend repeat '.' to include stuff in mappings
  -- use 'tpope/vim-surround' -- support for adding and replacing surrounding charcters
  -- use 't9md/vim-surround_custom_mapping' --custom surround mappings

  use {
    'kylechui/nvim-surround',
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
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
  }

  use 'junegunn/vim-easy-align' -- align by character: 'v<enter>|'
  use 'jszakmeister/vim-togglecursor' -- toggle cursor in insert mode in terminals
  use 'tpope/vim-speeddating' -- increment and decrement dates
  use 'vim-scripts/utl.vim' -- generalized link/file/document opener
  use {
    '/Users/desanso/Software/vim-bookmarks',
    -- 'MattesGroeger/vim-bookmarks',
    }
  use 'reedes/vim-litecorrect' -- autocorrect as you type
  use 'farmergreg/vim-lastplace' -- restore cursor position
  -- use 'ggandor/lightspeed.nvim'
  use { 
    'ggandor/leap.nvim',
    config = function() 
      require('leap').add_default_mappings()
    end
  }

  use {
    'folke/zen-mode.nvim',
    config = function()
      require("zen-mode").setup {
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
    end
  }

  use {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  -- use({
  --   "jghauser/papis.nvim",
  --   after = { "telescope.nvim", "nvim-cmp" },
  --   requires = {
  --     "kkharji/sqlite.lua",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   rocks = { "lyaml" },
  --   config = function()
  --     require("papis").setup({
  --       papis_python = {
  --         dir = "/Users/desanso/Documents/d/papers",
  --         info_name = "info.yaml", -- (when setting papis options `-` is replaced with `_`
  --         -- in the keys names)
  --         notes_name = [[notes.md]],
  --       },
  --       -- Enable the default keymaps
  --       enable_keymaps = true,
  --     })
  --     require('telescope').load_extension('papis')
  --   end,
  -- })

  -- FILETYPE PLUGINS

  use {
    'lervag/vimtex',
    config = function()
      g.tex_flavor  = 'latex'
      g.tex_conceal = 'abdmgs'
    end,
    ft = 'tex'
  }

  use {
    'dag/vim-fish',
    ft = 'fish'
  }

  use 'chrisbra/csv.vim' -- csv syntax and filetype plugin
  use 'dsanson/vim-ris' -- RIS bibliography files
  
  -- use {
  --   'vim-pandoc/vim-pandoc',
  -- }
  
  -- use treesitter instead
  -- use {
  --   'vim-pandoc/vim-pandoc-syntax',
  --   ft = 'pandoc'
  -- }

  -- color codes
  use {
      'RRethy/vim-hexokinase',
      run = 'cd /Users/desanso/.local/share/nvim/site/pack/packer/start/vim-hexokinase && make hexokinase',
  }

  use {
    'tamton-aquib/duck.nvim',
    config = function()
      vim.keymap.set('n', '<leader>dd', function() require("duck").hatch() end, {})
      vim.keymap.set('n', '<leader>dc', function() require("duck").hatch('🦀') end, {})
      vim.keymap.set('n', '<leader>dk', function() require("duck").cook() end, {})
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end

end)

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
    -- { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
    -- { name = 'buffer' },
    -- { name = 'calc' },
    { name = 'cmp_pandoc' },
    -- { name = 'pandoc_references' },
    -- { name = "papis" },
    --{ name = 'vCard' },
    -- { name = 'digraphs' },
  })
})

-- require('completion_vcard').setup_cmp('Users/desanso/.contacts/card')

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

-- lsp.efm.setup {
--    capabilities = capabilities,
--    init_options = {documentFormatting = true},
--    settings = {
--      rootMarkers = {".git/"},
--      languages = {
--        lua = {
--          {formatCommand = "lua-format -i", formatStdin = true}
--        },
--        pandoc = {
--          {formatCommand = "pandoc --columns 78 --markdown-headings=atx --id-prefix (random) --reference-location block -f markdown+raw_html-raw_attribute -t markdown+raw_html-raw_attribute"}
--        }
--      }
--   }
-- }

require("zen-mode").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  window = {
    backdrop = 0.80, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
    -- height and width can be:
    -- * an absolute number of cells when > 1
    -- * a percentage of the width / height of the editor when <= 1
    width = 80, -- width of the Zen window
    height = 1, -- height of the Zen window
    -- by default, no options are changed for the Zen window
    -- uncomment any of the options below, or add other vim.wo options you want to apply
    options = {
      -- signcolumn = "no", -- disable signcolumn
      -- number = false, -- disable number column
      -- relativenumber = false, -- disable relative numbers
      -- cursorline = false, -- disable cursorline
      -- cursorcolumn = false, -- disable cursor column
      -- foldcolumn = "0", -- disable fold column
      -- list = false, -- disable whitespace characters
    },
  },
  plugins = {
    -- disable some global vim options (vim.o...)
    -- comment the lines to not apply the options
    options = {
      enabled = true,
      ruler = false, -- disables the ruler text in the cmd line area
      showcmd = false, -- disables the command in the last line of the screen
    },
    gitsigns = { enabled = false }, -- disables git signs
    tmux = { enabled = false }, -- disables the tmux statusline
    -- this will change the font size on kitty when in zen mode
    -- to make this work, you need to set the following kitty options:
    -- - allow_remote_control socket-only
    -- - listen_on unix:/tmp/kitty
    kitty = {
      enabled = false,
      font = "+4", -- font size increment
    },
  },
}

-- colorscheme
vim.opt.termguicolors = true
-- vim.cmd('source ~/.vimrc_background')
vim.cmd('colorscheme wal')

-- -- vimtex
-- g.tex_flavor  = 'latex'
-- g.tex_conceal = 'abdmgs'

-- gtfo
g["gtfo#terminals"] = { mac = "/Users/desanso/Applications/Kitty.app"}

-- litecorrect
g.user_dict    = {
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

-- vim-hexokinase
g.Hexokinase_optOutPatterns = { "colour_names" }
g.Hexokinase_ftOptInPatterns = { 
  css = 'colour_names', 
  html = 'colour_names', 
  sass = 'colour_names',
  javascript = 'colour_names', 
}

-- vim-bookmarks
g.bookmark_auto_save = 1
g.bookmark_no_default_key_mappings = 1
g.bookmark_display_annotation = 1

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

