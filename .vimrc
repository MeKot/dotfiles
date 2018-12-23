set nocompatible
set path+=.,./**,$PWD/** " Giving Denite a helpful hand in file_rec
let g:monokai_term_italic = 1

" Think of using Dein? dark side of the force and stuff
call plug#begin('~/.vim/plugged')

Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-fugitive', {'on': 'Gcommit'}
Plug 'tpope/vim-surround'
Plug 'Shougo/neosnippet.vim' 
Plug 'arcticicestudio/nord-vim'
Plug 'honza/vim-snippets'
Plug 'junegunn/vim-easy-align'
Plug 'vim-airline/vim-airline'
Plug 'Valloric/YouCompleteMe', {'dir': '~/.vim/plugged/YouCompleteMe/', 'do': './install.py --clang-completer --go-completer --java-completer --ts-completer'}
Plug 'Shougo/denite.nvim'
Plug 'chemzqm/denite-extra'
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'vimwiki/vimwiki'
Plug 'tfnico/vim-gradle', {'for': 'gradle'}

call plug#end() 

set omnifunc=syntaxcomplete#Complete
filetype plugin on
syntax on

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
augroup END

color nordkot

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
let g:error = '●' " Less aggressive than the default '>>'
let g:todo = '@' " Less aggressive than the default '>>'
let g:ycm_global_ycm_extra_conf='~/dotfiles/.ycm_extra_conf.py'
let g:ycm_always_populate_location_list = 1
let g:ycm_seed_identifiers_with_syntax = 1
hi YcmErrorSection none
hi link YcmErrorSection DiffDelete
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
inoremap <silent><expr> <Tab> pumvisible() ? "\<c-n>" : "\<tab>"

imap <C-x>     <Plug>(neosnippet_expand_or_jump)
smap <C-x>     <Plug>(neosnippet_expand_or_jump)
xmap <C-x>     <Plug>(neosnippet_expand_target)
let g:neosnippet#enable_completed_snippet=1
let g:neosnippet#enable_snipmate_compatibility = 1
"let g:neosnippet#snippets_directory='~/.vim/plugged/vim-snippets/UltiSnips'

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
vnoremap  <leader>y  "+y
nnoremap <Leader>vs  :vsplit<CR>
nnoremap <Leader>hs  :split<CR>
nnoremap <Leader>ev  :e ~/dotfiles/.vimrc<CR> 
nnoremap <Leader>sv  :source $MYVIMRC<CR>
nnoremap <Leader>ps  :PlugStatus<CR>
nnoremap <Leader>dd  :bp\|bd # <CR>
nnoremap <Leader>t   :terminal zsh<CR>:set modifiable<CR>
nnoremap <Leader>go  :Goyo<CR>
nnoremap <Leader>gp  :Goyo 200x95<CR>
nnoremap <C-k> :Gcommit<CR>
nnoremap <C-l> :Gpush<CR>
nnoremap <C-c> :cc!<CR>
nnoremap <C-f> :YcmCompleter FixIt<CR>
nnoremap <C-/> I//<Esc>

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
