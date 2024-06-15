local utils = require 'mekot.utils'
local augroup = utils.augroup
local keymaps = utils.keymaps

local o = vim.o
local wo = vim.wo
local g = vim.g
local cmd = vim.cmd


g.mapleader=','
g.maplocalleader='§'

o.tabstop=2
o.textwidth=99
o.shiftwidth=2
o.softtabstop=0
o.conceallevel=2
o.timeoutlen = 500
o.colorcolumn="100"
o.foldmethod="manual"
o.background = "dark"

o.hls=true
o.wrap=true
o.number=true
o.hidden=true
o.cindent=true
o.showcmd=true
o.autoread=true
o.smarttab=true
o.smartcase=true
o.expandtab=true
o.cursorline=true
o.autoindent=true
o.termguicolors=true
o.relativenumber=true

if g.vscode == nil then
  require'mekot.theme'.extraLushSpecs = {

    'lush_theme.mekot.statusline',
    'lush_theme.mekot.telescope-nvim',
  }

  cmd 'colorscheme mekot'
end

cmd 'inoremap <special> jk <Esc>'

-- WhichKey maps -----------------------------------------------------------------------------------

-- Define all `<Space>` prefixed keymaps with which-key.nvim
-- https://github.com/folke/which-key.nvim
cmd 'packadd which-key.nvim'
cmd 'packadd! gitsigns.nvim' -- needed for some mappings
local wk = require 'which-key'
wk.setup { plugins = { spelling = { enabled = true } } }

