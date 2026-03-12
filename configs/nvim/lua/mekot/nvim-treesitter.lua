-- nvim-treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter
vim.cmd 'packadd nvim-treesitter'

-- nvim-treesitter v2 dropped the highlight module; start it explicitly per filetype.
require('nvim-treesitter.config').setup {}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "norg",
  callback = function(args) vim.treesitter.start(args.buf, "norg") end,
})
