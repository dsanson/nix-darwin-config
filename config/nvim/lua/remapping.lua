-- Aliases
vim.cmd('command! W w') -- :W is the same as :w
vim.cmd('command! Wq wq') -- :W is the same as :w

-- Maps
local utils = require('utils')

vim.g.mapleader      = ' '
vim.g.maplocalleader = ','

-- visual shifting without exiting visual mode
utils.map('v', '<', '<gv')
utils.map('v', '>', '>gv')

-- Treat long lines as break lines (useful when moving around in them)
utils.map('n', 'j', 'gj')
utils.map('n', 'k', 'gk')
utils.map('v', 'j', 'gj')
utils.map('v', 'k', 'gk')

-- Up and Down arrows by screen lines rather than file lines)
utils.map('n', '<Down>', 'gj')
utils.map('n', '<Up>',   'gk')

-- Remap Y to yank to end of line (so consistent with C and D)
utils.map('n', 'Y', 'y$')
utils.map('v', '<Enter>', ':EasyAlign<CR>') -- easyalign map for visual mode

-- Mappings for leap
-- vim.keymap.set('n', 's', '<Plug>(leap-forward-to)', {})
-- --vim.keymap.set({'x','o','v'}, 's', '<Plug>(leap-forward-to)', {offset = +1, inclusive_op = true})
-- vim.keymap.set({'x','o','v'}, 's', '<Plug>(leap-forward-to)')
-- vim.keymap.set({'n','x','o','v'}, 'S', '<Plug>(leap-backward-to)', {})
-- --vim.keymap.set('n', 'gs', '<Plug>(leap-cross-window)', { target_windows=require('leap.util').get_enterable_windows() })
-- vim.keymap.set('n', 'gs', '<Plug>(leap-cross-window)')

-- Which-key maps
local wk = require('which-key')

