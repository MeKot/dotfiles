" Colorscheme build in Lua with `lush.nvim`, modeled initially on Solarized, but intended to be
" usable with alternate colors.
" Still early days, with lots of work needed
" See `../lua/mekot/theme.lua`
let g:colors_name = 'mekot'

" Load colorscheme
lua require'mekot.theme'.loadColorscheme()
