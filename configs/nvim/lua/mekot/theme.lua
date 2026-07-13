-- lush.nvim colorscheme, modeled on Solarized. Colors come from vim.g.nix_colors.dark/.light
-- (same keys as home/colors.nix); fallbacks here match so it still works without a rebuild.
-- https://github.com/rktjmp/lush.nvim
local lush = require 'lush'
local hsl = lush.hsl
local seq = require 'pl.seq'

local M = {}

local nix = vim.g.nix_colors or {}

-- Tone-scale colors: static per palette (paired via choose() in lush_theme/mekot.lua, e.g.
-- choose(c.darkBase, c.lightBase)) — not resolved against the *current* background here.
local function tone(palette, key, fallback)
  return hsl((nix[palette] or {})[key] or fallback)
end

-- Accent colors: single name, resolved against the *current* vim.o.background — re-evaluated
-- fresh each reload since loadColorscheme() clears this module from package.loaded too.
local function accent(key, fallbackDark, fallbackLight)
  local mode = vim.o.background == 'light' and 'light' or 'dark'
  local fallback = mode == 'light' and fallbackLight or fallbackDark
  return hsl((nix[mode] or {})[key] or fallback)
end

M.colors = {
  darkBase     = tone('dark',  'bg',      '#242120'),
  darkestTone  = tone('dark',  'darkest', '#1f1e1c'),
  darkBaseHl   = tone('dark',  'surface', '#312c2b'),
  darkTone     = tone('dark',  'tone',    '#393230'),
  lightTone    = tone('light', 'tone',    '#ddd0b8'),   -- minor surface tone
  lightBaseHl  = tone('light', 'surface', '#ece3d2'),   -- minor surface tone
  lightestTone = tone('dark',  'subtle',  '#90817b'),   -- bright accent-on-dark-bg; see StrongBg
  lightBase    = tone('light', 'bg',      '#f5efe3'),

  yellow = accent('yellow',  '#f0c66f', '#a97a17'),
  orange = accent('orange',  '#f08d71', '#c1522f'),
  red    = accent('nvimRed', '#f86882', '#c22c46'),
  violet = accent('violet',  '#9fa0e1', '#4a4da3'),
  blue   = accent('blue',    '#81d0c9', '#1a7d73'),
  cyan   = accent('cyan',    '#2aa198', '#1c7a72'),
  green  = accent('green',   '#a6cd77', '#45700f'),
  muted  = accent('muted',   '#6a5e59', '#a89478'),

  -- nvim-only, not part of the shared Nix palette
  magenta   = vim.o.background == 'light' and hsl '#8a3f4a' or hsl '#55393d',
  darkGreen = vim.o.background == 'light' and hsl '#6b7d3f' or hsl '#748F53',
}

-- A table of strings with the name of additional Lush specs that should be merged with the
-- colorscheme.
M.extraLushSpecs = {}

-- Function called from `../colors/mekot.vim` to load the colorscheme.
M.loadColorscheme = function ()
  vim.o.pumblend = 10
  vim.o.winblend = vim.o.pumblend

  -- Unload the color table and all Lush specs so they are regenerated against the current
  -- `vim.o.background` whenever the colorscheme is reapplied.
  package.loaded['mekot.theme'] = nil
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
