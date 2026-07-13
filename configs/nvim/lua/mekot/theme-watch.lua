-- Watches the state file `mekot-theme` writes (home/theme.nix) and flips vim.o.background +
-- reapplies the colorscheme on change, so `theme dark`/`light` from another shell applies live.
local M = {}

local function stateFile()
  local xdgState = vim.env.XDG_STATE_HOME
  if not xdgState or xdgState == '' then
    xdgState = vim.env.HOME .. '/.local/state'
  end
  return xdgState .. '/mekot/theme'
end

local function readMode(path)
  local f = io.open(path, 'r')
  if not f then return nil end
  local content = f:read('*l')
  f:close()
  if content == 'light' or content == 'dark' then return content end
  return nil
end

-- Mode from the state file, if any — read before the first colorscheme load to avoid a flash
-- of the wrong mode.
M.initial = function ()
  return readMode(stateFile())
end

M.watch = function ()
  local path = stateFile()
  local dir = vim.fn.fnamemodify(path, ':h')
  local file = vim.fn.fnamemodify(path, ':t')
  vim.fn.mkdir(dir, 'p')

  local handle = (vim.uv or vim.loop).new_fs_event()
  if not handle then return end

  handle:start(dir, {}, function (err, filename)
    if err or filename ~= file then return end
    vim.schedule(function ()
      local mode = readMode(path)
      if mode and mode ~= vim.o.background then
        vim.o.background = mode
        vim.cmd 'colorscheme mekot'
      end
    end)
  end)
end

return M
