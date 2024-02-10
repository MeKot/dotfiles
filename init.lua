
vim.g.mapleader=','
vim.g.maplocalleader='§'
vim.g.sonokai_style='espresso'
vim.g.sonokai_better_performance=1
vim.g.spaceline_colorscheme='sonokai'

vim.opt.tabstop=2
vim.opt.textwidth=99
vim.opt.shiftwidth=2
vim.opt.softtabstop=0
vim.opt.conceallevel=2
vim.opt.colorcolumn="100"
vim.opt.foldmethod="manual"

vim.opt.hls=true
vim.opt.wrap=true
vim.opt.number=true
vim.opt.hidden=true
vim.opt.cindent=true
vim.opt.showcmd=true
vim.opt.autoread=true
vim.opt.smarttab=true
vim.opt.smartcase=true
vim.opt.expandtab=true
vim.opt.cursorline=true
vim.opt.autoindent=true
vim.opt.termguicolors=true
vim.opt.relativenumber=true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  "tpope/vim-surround",
  "sainnhe/sonokai",
  {
    "glepnir/spaceline.vim",
    dependencies = { "ryanoasis/vim-devicons" },
    build = "cp ~/dotfiles/colors/spaceline/sonokai.vim ~/.local/share/nvim/lazy/spaceline.vim/autoload/spaceline/colorscheme/"
  },

  "neovim/nvim-lspconfig",
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },

  {
    'echasnovski/mini.pairs',
    version = '*'
  },

  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",

  {
	'L3MON4D3/LuaSnip',
	version = "v2.*",
	build = "make install_jsregexp",
  },

  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      { "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
    },

    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          -- ["core.ui.calendar"] = {}, -- Adds a calendar picker for the journal -- NEEDS V0.10
          ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/notes",
            },
            default_workspace="notes",
          },
        },
        ["core.autocommands"] = {},
        ["core.integrations.treesitter"] = {},
        ["core.concealer"] = {},
      },
    }
  end,
},
})

require 'nvim-treesitter.install'.compilers = { 'gcc'}

vim.cmd [[

" Highlight search but not on every refresh (just purges the search buffer)
let @/=""

syntax on
filetype plugin on

colorscheme sonokai

inoremap <special> jk <Esc>

" Yank to system clipboard from vim
vnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

augroup RemoveTrailingWhitespace
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
augroup END

augroup CURSORLINE
  autocmd!
  autocmd InsertEnter * set nocursorline
  autocmd InsertLeave * set cursorline
augroup END

" Folds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
nnoremap <silent> <Leader><Space> @=(foldlevel('.')?'zA':"\<Space>")<CR>
vnoremap <Space>  zf

nnoremap <Leader>ev  :e ~/dotfiles/init.lua<CR>

nnoremap <Leader>vs  :vsplit<CR><C-w><C-w>
nnoremap <Leader>hs  :split<CR><C-w><C-w>
nnoremap <Leader>dd  :bp\|bd # <CR>

]]

-- Zettlecasten
vim.keymap.set('n', '<C-k>', function()
  local cword = vim.fn.escape(vim.fn.expand('<cword>'), [[\/]])
  local definition = os.execute("dict " .. cword)

  local bufnr = vim.lsp.util.open_floating_preview(definition, 'txt', {border = options.border, focusable = true, focut = true})
  vim.keymap.set('n', 'q', '<cmd>bdelete<cr>', { buffer = bufnr, silent = true, nowait = true })
end)

vim.cmd [[

augroup NEORG
  autocmd!
  autocmd FileType neorg setlocal spell
  autocmd BufEnter,BufNewFile *.norg setlocal spell
augroup END

]]

vim.cmd([[

" Telescope
nnoremap B <cmd>Telescope buffers<cr>
nnoremap E <cmd>Telescope find_files<cr>
nnoremap <leader>/ <cmd>Telescope live_grep<cr>
nnoremap <C-c> <cmd>Telescope spell_suggest<cr>

]])
