set nocompatible               
set rtp+=/usr/local/opt/fzf
set shellpipe=>
let g:monokai_term_italic = 1

call plug#begin('~/.vim/plugged')
""
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/vim-easy-align'
Plug 'vim-airline/vim-airline'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'Valloric/YouCompleteMe'
"On-demand loading"
Plug 'mileszs/ack.vim', { 'on': 'Ack'}
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle'}
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

call plug#end() 
syntax match TODOs ".*TODO.*\|.*BUG.*\|.*HACK.*\|.*FIXIT.*\|.*TESTIT.*"
colorscheme monokai

set foldmethod=syntax
set cursorline
set hlsearch
set incsearch
set shiftwidth=2 
set autoindent
set cindent
set relativenumber 
set number
set wrap
set expandtab
set tabstop=2
set softtabstop=0
set smarttab
set showcmd

let g:airline#extensions#ale#enabled     = 1
let g:airline_powerline_fonts            = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ycm#enabled     = 1

"
"Easy Align configuration
"
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"
"Bracket completion for vim, manually, noplugin"""""""""""""""""""""""
"
let mapleader=','
inoremap {<CR> {<CR><CR>}<Up><Space><Tab><End> 
inoremap { {}<Esc>i
inoremap [ []<Esc>i
inoremap ( ()<Esc>i
inoremap " ""<Esc>i

inoremap § <Esc>$a
inoremap qq <Esc>$a

"NERDTree plugin settings""""""""""""""""""""""""""""""""""""""""""""""
"

"ALE plugin settings"""""""""""""""""""""""""""""""""""""""""""""""""""
"
let g:ale_sign_error   = '>'
let g:ale_sign_warning = '-'

"
"ltiSnips plugin settings"""""""""""""""""""""""""""""""""""""""""""""
"
map <Leader>a :UltiSnipsEdit

let g:UltiSnipsSnippetsDir         = '~/.vim//plugged/vim-snippets/UltiSnips/'
let g:UltiSnipsSnippetDirectories  = ["UltiSnips"]
let g:UltiSnipsEditSplit           = 'horizontal'
let g:UltiSnipsEditSplit           = "vertical"
let g:UltiSnipsExpandTrigger       = "<C-x>"
let g:UltiSnipsJumpForwardTrigger  = "<C-c>"
let g:UltiSnipsJumpBackwardTrigger = "<C-z>"
let g:snips_author                 = "Ivan Kotegov"

"
"YCM plugin setup and configuration""""""""""""""""""""""""""""""""""""""
"
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
let g:ycm_filetype_blacklist={}
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_cofirm_extra_conf=0

"
"TagBar config
"
let g:tagbar_autoclose=1

"Abbreviations
iabbrev ccopy Copyright 2018 Ivan Kotegov, all rights reserved.
iabbrev inc #include
iabbrev prag #pragma once
inoreabbrev psvm  public static void main(int argc, char[] argv) {<CR><CR>}<Up><Tab><End> 

"Mappings 
nnoremap <Leader>" viw<Esc>a"<Esc>bi"<Esc>lel
vnoremap <Leader>' <Esc><Esc>`>a"<Esc>`<i"<Esc>`>lel
nnoremap <Leader>ale :ALEToggle<CR>
nnoremap <Leader>t   :NERDTreeToggle %:p:h<CR> 
nnoremap <Leader>m   :TagbarToggle<CR>
nnoremap <Leader>vs  :vsplit<cr>
nnoremap <Leader>hs  :split<cr>
nnoremap <Leader>ev  :tabe ~/.vimrc<CR> 
nnoremap <Leader>sv  :source $MYVIMRC<cr>
nnoremap <Leader>ps  :PlugStatus<CR>
nnoremap <Leader>dd  :bp\|bd # <CR>
nmap <Leader>. <Plug>AirlineSelectPrevTab
nmap <Leader>/ <Plug>AirlineSelectNextTab

nnoremap ff  :FZF<CR>
nnoremap gen :YcmGenerateConfig<CR>
nnoremap ok  :noh<CR>
nnoremap tt <C-w><C-w> 
nnoremap H 0
nnoremap L $
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
inoremap jk <Esc>

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
"Restoring the folds on exit
augroup FoldRestore
  autocmd BufWinLeave ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent loadview 
augroup END
