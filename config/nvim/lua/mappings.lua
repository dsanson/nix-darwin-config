local cmd = vim.cmd
local g = vim.g
local keymap = vim.keymap
local api = vim.api
local lsp = vim.lsp

g.mapleader      = ' '
g.maplocalleader = ','

-- Aliases
cmd('command! W w') -- :W is the same as :w
cmd('command! Wq wq') -- :W is the same as :w


-- Treat long lines as break lines (useful when moving around in them)
keymap.set('n', 'j', 'gj')
keymap.set('n', 'k', 'gk')
keymap.set('v', 'j', 'gj')
keymap.set('v', 'k', 'gk')

-- Up and Down arrows by screen lines rather than file lines)
keymap.set('n', '<Down>', 'gj')
keymap.set('n', '<Up>',   'gk')

-- visual shifting without exiting visual mode
keymap.set('v', '<', '<gv', { desc = "shift left" })
keymap.set('v', '>', '>gv', { desc = "shift right" })

-- Remap Y to yank to end of line (so consistent with C and D)
keymap.set('n', 'Y', 'y$' )

-- Easy Align mapping
keymap.set('v', '<Enter>', ':EasyAlign<CR>', {desc = "Easy align"} )

-- Open main notes file
keymap.set('n', 'gn', '<cmd>edit ~/d/zettel/Home.md<cr>', { desc = "open notes" } )

-- LSP mappings 
api.nvim_create_autocmd('LspAttach', {
  group = api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(args)
    keymap.set('n', 'gd', lsp.buf.definition, { buffer = args.buf, desc = "goto definition" })
    keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = args.buf, desc = "goto references" })
    keymap.set('n', 'cd', lsp.buf.code_action, { buffer = args.buf, desc = "code actions" })
  end
})
