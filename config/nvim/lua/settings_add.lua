-- --set background on MacOS
-- if vim.uv.os_uname().sysname == 'Darwin' then
--   local theme = vim.fn.system('defaults read -g AppleInterfaceStyle')
--   if theme == 'Dark' then
--     vim.opt.background = 'dark'
--   else
--     vim.opt.background = 'light'
--   end
--   vim.cmd.colorscheme('neopywal')
-- end

vim.opt.background = 'dark'
vim.cmd.colorscheme('neopywal')

