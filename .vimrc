set path=.,./**,$PWD/** " Giving Denite a helpful hand in file_rec
let g:monokai_term_italic = 1

" Think of using Dein? dark side of the force and stuff
call plug#begin('~/.vim/plugged')

Plug 'arcticicestudio/nord-vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
Plug 'junegunn/vim-easy-align'
Plug 'vim-airline/vim-airline'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neosnippet.vim' 
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/deoplete-clangx', {'for': 'c, cpp, cs'}
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/denite.nvim'
Plug 'chemzqm/denite-extra'
"Plug 'Shougo/neoyank.vim' " Still needs a bit of reading up on, check back later

call plug#end() 

set omnifunc=syntaxcomplete#Complete

let mapleader=',' 
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

" Airline plugin configuration
let g:airline_theme='nord'
let g:airline#extensions#ale#enabled     = 1
let g:airline_powerline_fonts            = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ycm#enabled     = 1
let g:airline#extensions#tabline#excludes = ['denite']

" ALE config for React and general JS
"let g:ale_sign_error = '●' " Less aggressive than the default '>>'
"let g:ale_sign_warning = '.'
"let g:ale_lint_on_enter = 0 " Less distracting when opening a new file
"let g:ale_fixers = { 
"\  'javascript': [ 'eslint' ]
"\}
"nnoremap <Leader><Leader> :ALEFix<CR>

" Highlight search but not on every refresh (just purges the search buffer)
let @/=""

" Easy Align configuration
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Deoplete configs
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path='/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
let g:deoplete#sources#clang#clang_header='/Library/Developer/CommandLineTools/usr/lib/clang/9.0.0'
let g:deoplete#auto_complete_delay=5
let g:deoplete#enable_smart_case = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" NeoSnippet configuration
imap <C-x>     <Plug>(neosnippet_expand_or_jump)
smap <C-x>     <Plug>(neosnippet_expand_or_jump)
xmap <C-x>     <Plug>(neosnippet_expand_target)
let g:neosnippet#enable_completed_snippet=1

" Modifying the Nord colorscheme for Denite and Fugitive diffs
hi! link DiffAdd Question
hi! link DiffChange Underlined
hi! link DiffDelete WarningMsg
hi! link DiffText Statement
hi! link Folded VisualNC
hi! link FoldColumn LineNr
hi! link Visual airline_x

" Denite custom maps for ease in normal mode
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
      \ '<denite:quit>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'insert',
      \ 'jk',
      \ '<denite:enter_mode:normal>',
      \ 'noremap'
      \)

" Denite configs for search popup window
call denite#custom#option('_', 'highlight_mode_insert', 'CursorLine')
call denite#custom#option('_', 'highlight_matched_range', 'None')
call denite#custom#option('_', 'highlight_matched_char', 'None')

" Denite search field configs, got to love hammer and sickle
call denite#custom#option('_', {
  \ "prompt": '☭ »»',
  \ 'empty': 0,
  \ 'winheight': 16,
  \ 'source_names': 'short',
  \ 'vertical_preview': 1,
  \ 'auto-accel': 1,
  \ 'auto-resume': 1,
  \ })

" Denite activation mappings 
let g:denite_source_history_yank_enable = 1
nnoremap <C-D> :Denite
nnoremap <C-S> :Denite file_rec <CR>
nnoremap <C-B> :Denite buffer <CR>
nnoremap <Leader>/  :Denite -default-action=quickfix -no-empty grep<Cr>
nnoremap <Leader>sh :Denite -split=vertical -winwidth=45 -direction=dynamictop history:search -mode=normal<Cr>
nnoremap <Leader>sc :Denite -split=vertical -winwidth=45 -direction=dynamictop history:cmd -mode=normal<Cr>
nnoremap <Leader>sy :Denite -split=vertical -winwidth=45 -direction=dynamictop neoyank -mode=normal<Cr>
nnoremap <Leader>m  :Denite -split=vertical -winwidth=80 tag -mode=insert<Cr>

" General Mappings
nnoremap <Leader>" viw<Esc>a"<Esc>bi"<Esc>lel
vnoremap <Leader>' <Esc><Esc>`>a"<Esc>`<i"<Esc>`>lel
nnoremap <Leader>vs  :vsplit<CR>
nnoremap <Leader>hs  :split<CR>
nnoremap <Leader>ev  :e ~/.vimrc<CR> 
nnoremap <Leader>sv  :source $MYVIMRC<CR>
nnoremap <Leader>ps  :PlugStatus<CR>
nnoremap <Leader>dd  :bp\|bd # <CR>
nnoremap <Leader>t   :terminal zsh<CR>:set modifiable<CR>
nnoremap <Leader>go  :Goyo<CR>
nnoremap <Leader>gp  :Goyo 200x95<CR>
nnoremap <C-k> :noh<CR>
nnoremap <C-p> :cp<CR>

inoremap <special> jk <Esc>

" Buffer switching with Tab ans Shift-Tab
" nmap <Tab> <Plug>AirlineSelectNextTab
nmap <S-Tab> <Plug>AirlineSelectPrevTab

" Abbreviations
iabbrev inc #include
iabbrev prag #pragma once

" Folds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
nnoremap <silent> <Leader><Space> @=(foldlevel('.')?'zA':"\<Space>")<CR>
vnoremap <Space>  zf
