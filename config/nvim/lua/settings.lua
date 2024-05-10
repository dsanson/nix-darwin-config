-- global settings 

local opt = vim.opt
local cmd = vim.cmd

-- mouse
opt.mouse         = 'a'           -- enable mouse usage

-- search
opt.ignorecase    = true     -- case insensitive search
opt.smartcase     = true      -- ...but case insensitive when uc present
opt.wrapscan      = false     -- searches end at bottom, don't wrap around to top
cmd('noremap <silent><esc> <esc>:noh<CR><esc>') -- ESC to remove search highlights

-- folding
opt.foldmethod    = 'expr'   -- use treesitter for folding
opt.foldexpr      = 'nvim_treesitter#foldexpr()'

-- swap
opt.swapfile      = true       -- save to swap (makes recovery possible)
opt.dir           = '/tmp'          -- directory for swapfile

-- scroll
opt.scrolljump    = 5        -- Line to scroll when cursor leaves screen
opt.scrolloff     = 3    -- Minumum lines to keep above and below cursor

-- tabs
opt.shiftwidth    = 2   -- Use indents of 4 spaces
opt.tabstop       = 4      -- An indentation every four columns
opt.softtabstop   = 2  -- Let backspace delete indent
opt.smartindent   = true    -- autoindent new lines
opt.expandtab     = true    -- Tabs are spaces, not tabs

-- splits
opt.splitright    = true    -- Puts new vsplit windows to the right of the current
opt.splitbelow    = true    -- Puts new split windows to the bottom of the current
cmd('hi clear VertSplit') -- clear highlighting on split

-- saves and backups
opt.autowrite     = true    -- Automatically write a file when leaving a modified buffer
opt.hidden        = true    -- Allow buffer switching without saving
opt.backup        = true
opt.backupcopy    = 'yes' --Backup preserves file attributes
opt.backupdir     = vim.fn.stdpath('data') .. '/backup'
-- save constantly
cmd('autocmd BufUnload,BufLeave,FocusLost,QuitPre,InsertLeave,TextChanged,CursorHold * silent! wall')
opt.updatecount   = 100 -- Write to swap every 10 characters (default is 200)
opt.undofile      = true -- Write undofiles

-- status
opt.ruler         = true      -- Hide the ruler
opt.statusline    = '%m%r%t %y [%c,%l,%P]' --Status line
opt.laststatus    = 0 --Hide status line
opt.shortmess     = 'atOI'    -- avoid being spammed by messages
opt.showcmd       = true      -- Show partial commands in status line and Selected characters/lines in visual mode
opt.showmode      = true      -- Show current mode in command-line
opt.matchtime     = 5         -- Show matching time
opt.report        = 0         -- Always report changed lines

-- window options
opt.number       = false       -- no line numbers
opt.wrap         = false       -- no wrap
opt.linespace     = 0    -- No extra spaces between rows
opt.pumheight     = 20   -- Avoid the pop up menu occupying the whole screen
opt.wildmode      = 'longest,list,full' --More bash-like filename tab completions
opt.listchars     = 'tab:▸ ,eol:↵,trail:·,extends:↷,precedes:↶' -- chars for invisibles
opt.list          = false --No visible whitespace by default
opt.whichwrap     = vim.o.whichwrap .. ',<,>,h,l' -- Allow backspace and cursor keys to cross line boundaries

-- encodings
opt.encoding      = 'utf-8'
opt.fileencoding  = 'utf-8'
opt.fileencodings = 'utf-8,ucs-bom,gb18030,gbk,gb2312,cp936'

opt.clipboard     = 'unnamed' --Use system clipboard

-- neovim terminal 
cmd('autocmd TermOpen * startinsert') -- Enter "terminal mode" automatically

-- wal doesn't work with termguicolors
opt.termguicolors = false

-- return cursor to last location on open
vim.api.nvim_create_autocmd({'BufWinEnter'}, {
  desc = 'return cursor to where it was last time closing the file',
  pattern = '*',
  command = 'silent! normal! g`"zv',
})
