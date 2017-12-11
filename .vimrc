set nocompatible              " be iMproved, required
set rtp+=/usr/local/opt/fzf
colorscheme afterglow
let g:monokai_term_italic = 1
let g:monokai_gui_italic  = 1

call plug#begin('~/.vim/plugged')

Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'junegunn/vim-easy-align'
Plug 'w0rp/ale'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes' 
"On-demand loading"
Plug 'scrooloose/nerdtree', { 'on':  'NERDTree' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'rdnetto/YCM-Generator', {'branch': 'stable' }

function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --gocode-completer --omnisharp-completer
  endif
endfunction
Plug 'Valloric/YouCompleteMe', { 'for': ['c', 'cpp'], 'do': function('BuildYCM') }
"" optional load on :YCM
Plug 'Valloric/YouCompleteMe', { 'on': 'YCM'}

call plug#end() 

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

let g:airline#extensions#al#enabled = 1
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1

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
"Bracket completion for vim, manually, noplugin"""""""""""""""""""""""
"
inoremap {<CR> {<CR><CR>}<Up><Space><Tab><End> 
inoremap { {}<Esc>i
inoremap [ []<Esc>i
inoremap ( ()<Esc>i
inoremap " ""<Esc>i
inoremap § <Esc>$a
inoremap qq <Esc>$a

"NERDTree plugin settings""""""""""""""""""""""""""""""""""""""""""""""
"
augroup treeGroup
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup end
"
"UltiSnips plugin settings""""""""""""""""""""""""""""""""""""""""""""""
"
map <Leader>a :UltiSnipsEdit
let g:UltiSnipsSnippetsDir  ='~/.vim//plugged/vim-snippets/snippets/'
let g:UltiSnipsSnippetDirectories=["UltiSnips"]
let g:UltiSnipsEditSplit    ='horizontal'
let g:UltiSnipsEditSplit    ="vertical"
let g:UltiSnipsExpandTrigger="<C-x>"
let g:UltiSnipsJumpForwardTrigger="<C-c>"
let g:UltiSnipsJumpBackwardTrigger="<C-z>"
"
"YCM plugin setup and configuration""""""""""""""""""""""""""""""""""""""
"
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/.ycm_extra_conf.py'

"Abbreviations
iabbrev ccopy Copyright 2017 Ivan Kotegov, all rights reserved.
iabbrev inc #include
iabbrev prag #pragma once
inoreabbrev psvm  public static void main(int argc, char[] argv) {<CR><CR>}<Up><Tab><End> 
"Mappings 
nnoremap <Leader>" viw<Esc>a"<Esc>bi"<Esc>lel
nnoremap ff :FZF<CR>
nnoremap <Leader>t :NERDTree %:p:h<CR> 
vnoremap <Leader>' <Esc><Esc>`>a"<Esc>`<i"<Esc>`>lel
nnoremap <Leader>vs :vsplit<cr>
nnoremap <Leader>hs :split<cr>
nnoremap gen        :YcmGenerateConfig<CR>
nnoremap <Leader>ev <C-w>v :o "~/.vimrc"" 
nnoremap <Leader>sv :source $MYVIMRC<cr>
nnoremap tt <C-w><C-w> 
nnoremap r :later<CR>
nnoremap H 0
nnoremap L $
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
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
:command! WQ wq
:command! Wq wq
:command! W w
:command! Q q

"Autocommands 
augroup markup
	autocmd BufWritePre, BufRead *.html :normal gg=G
augroup end
