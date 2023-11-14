set nocompatible
set termguicolors

" Think of using Dein? dark side of the force and stuff
call plug#begin('~/.vim/plugged')

" Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'itchyny/lightline.vim'
Plug 'vimwiki/vimwiki'
Plug 'chrisbra/Colorizer'
Plug 'sainnhe/sonokai'

packadd! sonokai

let g:sonokai_style='espresso'
let g:sonokai_better_performance=1

colorscheme sonokai
let g:lightline = {'colorscheme' : 'sonokai'}

call plug#end()

set omnifunc=syntaxcomplete#Complete
filetype plugin on
syntax on

augroup RemoveTrailingWhitespace
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
augroup END

augroup CURSORLINE
  autocmd!
  autocmd InsertEnter * set nocursorline
  autocmd InsertLeave * set cursorline
augroup END

augroup WIKI
  autocmd!
  autocmd FileType vimwiki setlocal spell
  autocmd BufEnter,BufNewFile *.wiki setlocal spell
augroup END

let mapleader=','
set textwidth=99
set colorcolumn=100
set autoread
set hidden
set autoindent
set cindent
set cursorline
set expandtab
set foldmethod=manual  " Clearly not an origami fan
set hls
set incsearch
set number
set relativenumber
set shiftwidth=2
set showcmd
set smarttab
set smartcase
set softtabstop=0
set tabstop=2
set wrap

" Highlight search but not on every refresh (just purges the search buffer)
let @/=""

" Vimtex config
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_quickfix_mode=0
set conceallevel=2
let g:tex_conceal='abdmg'

" Sane defs for completion window navigation
inoremap <silent><expr> <Tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Zettelkasten
let g:goyo_width=&textwidth
let g:vimwiki_list = [{
            \ 'path': '~/vimwiki/',
            \ 'path_html': '~/ops/web',
            \ 'template_path': '~/vimwiki/templates/',
            \ 'template_default': 'main',
            \ 'template_ext': '.html',
            \ 'nested_syntaxes': {'python': 'python', 'cpp': 'cpp', 'bash': 'bash'}
            \ }]
let g:vimwiki_user_htmls = 'templates/main.html'
nnoremap <silent> <Leader>/ :Denite -default-action=quickfix -no-empty grep:~/vimwiki<CR>
nnoremap <Leader>wt :e ~/vimwiki/TODOs.wiki<CR>G
nnoremap <Leader>wb :e ~/vimwiki/Buffer.wiki<CR>G
nnoremap <Leader>go :Goyo<CR>
"nnoremap <C-Space> <Plug>VimwikiToggleListItem
let g:vimwiki_table_mappings = 0

" Yank to system clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" General Mappings
nnoremap <Leader>" viw<Esc>a"<Esc>bi"<Esc>lel
vnoremap <Leader>' <Esc><Esc>`>a"<Esc>`<i"<Esc>`>lel
nnoremap <Leader>vs  :vsplit<CR><C-w><C-w>
nnoremap <Leader>hs  :split<CR><C-w><C-w>
nnoremap <Leader>ev  :e ~/dotfiles/.vimrc<CR>
nnoremap <Leader>sv  :source $MYVIMRC<CR>
nnoremap <Leader>ps  :PlugStatus<CR>
nnoremap <Leader>np  :e ~/ops/web/_posts/
nnoremap <Leader>dd  :bp\|bd # <CR>
nnoremap <C-k> :Gstatus<CR>
nnoremap <C-l> :Gpush<CR>
nnoremap <C-/> I//<Esc>

" Dispatcher
nnoremap <C-d> :Dispatch!<CR>

"Session management
let g:session_dir = '~/.vim/sessions'
exec 'nnoremap <Leader>ss :mks! ' . g:session_dir . '/'
exec 'nnoremap <Leader>sr :so ' . g:session_dir . '/'

" Map jk to escape
inoremap <special> jk <Esc>

" Abbreviations
iabbrev inc #include
iabbrev prag #pragma once

" Folds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
nnoremap <silent> <Leader><Space> @=(foldlevel('.')?'zA':"\<Space>")<CR>
vnoremap <Space>  zf

let g:vimtex_quickfix_latexlog = {'default' : 0}

silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)
