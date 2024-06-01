-- Colorscheme build in Lua with `lush.nvim`, modeled initially on Solarized, but intended to be
-- usable with alternate colors.
-- Still early days, with lots of work needed
-- https://github.com/rktjmp/lush.nvim
local lush = require 'lush'
local hsl = lush.hsl
local seq = require 'pl.seq'

local M = {}

-- Default colors are the Solarized colors
M.colors = {
  darkBase     = hsl '#1f1e1c', -- base03
  darkBaseHl   = hsl '#242120', -- base02
  darkestTone  = hsl '#312c2b', -- base01
  darkTone     = hsl '#393230', -- base00
  lightTone    = hsl '#413937', -- base0
  lightestTone = hsl '#49403c', -- base1
  lightBaseHl  = hsl '#90817b', -- base2
  lightBase    = hsl '#e4e3e1', -- base3
  yellow       = hsl '#f0c66f',
  orange       = hsl '#f08d71',
  red          = hsl '#f86882',
  magenta      = hsl '#55393d',
  violet       = hsl '#9fa0e1',
  blue         = hsl '#81d0c9',
  cyan         = hsl '#2aa198',
  green        = hsl '#a6cd77',
}

-- A table of strings with the name of additonal Lush specs that should be merged with the
-- colorscheme.
M.extraLushSpecs = {}

-- Function called from `../colors/mekot.vim` to load the colorscheme.
M.loadColorscheme = function ()
  vim.o.pumblend = 10
  vim.o.winblend = vim.o.pumblend

  -- We need to unload all Lush specs so that the specs are regenerated whenever the colorscheme is
  -- reapplied.
  package.loaded['colors.mekot'] = nil
  seq(M.extraLushSpecs):foreach(function(v) package.loaded[v] = nil end)

  -- Merge the main colorscheme spec with any additional specs that were provided.
  local finalSpec = lush.merge {
    require 'colors.mekot',
    lush.merge(seq(M.extraLushSpecs):map(require):copy())
  }

  -- Apply colorscheme
  lush(finalSpec)

  -- Set `nvim-web-devincons` highlights if they are in use
  if pcall(require, 'nvim-web-devicons') then require'nvim-web-devicons'.setup() end
end

return M