wk.register({
  -- File mappings
  f = {
    name = "file",
    f = { "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", "Find File" }, -- create a binding with label
    -- f = { require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({})), "Find File" }, -- create a binding with label
    g = { "<cmd>Telescope live_grep<cr>", "Grep Files" }, -- create a binding with label
    r = { "<cmd>Telescope oldfiles<cr>", "Recent Files"},
    b = { "<cmd>Telescope buffers<cr>", "Switch buffer"},
    z = { "<cmd>Telescope zoxide list<cr>", "Zoxide"},
  },

  -- Quitting
  q = {
    name = "quitting",
    q = { '<cmd>wq<cr>' , "Save and quit" }, -- create a binding with label
    x = { "<cmd>q!<cr>", "Quit without saving" }, -- create a binding with label
  },

  -- Buffer mappings
  ['<space>'] =  { '<cmd>Telescope commands<cr>', "Run command" },
  b = {
    name = "buffer",
    b = { "<cmd>Telescope buffers theme=dropdown<cr>", "Switch buffer"},
    d = { "<cmd>bdelete<cr>", "Kill buffer" }, -- create a binding with label
    n = { "<cmd>bnext<cr>", "Next buffer" }, -- create a binding with label
    p = { "<cmd>bprevious<cr>", "Previous buffer" }, -- create a binding with label
  },

  -- Diagnostics
  d = {
    name = "diagnostics",
    p  = { vim.diagnostic.goto_prev, 'go to previous' },
    n  = { vim.diagnostic.goto_next, 'go to next' },
  },

  -- Jump mappings
  j = {
    name = "jump",
    z = { "<cmd>!open \"$(bib2path2 -z \"<cWORD>\")\"<CR>", 'open in Zotero'},
    t = { "<cmd>!kitty --single-instance --instance-group=1 /Users/desanso/bin/termpdf.py --nvim-listen-address $NVIM_LISTEN_ADDRESS --open <cword><CR><CR>", "Open PDF in termpdf.py"},
    p = { "<cmd>!open \"$(bib2path2 \"<cWORD>\")\"<CR>", "Open PDF in Preview.app"},
    x = { 'gx', 'Open file (gx)' },
    f = { 'gF', 'Open file in nvim (gF)' },
    h = { '<cmd>Telescope heading<cr>', 'Jump to heading' },
    b = { '<cmd>Telescope bookmarks<cr>', 'Open browser bookmark'},
    o = { '<cmd>!open \"obsidian://open?vault=Everything&file=%:t:r\"<cr>', 'Open in Obsidian'},
  },

  -- marks
  m = {
    name = "marks",
    a = {'<cmd>BookmarkAnnotate<cr>',"add/edit/remove annotation"},
    t = {'<cmd>BookmarkToggle<cr>','add/remove bookmark'},
    n = {'<cmd>BookmarkNext<cr>','jump to next bookmark'},
    p = {'<cmd>BookmarkPrev<cr>','jump to previous bookmark'},
    s = {'<cmd>Telescope vim_bookmarks current_file<cr>', 'search bookmarks in current buffer'},
    S = {'<cmd>Telescope vim_bookmarks all<cr>', 'search all bookmarks'},
    m = {'<cmd>Telescope marks<cr>', 'search all marks'},
  },

  w = {
    name = "writing",
    b = { "<cmd>.!bib2path2 -b \"<cWORD>\"<CR>",
          "Replace citekey with bibliographic entry"},
  }, 

  -- toggles
  t = {
    name = "toggle",
    w = { "<cmd>set nolist!<cr>", 'Show invisibles' },
    a = { "<cmd>set arabic!<cr>", "Arabic mode" },
    z = { "<cmd>ZenMode<cr>", "Zen mode" },
    d = { "<cmd>Twilight<cr>", "Twilight mode" },
    t = { "<cmd>Neotree document_symbols toggle<cr>", "Show table of contents"},
    f = { "<cmd>Neotree filesystem toggle<cr>", "Show filesystem"},
    b = { "<cmd>Neotree buffers toggle<cr>", "Show buffers"},
    c = { "<cmd>source ~/.vimrc_background<cr>", "Apply system colorscheme"},
  },

  -- inserts
  i = {
    name = "insert",
    d = {'"=strftime("%Y-%m-%d")<CR>p', "Insert today's date" },
    t = {'"=strftime("%FT%T%Z")<CR>p', "Insert timestamp"},  
    e = {function() require'telescope.builtin'.symbols{ sources = {'emoji'} } end, "Insert emoji"},
    m = {function() require'telescope.builtin'.symbols{ sources = {'math'} } end, "Insert math symbol"},
    l = {function() require'telescope.builtin'.symbols{ sources = {'logic'} } end, "Insert logic symbol"},
    b = { "<cmd>Telescope bibtex<cr>", "Insert bib key"},
  },

  -- carnap
  C = {
    name = "carnap",
    p = {'<cmd>!carnap put %<cr>', "Upload to Carnap"},
    o = {'<cmd>!carnap open %<cr>', "Open on Carnap"},
  },

  -- -- zk
  -- z = {
  --   name = "notes",
  --   n = {"<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>","New note"},
  --   i = {"<Cmd>ZkIndex<CR>","New note"},
  --   o = {"<Cmd>ZkNotes { sort = { 'modified' } }<CR>","Open note"},
  --   t = {"<Cmd>ZkTags<CR>","Search by tags"},
  --   b = {"<Cmd>ZkBacklinks { sort = { 'modified' } }<CR>","Open backlinks"},
  --   l = {"<Cmd>ZkLinks { sort = { 'modified' } }<CR>","Open links"},
  -- },
 
  -- spelling
  s = {
    name = 'spelling',
    ['='] = {'<cmd>Telescope spell_suggest<cr>', 'Suggest correct spelling'},
    n = {']s', 'Go to next mispelled word'},
    a = {'zg', 'Add word to dictionary'},
    x = {'zw', 'Mark as mispelled'},
  },

  -- clipboard
  c = {
    name = 'clipboard',
    s = {'<cmd>Telescope neoclip<cr>', 'Search old clippings'},
  },

  -- help
  h = {
    name = "help",
    h = {'<cmd>Telescope help_tags<cr>', 'Get help'},
  },

}, 
{ 
  prefix = "<leader>",
  mode = 'n',
  disable = {
    buftypes = {},
    filetypes = { "TelescopePrompt" },
  },
})

-- Terminal Mode mappings

local function termcodes(str)
   return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- remap so can use ESC in terminal
wk.register({
  ['<Esc>'] = {termcodes '<C-\\><C-n>', 'normal mode'},
},
{
    prefix = "",
    mode = 't'
})

-- but unremap if it is actually just fzf
vim.api.nvim_command('au! FileType fzf silent! tunmap <Esc>')

