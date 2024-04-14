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
vim.api.nvim_set_keymap('v', '<Enter>', ':EasyAlign<CR>', {noremap = true} ) -- easyalign map for visual mode

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
