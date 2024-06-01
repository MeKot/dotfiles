local g = vim.g
local o = vim.o

-- Most filetypes
-- vim-polyglot
-- A solid language pack for Vim
-- https://github.com/sheerun/vim-polyglot
vim.cmd 'packadd vim-polyglot'

-- Javascript
-- vim-javascript (comes in vim-polyglot)
-- https://github.com/pangloss/vim-javascript
g.javascript_plugin_jsdoc = 1

-- Markdown
-- vim-markdown (comes in vim-polyglot)
-- https://github.com/plasticboy/vim-markdown
g.vim_markdown_folding_disabled = 1
g.vim_markdown_new_list_item_indent = 2
o.conceallevel = 2
