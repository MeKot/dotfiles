set nocompatible              " be iMproved, required
set rtp+=/usr/local/opt/fzf
let g:monokai_term_italic = 1

call plug#begin('~/.vim/plugged')
""
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/vim-easy-align'
Plug 'vim-airline/vim-airline'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'Valloric/YouCompleteMe'
Plug 'vimwiki/vimwiki'
"On-demand loading"
""Plug 'vimwiki/vimwiki', {'on': 'VimwikiIndex'}
Plug 'w0rp/ale', {'on': 'ALE'}
Plug 'scrooloose/nerdtree', { 'on':  'NERDTree' }
Plug 'rdnetto/YCM-Generator', {'branch': 'stable', 'on': 'YcmGenerateConfig' }
""
call plug#end() 
syntax match TODOs ".*TODO.*\|.*BUG.*\|.*HACK.*\|.*FIXIT.*\|.*TESTIT.*"
colorscheme monokai

set cursorline
set hlsearch
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
"Speeding up the load time by automatically dropping the connection to the X
"server
"
set clipboard=exclude:.*

"
"Configuring the vimwiki plugin not to steal the Tab event"
"
let g:vimwiki_table_mappings = 0
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
let g:ycm_filetype_blacklist={}
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_cofirm_extra_conf=0
""let g:ycm_global_ycm_extra_conf                    = '~/.vim/bundle/.ycm_extra_conf.py'

"Abbreviations
iabbrev ccopy Copyright 2018 Ivan Kotegov, all rights reserved.
iabbrev inc #include
iabbrev prag #pragma once
inoreabbrev psvm  public static void main(int argc, char[] argv) {<CR><CR>}<Up><Tab><End> 

"Mappings 
nnoremap <Leader>" viw<Esc>a"<Esc>bi"<Esc>lel
nnoremap ff :FZF<CR>
nnoremap <Leader>ale :ALEToggle<CR>
nnoremap <Leader>t :NERDTree %:p:h<CR> 
vnoremap <Leader>' <Esc><Esc>`>a"<Esc>`<i"<Esc>`>lel
nnoremap <Leader>vs :vsplit<cr>
nnoremap <Leader>hs :split<cr>
nnoremap gen        :YcmGenerateConfig<CR>
nnoremap <Leader>ev :tabe ~/.vimrc<CR> 
nnoremap <Leader>sv :source $MYVIMRC<cr>
nnoremap tt <C-w><C-w> 
nnoremap nn :bnext<Cr>
nnoremap ok :noh<CR>
nnoremap r :later<CR>
nnoremap H 0
nnoremap L $
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
vnoremap jk <Esc>
inoremap jk <Esc>
inoremap <Esc> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>
nnoremap <Up> <nop>
nnoremap <Down> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>
nnoremap <Leader>dd :bp\|bd # <CR>
nnoremap :W :w
nnoremap :Wq :wq
nnoremap :WQ :wq
nnoremap :Q :q
nnoremap :wQ :wq

"Folds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
nnoremap <silent> <Leader><Space> @=(foldlevel('.')?'zA':"\<Space>")<CR>
vnoremap <Space> zf
"Restoring the folds on exit
augroup FoldRestore
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent loadview 
augroup END
