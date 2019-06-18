set nocompatible
set path+=.,./**,$PWD/** " Giving Denite a helpful hand in file_rec
let g:monokai_term_italic = 1

" Think of using Dein? dark side of the force and stuff
call plug#begin('~/.vim/plugged')

Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'vimwiki/vimwiki'
Plug 'neoclide/coc.nvim', { 'do': './install.sh nightly' }

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

" Sane defs for YCM
inoremap <silent><expr> <Tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Modifying the Nord colorscheme for Denite and Fugitive diffs
hi! link DiffAdd Question
hi! link DiffChange Underlined
hi! link DiffDelete WarningMsg
hi! link DiffText Statement
hi! link Folded VisualNC
hi! link FoldColumn LineNr
hi! link Visual airline_x

" Define mappings
autocmd FileType denite call s:denite_my_settings()                                             
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
        \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
        \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
        \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
        \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
        \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
        \ denite#do_map('toggle_select').'j'
endfunction

call denite#custom#var('file/rec', 'command',    
        \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

" Silver searcher command on grep source
call denite#custom#var('grep', 'command', ['ag'])

" Custom options for ripgrep
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" Denite configs for search popup window
call denite#custom#option('_', 'statusline', v:false)
call denite#custom#option('_', 'split', 'floating')
call denite#custom#option('_', 'start_filter', v:true)
call denite#custom#option('_', 'auto_resize', v:true)
call denite#custom#option('_', 'prompt', 'λ:')
call denite#custom#option('_', 'direction', 'dynamicbottom')
call denite#custom#option('_', 'filter_updatetime', 5)
call denite#custom#option('_', 'auto_resume', v:true)
call denite#custom#option('_', 'source_names', 'short')
call denite#custom#option('_', 'vertical_preview', v:true)

" Denite activation mappings 
let g:denite_source_history_yank_enable = 1
nnoremap <silent> <C-s> :Denite -no-statusline file/rec<CR>
nnoremap <silent> <M-o> :Denite outline<CR>
nnoremap <silent> <C-b> :Denite buffer<CR>
nnoremap <silent> <C-c> :Denite command<CR>
nnoremap <silent> <C-h> :Denite help<CR>
nnoremap <silent> <Leader>/ :Denite -default-action=quickfix -no-empty grep<CR>
nnoremap <silent> <Leader>m :Denite -winwidth=100 tag<CR>

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
nnoremap <Leader>dd  :bp\|bd # <CR>
nnoremap <Leader>t   :terminal zsh<CR>:set modifiable<CR>
nnoremap <Leader>go  :Goyo<CR>
nnoremap <Leader>gp  :Goyo 200x95<CR>
nnoremap <C-k> :Gstatus<CR>
nnoremap <C-l> :Gpush<CR>
nnoremap <M-x> :Denite command <CR>
nnoremap <C-/> I//<Esc>

" Use <C-l> for trigger snippet expand.
imap <C-x> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-x> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<tab>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<tab>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-x> <Plug>(coc-snippets-expand-jump)

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