wk.register ({

  w = {
    name = '+Windows',
    -- Split creation
    s = { '<Cmd>split<CR>'  , 'Split below'     },
    v = { '<Cmd>vsplit<CR>' , 'Split right'     },
    q = { '<Cmd>q<CR>'      , 'Close'           },
    o = { '<Cmd>only<CR>'   , 'Close all other' },

    -- Resize
    ['='] = { '<Cmd>wincmd =<CR>'            , 'All equal size'   },
    ['-'] = { '<Cmd>resize -5<CR>'           , 'Decrease height'  },
    ['+'] = { '<Cmd>resize +5<CR>'           , 'Increase height'  },
    ['<'] = { '<Cmd><C-w>5<<CR>'             , 'Decrease width'   },
    ['>'] = { '<Cmd><C-w>5><CR>'             , 'Increase width'   },
    ['|'] = { '<Cmd>vertical resize 106<CR>' , 'Full line-lenght' },
  },

  -- Git
  g = {
    name = '+Git',
    -- vim-fugitive
    b = { '<Cmd>Git blame<CR>' , 'Blame'  },
    s = { '<Cmd>Git<CR>'    , 'Status' },
    d = {
      name = '+Diff',
      s = { '<Cmd>Gdiffsplit<CR>' , 'Split horizontal' },
      v = { '<Cmd>Gvdiffsplit<CR>' , 'Split vertical'   },
    },

    -- gitsigns.nvim
    h = {
      name = '+Hunks',
      s = { require'gitsigns'.stage_hunk      , 'Stage'      },
      u = { require'gitsigns'.undo_stage_hunk , 'Undo stage' },
      r = { require'gitsigns'.reset_hunk      , 'Reset'      },
      n = { require'gitsigns'.next_hunk       , 'Go to next' },
      N = { require'gitsigns'.prev_hunk       , 'Go to prev' },
      p = { require'gitsigns'.preview_hunk    , 'Preview'    },
    },

    -- telescope.nvim lists
    l = {
      name = '+Lists',
      s = { '<Cmd>Telescope git_status<CR>'  , 'Status'         },
      c = { '<Cmd>Telescope git_commits<CR>' , 'Commits'        },
      C = { '<Cmd>Telescope git_commits<CR>' , 'Buffer commits' },
      b = { '<Cmd>Telescope git_branches<CR>' , 'Branches'      },
    },
  },

   -- Language server
  l = {
    name = '+LSP',
    h = { vim.lsp.buf.hover               , 'Hover'                   },
    d = { vim.lsp.buf.definition          , 'Jump to definition'      },
    D = { vim.lsp.buf.declaration         , 'Jump to declaration'     },
    ca = { vim.lsp.buf.code_action        , 'Code action'             },
    cl = { vim.lsp.codelens.run           , 'Code lens'               },
    f = { vim.lsp.buf.format              , 'Format'                  },
    r = { vim.lsp.buf.rename              , 'Rename'                  },
    t = { vim.lsp.buf.type_definition     , 'Jump to type definition' },
    n = { function() vim.diagnostic.goto_next({float = false}) end, 'Jump to next diagnostic' },
    N = { function() vim.diagnostic.goto_prev({float = false}) end, 'Jump to next diagnostic' },
    l = {
      name = '+Lists',
      a = { '<Cmd>Telescope lsp_code_actions<CR>'       , 'Code actions'         },
      A = { '<Cmd>Telescope lsp_range_code_actions<CR>' , 'Code actions (range)' },
      r = { '<Cmd>Telescope lsp_references<CR>'         , 'References'           },
      s = { '<Cmd>Telescope lsp_document_symbols<CR>'   , 'Documents symbols'    },
      S = { '<Cmd>Telescope lsp_workspace_symbols<CR>'  , 'Workspace symbols'    },
    },
  },

  -- Seaching with telescope.nvim
  s = {

    name = '+Search',
    b = { '<Cmd>Telescope file_browser<CR>'              , 'File Browser'           },
    f = { '<Cmd>Telescope find_files_workspace<CR>'      , 'Files in workspace'     },
    F = { '<Cmd>Telescope find_files<CR>'                , 'Files in cwd'           },
    g = { '<Cmd>Telescope live_grep_workspace<CR>'       , 'Grep in workspace'      },
    G = { '<Cmd>Telescope live_grep<CR>'                 , 'Grep in cwd'            },
    l = { '<Cmd>Telescope current_buffer_fuzzy_find<CR>' , 'Buffer lines'           },
    o = { '<Cmd>Telescope oldfiles<CR>'                  , 'Old files'              },
    t = { '<Cmd>Telescope builtin<CR>'                   , 'Telescope lists'        },
    w = { '<Cmd>Telescope grep_string_workspace<CR>'     , 'Grep word in workspace' },
    W = { '<Cmd>Telescope grep_string<CR>'               , 'Grep word in cwd'       },
    s = { '<Cmd>Telescope spell_suggest<CR>'             , 'Spell suggest'          },

    v = {
      name = '+Vim',
      a = { '<Cmd>Telescope autocommands<CR>'    , 'Autocommands'    },
      b = { '<Cmd>Telescope buffers<CR>'         , 'Buffers'         },
      c = { '<Cmd>Telescope commands<CR>'        , 'Commands'        },
      C = { '<Cmd>Telescope command_history<CR>' , 'Command history' },
      h = { '<Cmd>Telescope highlights<CR>'      , 'Highlights'      },
      q = { '<Cmd>Telescope quickfix<CR>'        , 'Quickfix list'   },
      l = { '<Cmd>Telescope loclist<CR>'         , 'Location list'   },
      m = { '<Cmd>Telescope keymaps<CR>'         , 'Keymaps'         },
      o = { '<Cmd>Telescope vim_options<CR>'     , 'Options'         },
      r = { '<Cmd>Telescope registers<CR>'       , 'Registers'       },
      t = { '<Cmd>Telescope filetypes<CR>'       , 'Filetypes'       },
    },

    ['?'] = { '<Cmd>Telescope help_tags<CR>', 'Vim help' },
  },

  y = {

    name = '+Yank',
    y = { '"+yy', 'Yank current line to system clipboard' },
  },

}, { prefix = ',' })

-- Spaced prefiexd in mode Visual mode
wk.register ({
  l = {
    name = '+LSP',
    a = { vim.lsp.buf.range_code_action , 'Code action (range)' , mode = 'v' },
  },

  y = { '"+y', 'Yank Selection to system clipboard' },

}, { prefix = ',' })

vim.cmd [[

augroup RemoveTrailingWhitespace
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
augroup END

augroup CURSORLINE
  autocmd!
  autocmd InsertEnter * set nocursorline
  autocmd InsertLeave * set cursorline
augroup END

augroup NEORG
  autocmd!
  autocmd FileType neorg setlocal spell
  autocmd BufEnter,BufNewFile *.norg setlocal spell
augroup END

]]
