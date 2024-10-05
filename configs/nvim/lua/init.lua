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

-- Title: "Folding" ------------------------------------------- {{{

o.foldmethod="marker"

---+ Title: "Fold_text function" Icon: "󰡱 "
FoldText = function()
  local foldStartLine = table.concat(vim.fn.getbufline(vim.api.nvim_get_current_buf(), vim.v.foldstart));

  local title, icon, number;

  local border = foldStartLine:match('Border:%s*"([^"]+)"') or "─";
  local borderLeft = foldStartLine:match('BorderL:%s*"([^"]+)"') or "┤";
  local borderRight = foldStartLine:match('BorderR:%s*"([^"]+)"') or "├";

  local padding = foldStartLine:match('Padding:%s*"(%d+)"') ~= nil and tonumber(foldStartLine:match('Padding:%s*"(%d+)"')) or 1;
  local gap = foldStartLine:match('Gap:%s*"(%d+)"') ~= nil and tonumber(foldStartLine:match('Gap:%s*"(%d+)"')) or 3;

  --- Fold name
  if foldStartLine:match('Title:%s*"([^"]+)"') == "false" then
    title = "";
  elseif foldStartLine:match('Title:%s*"([^"]+)"') == nil and border == " " then
    title = "Fold";
  elseif foldStartLine:match('Title:%s*"([^"]+)"') == nil and border ~= " " then
    title = borderLeft .. " Fold " .. borderRight;
  else
    if border == " " then
      title = foldStartLine:match('Title:%s*"([^"]+)"');
    else
      title = borderLeft .. " " .. foldStartLine:match('Title:%s*"([^"]+)"') .. " " .. borderRight;
    end
  end

  --- Fold icon
  if foldStartLine:match('Icon:%s*"([^"]+)"') == "false" then
    icon = "";
  elseif foldStartLine:match('Icon:%s*"([^"]+)"') == nil and border == " " then
    icon = " ";
  elseif foldStartLine:match('Icon:%s*"([^"]+)"') == nil and border ~= " " then
    icon = borderLeft .. "   " .. borderRight;
  else
    if border == " " then
      icon = foldStartLine:match('Icon:%s*"([^"]+)"');
    else
      icon = borderLeft .. " " .. foldStartLine:match('Icon:%s*"([^"]+)"') .. " " .. borderRight;
    end
  end

  --- Number of lines
  if foldStartLine:match('Line Count:%s*"([^"]+)"') == "false" then
    number = "";
  else
    if border == " " then
      number = tostring((vim.v.foldend - vim.v.foldstart) + 1) .. " Lines ";
    else
      number = borderLeft .. " " .. tostring((vim.v.foldend - vim.v.foldstart) + 1) .. " Lines " .. borderRight;
    end
  end


  local totalVirtualColumns = vim.api.nvim_win_get_width(0) - vim.fn.getwininfo(vim.fn.win_getid())[1].textoff;
  local usefulText = vim.fn.strchars(string.rep(border, padding) .. icon .. string.rep(border, gap) .. title .. number .. border);
  local fillCharLen = totalVirtualColumns - usefulText

  local _out = string.rep(border, padding) .. icon .. string.rep(border, gap) .. title .. string.rep(border, fillCharLen) .. number .. border;

  return _out;
end
---_

vim.o.foldtext = "v:lua.FoldText()"

-- }}}

-- Title: "WhichKey maps" {{{


-- Define all `<Space>` prefixed keymaps with which-key.nvim
-- https://github.com/folke/which-key.nvim
cmd 'packadd which-key.nvim'
cmd 'packadd! gitsigns.nvim' -- needed for some mappings
local wk = require 'which-key'
wk.setup { plugins = { spelling = { enabled = true } } }

wk.add(
  {
    { ",g", group = "Git" },
    { ",gs", "<Cmd>Git<CR>", desc = "Status" },
    { ",gb", "<Cmd>Git blame<CR>", desc = "Blame" },
    { ",gd", group = "Diff" },
    { ",gds", "<Cmd>Gdiffsplit<CR>", desc = "Split horizontal" },
    { ",gdv", "<Cmd>Gvdiffsplit<CR>", desc = "Split vertical" },
    { ",gh", group = "Hunks" },
    { ",ghs", require'gitsigns'.stage_hunk      , desc = "Stage" },
    { ",ghu", require'gitsigns'.undo_stage_hunk , desc = "Undo stage" },
    { ",ghr", require'gitsigns'.reset_hunk      , desc = "Reset" },
    { ",ghn", require'gitsigns'.next_hunk       , desc = "Go to next" },
    { ",ghN", require'gitsigns'.prev_hunk       , desc = "Go to prev" },
    { ",ghp", require'gitsigns'.preview_hunk    , desc = "Preview" },

    { ",gl", group = "Lists" },
    { ",glC", "<Cmd>Telescope git_commits<CR>", desc = "Buffer commits" },
    { ",glb", "<Cmd>Telescope git_branches<CR>", desc = "Branches" },
    { ",glc", "<Cmd>Telescope git_commits<CR>", desc = "Commits" },
    { ",gls", "<Cmd>Telescope git_status<CR>", desc = "Status" },

    { ",l", group = "LSP" },
    { ",lh", vim.lsp.buf.hover          , desc = "Hover" },
    { ",ld", vim.lsp.buf.definition     , desc = "Jump to definition" },
    { ",lD", vim.lsp.buf.declaration    , desc = "Jump to declaration" },
    { ",lca",vim.lsp.buf.code_action    , desc = "Code action" },
    { ",lcl",vim.lsp.codelens.run       , desc = "Code lens" },
    { ",lf", vim.lsp.buf.format         , desc = "Format" },
    { ",lr", vim.lsp.buf.rename         , desc = "Rename" },
    { ",lt", vim.lsp.buf.type_definition, desc = "Jump to type definition" },
    { ",ln", function() vim.diagnostic.goto_next({float = false}) end, desc = "Jump to next diagnostic" },
    { ",lN", function() vim.diagnostic.goto_prev({float = false}) end, desc = "Jump to prev diagnostic" },

    { ",ll", group = "Lists" },
    { ",llA", "<Cmd>Telescope lsp_range_code_actions<CR>", desc = "Code actions (range)" },
    { ",llS", "<Cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
    { ",lla", "<Cmd>Telescope lsp_code_actions<CR>", desc = "Code actions" },
    { ",llr", "<Cmd>Telescope lsp_references<CR>", desc = "References" },
    { ",lls", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Documents symbols" },

    { ",n", group = "Neorg" },
    { ",nb", "<Cmd>Telescope neorg find_backlinks<CR>", desc = "Find backlinks to file" },
    { ",nh", "<Cmd>Telescope neorg search_headings<CR>", desc = "Find headings in buffer" },
    { ",ni", "<Cmd>Telescope neorg insert_file_link<CR>", desc = "Insert link" },
    { ",nl", "<Cmd>Telescope neorg find_linkable<CR>", desc = "Find link" },
    { ",nm", "<Cmd>Telescope neorg find_header_backlinks<CR>", desc = "Find all links to header" },

    { ",s", group = "Search" },
    { ",s?", "<Cmd>Telescope help_tags<CR>", desc = "Vim help" },
    { ",sF", "<Cmd>Telescope find_files<CR>", desc = "Files in cwd" },
    { ",sG", "<Cmd>Telescope live_grep<CR>", desc = "Grep in cwd" },
    { ",sW", "<Cmd>Telescope grep_string<CR>", desc = "Grep word in cwd" },
    { ",sb", "<Cmd>Telescope file_browser<CR>", desc = "File Browser" },
    { ",sf", "<Cmd>Telescope find_files_workspace<CR>", desc = "Files in workspace" },
    { ",sg", "<Cmd>Telescope live_grep_workspace<CR>", desc = "Grep in workspace" },
    { ",sl", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer lines" },
    { ",so", "<Cmd>Telescope oldfiles<CR>", desc = "Old files" },
    { ",ss", "<Cmd>Telescope spell_suggest<CR>", desc = "Spell suggest" },
    { ",st", "<Cmd>Telescope builtin<CR>", desc = "Telescope lists" },

    { ",sv", group = "Vim" },
    { ",svC", "<Cmd>Telescope command_history<CR>", desc = "Command history" },
    { ",sva", "<Cmd>Telescope autocommands<CR>", desc = "Autocommands" },
    { ",svb", "<Cmd>Telescope buffers<CR>", desc = "Buffers" },
    { ",svc", "<Cmd>Telescope commands<CR>", desc = "Commands" },
    { ",svh", "<Cmd>Telescope highlights<CR>", desc = "Highlights" },
    { ",svl", "<Cmd>Telescope loclist<CR>", desc = "Location list" },
    { ",svm", "<Cmd>Telescope keymaps<CR>", desc = "Keymaps" },
    { ",svo", "<Cmd>Telescope vim_options<CR>", desc = "Options" },
    { ",svq", "<Cmd>Telescope quickfix<CR>", desc = "Quickfix list" },
    { ",svr", "<Cmd>Telescope registers<CR>", desc = "Registers" },
    { ",svt", "<Cmd>Telescope filetypes<CR>", desc = "Filetypes" },
    { ",sw", "<Cmd>Telescope grep_string_workspace<CR>", desc = "Grep word in workspace" },

    { ",w", group = "Windows" },
    { ",w+", "<Cmd>resize +5<CR>", desc = "Increase height" },
    { ",w-", "<Cmd>resize -5<CR>", desc = "Decrease height" },
    { ",w<", "<Cmd><C-w>5<<CR>", desc = "Decrease width" },
    { ",w=", "<Cmd>wincmd =<CR>", desc = "All equal size" },
    { ",w>", "<Cmd><C-w>5><CR>", desc = "Increase width" },
    { ",wo", "<Cmd>only<CR>", desc = "Close all other" },
    { ",wq", "<Cmd>q<CR>", desc = "Close" },
    { ",ws", "<Cmd>split<CR>", desc = "Split below" },
    { ",wv", "<Cmd>vsplit<CR>", desc = "Split right" },
    { ",w|", "<Cmd>vertical resize 106<CR>", desc = "Full line-lenght" },

    { ",y", group = "Yank" },
    { ",yy", '"+yy', desc = "Yank current line to system clipboard" },
  }
)
--}}}

-- Title: "Autocmds" {{{
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
  autocmd BufEnter,BufNewFile *.norg setlocal spell | set filetype=norg
augroup END

]]
---}}}
