vim.g.mapleader      = ' '
vim.g.maplocalleader = ','

-- Aliases
vim.cmd('command! W w') -- :W is the same as :w
vim.cmd('command! Wq wq') -- :W is the same as :w


-- Treat long lines as break lines (useful when moving around in them)
vim.api.nvim_set_keymap('n', 'j', 'gj', {noremap = true} )
vim.api.nvim_set_keymap('n', 'k', 'gk', {noremap = true} )
vim.api.nvim_set_keymap('v', 'j', 'gj', {noremap = true} )
vim.api.nvim_set_keymap('v', 'k', 'gk', {noremap = true} )

-- Up and Down arrows by screen lines rather than file lines)
vim.api.nvim_set_keymap('n', '<Down>', 'gj', {noremap = true} )
vim.api.nvim_set_keymap('n', '<Up>',   'gk', {noremap = true} )

-- visual shifting without exiting visual mode
vim.api.nvim_set_keymap('v', '<', '<gv', { desc = "shift left" })
vim.api.nvim_set_keymap('v', '>', '>gv', { desc = "shift right" })

-- Remap Y to yank to end of line (so consistent with C and D)
vim.api.nvim_set_keymap('n', 'Y', 'y$', {noremap = true} )
vim.api.nvim_set_keymap('v', '<Enter>', ':EasyAlign<CR>', {noremap = true, desc = "Easy align"} ) 

-- Open main notes file
vim.keymap.set('n', 'gn', '<cmd>edit ~/d/zettel/Home.md<cr>', { desc = "open notes" } )


-- LSP mappings 
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(args)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf, desc = "goto definition" })
    vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = args.buf, desc = "goto references" })
    vim.keymap.set('n', 'cd', vim.lsp.buf.code_action, { buffer = args.buf, desc = "code actions" })
  end
})
