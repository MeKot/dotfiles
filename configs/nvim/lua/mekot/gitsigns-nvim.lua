-- Git signs
-- gitsigns.nvim
-- https://github.com/lewis6991/gitsigns.nvim
vim.cmd 'packadd gitsigns.nvim'

require'gitsigns'.setup {

  watch_gitdir = {
    interval = 1000
  },
  sign_priority = 6,
  status_formatter = nil, -- Use default
}

vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'AddText' })
vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'ChangeText' })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'DeleteText' })
vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { link = 'DeleteText' })
vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { link = 'ChangeDeleteText' })

vim.api.nvim_set_hl(0, 'GitSignsAddNr', { link = '' })
vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { link = '' })
vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', { link = '' })
vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { link = '' })
vim.api.nvim_set_hl(0, 'GitSignsChangedeleteNr', { link = '' })
