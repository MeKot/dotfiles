set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

"Terminal buffer mappings
tnoremap jk <C-\><C-N>
nnoremap term :vnew<CR><C-w><C-w>:terminal<CR>
