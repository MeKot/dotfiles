set nocompatible
let g:monokai_term_italic = 1

" Think of using Dein? dark side of the force and stuff
call plug#begin('~/.vim/plugged')

" Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-repeat'
Plug 'vim-airline/vim-airline'
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'vimwiki/vimwiki'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'chrisbra/Colorizer'
Plug 'lervag/vimtex'
Plug 'honza/vim-snippets'

call plug#end()

set omnifunc=syntaxcomplete#Complete
filetype plugin on
syntax on

augroup NordKotOverrides
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

" function! s:auto_goyo()
"   echom &ft
"   if &ft == 'denite-filter' || &ft == 'denite'
"     echom "Detected"
"   elseif &ft == 'vimwiki'
"    Goyo 100
"   elseif exists('#goyo')
"     Goyo!
"   endif
" endfunction
"
" autocmd BufEnter * call s:auto_goyo()

augroup RemoveTrailingWhitespace
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
augroup END

augroup CURSORLINE
  autocmd!
  autocmd InsertEnter * set nocursorline
  autocmd InsertLeave * set cursorline
augroup END

augroup DENITE
  autocmd!
  autocmd FileType denite setlocal noswapfile
augroup END

augroup WIKI
  autocmd!
  autocmd FileType vimwiki setlocal spell
  autocmd BufEnter,BufNewFile *.wiki setlocal spell
augroup END

" My own flavour of nord
color nordkot

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

" Airline plugin configuration
let g:airline_theme='nord'
let g:airline_powerline_fonts            = 1
let g:airline#extensions#tabline#excludes = ['denite']

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

" Modifying the Nord colorscheme for Denite and Fugitive diffs
hi! link DiffAdd Question
hi! link DiffChange Underlined
hi! link DiffDelete WarningMsg
hi! link DiffText Statement
hi! link Folded VisualNC
hi! link FoldColumn LineNr
hi! link Visual airline_x

" Define mappings
augroup user_plugin_denite
  autocmd!

  autocmd FileType denite call s:denite_settings()

  autocmd VimResized * call denite#custom#option('_', {
        \   'winwidth': &columns,
        \   'winheight': &lines / 3,
        \   'winrow': (&lines - 3) - (&lines / 3),
        \ })
augroup END

function! s:denite_settings() abort
  setlocal signcolumn=no cursorline

  nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
  nnoremap <silent><buffer><expr> i    denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> /    denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> dd   denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p    denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> st   denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> sg   denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> sv   denite#do_map('do_action', 'split')
  nnoremap <silent><buffer><expr> '    denite#do_map('quick_move')
  nnoremap <silent><buffer><expr> q    denite#do_map('quit')
  nnoremap <silent><buffer><expr> r    denite#do_map('redraw')
  nnoremap <silent><buffer><expr> yy   denite#do_map('do_action', 'yank')
  nnoremap <silent><buffer><expr> <Esc>   denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Tab>   denite#do_map('choose_action')
  nnoremap <silent><buffer><expr><nowait> <Space> denite#do_map('toggle_select').'j'
endfunction

call denite#custom#var('file/rec', 'command',
      \ ['ag', '-U', '--hidden', '--follow', '--nocolor', '--nogroup',
      \ '--ignore-dir', 'build/', '--ignore-dir', '.*/', '-g', ''])

call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#var('grep', 'default_opts',
      \ [ '--skip-vcs-ignores', '--vimgrep', '--smart-case', '--hidden' ])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

call denite#custom#option('_', {
      \ 'split': 'bottom',
      \ 'auto_resume': 1,
      \ 'start_filter': 1,
      \ 'statusline': 0,
      \ 'smartcase': 1,
      \ 'vertical_preview': 1,
      \ 'direction': 'dynamicbottom',
      \ 'filter_updatetime': 20,
      \ 'prompt': 'λ❯❯',
      \ })

call denite#custom#source(
      \ 'buffer,file_mru,file_old',
      \ 'converters', ['converter_relative_word'])

" Denite activation mappings
nnoremap <silent> E :Denite file/rec<CR>
nnoremap <silent> <M-o> :Denite outline<CR>
nnoremap <silent> B :Denite buffer<CR>
nnoremap <silent> W :Denite window<CR>
nnoremap <silent> <M-x> :Denite command<CR>
nnoremap <silent> <Leader>m :Denite tag<CR>
nnoremap // :Denite -default-action=quickfix -no-empty grep<CR>

" Spelling
nnoremap <C-c> :Denite spell<CR>

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
nnoremap <Leader>t :e ~/vimwiki/TODOs.wiki<CR>G
nnoremap <Leader>b :e ~/vimwiki/Buffer.wiki<CR>G
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

" Use <C-x> for trigger snippet expand.
imap <C-x> <Plug>(coc-snippets-expand)

" Use <C-x> for select text for visual placeholder of snippet.
vmap <C-x> <Plug>(coc-snippets-select)

inoremap <silent><expr> <C-x> pumvisible() ?coc#_select_confirm() :
      \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <C-x> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<C-x>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-x> <Plug>(coc-snippets-expand-jump)
nmap <Leader>rn <Plug>(coc-rename)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <C-e> :CocList diagnostics<CR>

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

cmap Q q
cmap W w
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)