wk.register({
  -- File mappings
  f = {
    name = "file",
    f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
    -- f = { require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({})), "Find File" }, -- create a binding with label
    g = { "<cmd>Telescope live_grep<cr>", "Grep Files" }, -- create a binding with label
    r = { "<cmd>Telescope oldfiles<cr>", "Recent Files"},
    b = { "<cmd>Telescope buffers<cr>", "Switch buffer"},
    z = { "<cmd>Telescope zoxide list<cr>", "Zoxide"},
  },

  -- Quitting
  q = {
    name = "quitting",
    q = { '<cmd>wq<cr>' , "Save and quit" }, -- create a binding with label
    x = { "<cmd>q!<cr>", "Quit without saving" }, -- create a binding with label
  },

  -- Buffer mappings
  -- ['<space>'] =  { '<cmd>Telescope commands<cr>', "Run command" },
  b = {
    name = "buffer",
    b = { "<cmd>Telescope buffers theme=dropdown<cr>", "Switch buffer"},
    d = { "<cmd>bdelete<cr>", "Kill buffer" }, -- create a binding with label
    n = { "<cmd>bnext<cr>", "Next buffer" }, -- create a binding with label
    p = { "<cmd>bprevious<cr>", "Previous buffer" }, -- create a binding with label
  },

  -- Jump mappings
  j = {
    name = "jump",
    z = { "<cmd>!open \"$(bib2path2 -z \"<cWORD>\")\"<CR>", 'open in Zotero'},
    t = { "<cmd>!kitty --single-instance --instance-group=1 /Users/desanso/bin/termpdf.py --nvim-listen-address $NVIM_LISTEN_ADDRESS --open <cword><CR><CR>", "Open PDF in termpdf.py"},
    p = { "<cmd>!open \"$(bib2path2 \"<cWORD>\")\"<CR>", "Open PDF in Preview.app"},
    x = { 'gx', 'Open file (gx)' },
    f = { 'gf', 'Open file in nvim (gf)' },
    b = { '<cmd>Telescope bookmarks<cr>', 'Open browser bookmark'},
  },

  -- marks
  m = {
    name = "marks",
    s = {'<cmd>Telescope vim_bookmarks all<cr>', 'search all bookmarks'},
    m = {'<cmd>Telescope marks<cr>', 'search all marks'},
  },

  -- toggles
  t = {
    name = "toggle",
    c = { "<cmd>source ~/.vimrc_background<cr>", "Apply system colorscheme"},
  },

  -- inserts
  i = {
    name = "insert",
    d = {'"=strftime("%Y-%m-%d")<CR>p', "Insert today's date" },
    t = {'"=strftime("%FT%T%Z")<CR>p', "Insert timestamp"},  
    e = {function() require'telescope.builtin'.symbols{ sources = {'emoji'} } end, "Insert emoji"},
    m = {function() require'telescope.builtin'.symbols{ sources = {'math'} } end, "Insert math symbol"},
    l = {function() require'telescope.builtin'.symbols{ sources = {'logic'} } end, "Insert logic symbol"},
  },

  -- -- zk
  -- z = {
  --   name = "notes",
  --   n = {"<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>","New note"},
  --   o = {"<Cmd>ZkNotes { sort = { 'modified' } }<CR>","Open note"},
  --   t = {"<Cmd>ZkTags<CR>","Search by tags"},
  -- },
 
  -- clipboard
  c = {
    name = 'clipboard',
    s = {'<cmd>Telescope neoclip<cr>', 'Search old clippings'},
  },

  -- help
  h = {
    name = "help",
    h = {'<cmd>Telescope help_tags<cr>', 'Get help'},
    m = {'<cmd>Telescope man_pages<cr>', 'Man pages'},
  },

}, 
{ 
  prefix = "<leader>",
  mode = 't',
  disable = {
    buftypes = {},
    filetypes = { "TelescopePrompt" },
  },
})

-- telekasten
-- Launch panel if nothing is typed after <leader>z
vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>")
-- -- Most used functions
vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>")
vim.keymap.set("n", "<leader>z/", "<cmd>Telekasten search_notes<CR>")
-- -- vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>")
-- vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>")
vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>")
-- vim.keymap.set("n", "<leader>zy", "Telekasten yank_notelink<CR>")
-- -- vim.keymap.set("n", "<leader>zc", "<cmd>Telekasten show_calendar<CR>")
vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>")
-- vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>")
vim.keymap.set("n", "<leader>zr", "<cmd>Telekasten rename_note<CR>")
--
-- -- Call insert link automatically when we start typing a link
-- vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")
