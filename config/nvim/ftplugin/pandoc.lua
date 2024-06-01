local opt_local = vim.opt_local

opt_local.equalprg = 'pandoc -f markdown+wikilinks_title_after_pipe -t markdown+wikilinks_title_after_pipe  --columns 78 --markdown-headings=atx --id-prefix (random) --reference-location block --standalone'
opt_local.formatprg = 'semantic_linebreaks'
opt_local.joinspaces = false
opt_local.linebreak = true
opt_local.smartindent = false
-- opt_local.commentstring = '<!--%s-->'
-- opt_local.comments = 's:<!--,m:\ \ \ \ ,e:-->,:\|,n:>'
opt_local.wrap = true
--opt_local.formatoptions = 'tnroq'
--vim.opt_local.formatlistpat = [[^\s*\([*+-]\|\((*\d\+[.)]\+\)\|\((*\l[.)]\+\)\)\s\+]]

-- vim-pandoc
vim.g["pandoc#biblio#bibs"] = { "/Users/desanso/Documents/d/research/zotero.bib" }

function add_ms_comment()
  math.randomseed(os.time())
  local _, line_v, col_v = unpack(vim.fn.getpos('v'))
  local _, line_cur, col_cur = unpack(vim.fn.getpos('.'))
  line_v = line_v - 1
  col_v = col_v - 1
  line_cur = line_cur - 1
  col_cur = col_cur
  if col_cur > vim.fn.strwidth(vim.fn.getline('.')) then
    col_cur = col_cur - 1
  end
  local line_start, col_start, line_end, col_end
  if line_v > line_cur or (line_v == line_cur and col_cur < col_v) then
     line_start = line_cur
     col_start = col_cur
     line_end = line_v
     col_end = col_v
  else
     line_start = line_v
     col_start = col_v
     line_end = line_cur
     col_end = col_cur
  end
  local old_text = vim.api.nvim_buf_get_text(0, line_start, col_start, line_end, col_end, {})
  local timestamp = os.date("%FT%T%Z"):sub(1,-4) .. "Z"
  local id = math.random(1,10000)
  old_text[1] = '[]{.comment-start id="' .. id .. '" author="Sanson, David" date="' .. timestamp .. '"}' .. old_text[1]
  old_text[#old_text] = old_text[#old_text] .. '[]{.comment-end id="' .. id .. '"}'
  vim.api.nvim_buf_set_text(0, line_start, col_start, line_end, col_end, old_text)
  vim.api.nvim_win_set_cursor(0, {line_start + 1, col_start + 1})
  local keys = vim.api.nvim_replace_termcodes("<ESC>i", true, false, true)
  vim.api.nvim_feedkeys(keys, "i", true)
end

vim.keymap.set("v", "<leader>iw", function() add_ms_comment() end, {desc = "add Word comment"})

vim.keymap.set("n", "<leader>tx", require('toggle-checkbox').toggle, {desc = 'Toggle checkbox'})

-- refresh codelens on TextChanged and InsertLeave as well
vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave', 'CursorHold', 'LspAttach' }, {
    buffer = bufnr,
    callback = vim.lsp.codelens.refresh,
})

-- trigger codelens refresh
vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })


