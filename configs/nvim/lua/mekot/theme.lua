-- Colorscheme built with `lush.nvim`, modeled initially on Solarized.
-- Colors are injected by Nix via vim.g.nix_colors. Fallback values here
-- match the Nix-side defaults so the theme works even without a rebuild.
-- https://github.com/rktjmp/lush.nvim
local lush = require 'lush'
local hsl = lush.hsl
local seq = require 'pl.seq'

local M = {}

-- Read a color from the Nix-injected global, falling back to a hardcoded default.
local nix = vim.g.nix_colors or {}
local function c(key, fallback) return hsl(nix[key] or fallback) end

M.colors = {
  darkBase     = c('darkBase',     '#242120'),
  darkestTone  = c('darkestTone',  '#1f1e1c'),
  darkBaseHl   = c('darkBaseHl',   '#312c2b'),
  darkTone     = c('darkTone',     '#393230'),
  lightTone    = hsl '#413937',              -- minor surface tone; keep hardcoded
  lightBaseHl  = hsl '#49403c',             -- minor surface tone; keep hardcoded
  lightestTone = c('lightestTone', '#90817b'),
  lightBase    = c('lightBase',    '#e4e3e1'),
  yellow       = c('yellow',       '#f0c66f'),
  orange       = c('orange',       '#f08d71'),
  red          = c('red',          '#f86882'),
  magenta      = hsl '#55393d',             -- dark burgundy; nvim-only, keep hardcoded
  violet       = c('violet',       '#9fa0e1'),
  blue         = c('blue',         '#81d0c9'),
  cyan         = c('cyan',         '#2aa198'),
  green        = c('green',        '#a6cd77'),
  darkGreen    = hsl '#748F53',             -- dim green; nvim-only, keep hardcoded
  muted        = c('muted',        '#6a5e59'),
}

-- A table of strings with the name of additional Lush specs that should be merged with the
-- colorscheme.
M.extraLushSpecs = {}

-- Function called from `../colors/mekot.vim` to load the colorscheme.
M.loadColorscheme = function ()
  vim.o.pumblend = 10
  vim.o.winblend = vim.o.pumblend

  -- Unload all Lush specs so they are regenerated whenever the colorscheme is reapplied.
  package.loaded['lush_theme.mekot'] = nil
  seq(M.extraLushSpecs):foreach(function(v) package.loaded[v] = nil end)

  -- Merge the main colorscheme spec with any additional specs that were provided.
  local finalSpec = lush.merge {
    require 'lush_theme.mekot',
    lush.merge(seq(M.extraLushSpecs):map(require):copy())
  }

  -- Apply colorscheme
  lush(finalSpec)
  vim.api.nvim_set_hl(0, "@markup.strikethrough", { strikethrough = true })

  -- Set `nvim-web-devicons` highlights if they are in use
  if pcall(require, 'nvim-web-devicons') then require'nvim-web-devicons'.setup() end
end

return M
