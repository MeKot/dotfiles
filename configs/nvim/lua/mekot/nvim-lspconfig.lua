-- nvim-lspconfig
-- Configure available LSPs
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
--
-- Note that all language servers are installed via Nix. See:
-- `../../../../home/neovim.nix`.
local s = require'mekot.utils'.symbols
local foreach = require 'pl.tablex'.foreach
local augroup = require 'mekot.utils'.augroup

-- Configure diagnostic icons
local signs = { Error = s.error, Warn = s.warning, Hint = s.question, Info = s.info }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local lspconf = require 'lspconfig'

local function on_attach(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    augroup { name = 'MekotLspDocumentHighlights' .. bufnr, cmds = {
      {{ 'CursorHold', 'CursorHoldI' }, {
        buffer = bufnr,
        desc = "Create LSP document highlights",
        callback = vim.lsp.buf.document_highlight,
      }},
      {{ 'CursorMoved' }, {
        buffer = bufnr,
        desc = "Clear LSP document highlights",
        callback = vim.lsp.buf.clear_references,
      }},
    }}
  end
end

local servers_config = {
  bashls = {},
  ccls = {},
  jsonls = {},

  nil_ls = {
    settings ={
      ['nil'] = {
        formatting = {
          command = { 'nixpkgs-fmt' },
        },

        nix = {
          flake = {
            autoArchive = true,
            autoEvalInputs = true,
          },
        },
      },
    },
  },

  pyright = {},
  sourcekit = {},

  vimls = {
    init_options = {
      iskeyword = '@,48-57,_,192-255,-#',
      vimruntime = vim.env.VIMRUNTIME,
      runtimepath = vim.o.runtimepath,
      diagnostic = {
        enable = true,
      },
      indexes = {
        runtimepath = true,
        gap = 100,
        count = 8,
        projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
      },
      suggest = {
        fromRuntimepath = true,
        fromVimruntime = true
      },
    }
  },

  yamlls = {
    settings = {
      yaml = {
        format = {
          printWidth = 100,
          singleQuote = true,
        },
      },
    },
  },
}

foreach(servers_config, function(v, k)
  lspconf[k].setup(require'cmp_nvim_lsp'.default_capabilities(
    vim.tbl_extend('error', v, { on_attach = on_attach })
  ))
end)
