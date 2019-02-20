set nocompatible
set path+=.,./**,$PWD/** " Giving Denite a helpful hand in file_rec
let g:monokai_term_italic = 1

" Think of using Dein? dark side of the force and stuff
call plug#begin('~/.vim/plugged')

Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'honza/vim-snippets' 
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
Plug 'zchee/deoplete-jedi'
Plug 'davidhalter/jedi-vim'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-clang'
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/deoppet.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'chemzqm/denite-extra'
Plug 'vimwiki/vimwiki'
Plug 'sheerun/vim-polyglot', {'dir': '~/.vim/plugged/vim-polyglot/', 'do': './build'}
Plug 'slashmili/alchemist.vim'

call plug#end() 

set omnifunc=syntaxcomplete#Complete
filetype plugin on
syntax on

" Probably should extract nord overrides into a different file
augroup nordkot-overrides
  autocmd!
  autocmd ColorScheme nordkot hi VertSplit none
  autocmd ColorScheme nordkot hi Search none
  autocmd ColorScheme nordkot hi link Search Underlined
  autocmd ColorScheme nordkot hi WildMenu none
  autocmd ColorScheme nordkot hi link WildMenu Underlined
  autocmd ColorScheme nordkot hi Todo none
  autocmd ColorScheme nordkot hi link Todo ModeMsg
  autocmd ColorScheme nordkot hi ErrorMsg none
  autocmd ColorScheme nordkot hi link ErrorMsg SpellBad
  autocmd ColorScheme nordkot hi Error none
  autocmd ColorScheme nordkot hi link Error ErrorMsg
  autocmd ColorScheme nordkot hi WarningMsg none
  autocmd ColorScheme nordkot hi link WarningMsg SpellCap
  autocmd ColorScheme nordkot hi DiffChange none
  autocmd ColorScheme nordkot hi link DiffChange WarningMsg
  autocmd ColorScheme nordkot hi DiffDelete none
  autocmd ColorScheme nordkot hi link DiffDelete SpellBad
  autocmd ColorScheme nordkot hi DiffAdd none
  autocmd ColorScheme nordkot hi link DiffAdd String
augroup END

color nordkot

let mapleader=',' 
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

" Airline plugin configuration
let g:airline_theme='nord'
let g:airline_powerline_fonts            = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ycm#enabled     = 1
let g:airline#extensions#tabline#excludes = ['denite']

" Highlight search but not on every refresh (just purges the search buffer)
let @/=""

" Easy Align configuration
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Sane defs for YCM
"let g:error = '●' " Less aggressive than the default '>>'
"let g:todo = '@' " Less aggressive than the default '>>'
"let g:ycm_global_ycm_extra_conf='~/dotfiles/.ycm_extra_conf.py'
"let g:ycm_always_populate_location_list = 1
"let g:ycm_seed_identifiers_with_syntax = 1
"let g:ycm_key_list_select_completion=[]
"let g:ycm_key_list_previous_completion=[]
"hi YcmErrorSection none
"hi link YcmErrorSection DiffDelete
"autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
inoremap <silent><expr> <Tab> pumvisible() ? "\<c-n>" : "\<tab>"

"
let g:deoplete#enable_at_startup = 1
imap <C-x>     <Plug>(neosnippet_expand_or_jump)
smap <C-x>     <Plug>(neosnippet_expand_or_jump)
xmap <C-x>     <Plug>(neosnippet_expand_target)
" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#enable_completed_snippet = 1
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/plugged/ultisnips/snippets'
let g:deoplete#sources#clang#libclang_path='/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header='/usr/lib/clang'
let g:jedi#completions_enabled = 0 " Keeping Jedi actions and deoplete complete

"
let g:UltiSnipsExpandTrigger="<C-x>"
let g:UltiSnipsJumpForwardTrigger="<C-x>"

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
nnoremap <C-h> :Denite -split=vertical -winwidth=80 outline -mode=insert<Cr>
nnoremap <C-s> :Denite file_rec <CR>
nnoremap <C-b> :Denite buffer <CR>
nnoremap <Leader>/  :Denite -default-action=quickfix -no-empty grep<Cr>
nnoremap <Leader>sh :Denite -split=vertical -winwidth=45 -direction=dynamictop history:search -mode=normal<Cr>
nnoremap <Leader>sy :Denite -split=vertical -winwidth=45 -direction=dynamictop neoyank -mode=normal<Cr>
nnoremap <Leader>m  :Denite -split=vertical -winwidth=100 tag -mode=insert<Cr>

" Yank to system clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" General Mappings
nnoremap <Leader>" viw<Esc>a"<Esc>bi"<Esc>lel
vnoremap <Leader>' <Esc><Esc>`>a"<Esc>`<i"<Esc>`>lel
nnoremap <Leader>vs  :vsplit<CR>
nnoremap <Leader>hs  :split<CR>
nnoremap <Leader>ev  :e ~/dotfiles/.vimrc<CR> 
nnoremap <Leader>sv  :source $MYVIMRC<CR>
nnoremap <Leader>ps  :PlugStatus<CR>
nnoremap <Leader>dd  :bp\|bd # <CR>
nnoremap <Leader>t   :terminal zsh<CR>:set modifiable<CR>
nnoremap <Leader>go  :Goyo<CR>
nnoremap <Leader>gp  :Goyo 200x95<CR>
nnoremap <C-k> :Gstatus<CR>
nnoremap <C-l> :Gpush<CR>
nnoremap <C-c> :cc!<CR>
nnoremap <C-f> :YcmCompleter FixIt<CR>
nnoremap <C-/> I//<Esc>

" Dispatcher
nnoremap <C-d> :Dispatch<CR>

" Timestamps
nnoremap ts i<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>

nmap <C-e> <Plug>VimwikiToggleListItem
let g:vimwiki_table_mappings = 0

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

cmap Q q
cmap W w
