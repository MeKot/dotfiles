set nocompatible               
set rtp+=/usr/local/opt/fzf
set shellpipe=>
set path=.,./**,$PWD/**

let g:monokai_term_italic = 1

call plug#begin('~/.vim/plugged')

Plug 'arcticicestudio/nord-vim'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
Plug 'junegunn/vim-easy-align', {'on': 'EasyAlign'}
Plug 'vim-airline/vim-airline'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neosnippet.vim' 
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-clang'
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/denite.nvim'
Plug 'chemzqm/denite-extra'
Plug 'Shougo/neoyank.vim'
Plug 'tsukkee/unite-tag'

call plug#end() 

set omnifunc=syntaxcomplete#Complete

let mapleader=','
set autoindent
set cindent
set cursorline
set expandtab
"set foldmethod=syntax
set hls
set incsearch
set number
set relativenumber 
set shiftwidth=2 
set showcmd
set smarttab
set softtabstop=0
set tabstop=2
set wrap

"Airline plugin configuration
let g:airline_theme='nord'
let g:airline#extensions#ale#enabled     = 1
let g:airline_powerline_fonts            = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ycm#enabled     = 1
let g:airline#extensions#tabline#excludes = ['denite']

"Highlight search but not when resourcing the vimrc
let @/=""

"Easy Align configuration
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"Bracket completion for vim, manually, noplugin
inoremap {<CR> {<CR><CR>}<Up><Space><Tab><End> 
inoremap { {}<Esc>i
inoremap [ []<Esc>i
inoremap ( ()<Esc>i
inoremap " ""<Esc>i

"Deoplete configs, trying new things
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path='/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
let g:deoplete#sources#clang#clang_header='/Library/Developer/CommandLineTools/usr/lib/clang/9.0.0'
let g:deoplete#auto_complete_delay=5
let g:deoplete#enable_smart_case = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

"NeoSnippet configuration
imap <C-x>     <Plug>(neosnippet_expand_or_jump)
smap <C-x>     <Plug>(neosnippet_expand_or_jump)
xmap <C-x>     <Plug>(neosnippet_expand_target)
let g:neosnippet#enable_completed_snippet=1

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

"Abbreviations
iabbrev ccopy Copyright 2018 Ivan Kotegov, all rights reserved.
iabbrev inc #include
iabbrev prag #pragma once

"Denite custom maps 
call denite#custom#map(
      \ 'normal',
      \ '<C-j>',
      \ '<denite:quit>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'normal',
      \ '<Leader>m',
      \ '<denite:quit>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'normal',
      \ '<Esc>',
      \ '<NOP>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'insert',
      \ 'jk',
      \ '<denite:enter_mode:normal>',
      \ 'noremap'
      \)

" Modifying the Nord colorscheme for DEnite and Diff
" Diff
hi! link DiffAdd Question
hi! link DiffChange Underlined
hi! link DiffDelete WarningMsg

" Denite
call denite#custom#option('_', 'highlight_mode_insert', 'CursorLine')
call denite#custom#option('_', 'highlight_matched_range', 'None')
call denite#custom#option('_', 'highlight_matched_char', 'None')

"Denite mappings
let g:denite_source_history_yank_enable = 1
nnoremap ff :Denite file_rec<Cr>
nnoremap <Leader>/  :Denite -no-empty grep<Cr>
nnoremap <Leader>sh :Denite -split=vertical -winwidth=45 -direction=dynamictop history:search -mode=normal<Cr>
nnoremap <Leader>sc :Denite -split=vertical -winwidth=45 -direction=dynamictop history:cmd -mode=normal<Cr>
nnoremap <Leader>sy :Denite -split=vertical -winwidth=45 -direction=dynamictop neoyank -mode=normal<Cr>
nnoremap <Leader>m  :Denite -split=vertical -winwidth=80 tag -mode=insert<Cr>

"Mappings 
nnoremap <Leader>" viw<Esc>a"<Esc>bi"<Esc>lel
vnoremap <Leader>' <Esc><Esc>`>a"<Esc>`<i"<Esc>`>lel
nnoremap <Leader>vs  :vsplit<cr>
nnoremap <Leader>hs  :split<cr>
nnoremap <Leader>ev  :tabe ~/.vimrc<CR> 
nnoremap <Leader>sv  :source $MYVIMRC<cr>
nnoremap <Leader>ps  :PlugStatus<CR>
nnoremap <Leader>dd  :bp\|bd # <CR>
nnoremap <Leader>t   :terminal zsh<CR>:set modifiable<CR>
nnoremap <Leader>go  :Goyo<CR>
nnoremap <Leader>gp  :Goyo 200x95%<CR>
nmap <Leader>[ <Plug>AirlineSelectPrevTab
nmap <Leader>] <Plug>AirlineSelectNextTab

nnoremap <C-k> :noh<CR>
nnoremap tt <C-w><C-w> 
inoremap <special> jk <Esc>
inoremap qq <Esc>$a

nnoremap <Left> <nop>
nnoremap <Right> <nop>
nnoremap <Up> <nop>
nnoremap <Down> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

nnoremap :W  :w
nnoremap :Wq :wq
nnoremap :WQ :wq
nnoremap :Q  :q
nnoremap :wQ :wq

"Moving multiple selected lines in visual mode
vmap : <esc>gv<Plug>SwapVisualCursor
vnoremap <expr> <Plug>SwapVisualCursor line('.') == line("'<") ? ':' : 'o:'

"Folds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
nnoremap <silent> <Leader><Space> @=(foldlevel('.')?'zA':"\<Space>")<CR>
vnoremap <Space>  zf
