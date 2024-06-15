-- Highlights used with statusline defined in `../../statusline.lua`.
local t = require'lush_theme.mekot'

---@diagnostic disable: undefined-global
return require'lush'(function()
  return {
    StatusLineMode    { bg = t.GreenBg.bg, fg = t.LightestToneFg.fg },
    StatusLineModeSep { bg = t.StatusLine.bg, fg = t.GreenFg.fg },

    StatusLineFileName { t.StatusLine, gui = 'italic' },

    StatusLineGitBranch    { t.StatusLine, gui = 'bold' },
    StatusLineDiffAdd      { bg = t.StatusLine.bg, fg = t.AddText.fg },
    StatusLineDiffModified { bg = t.StatusLine.bg, fg = t.ChangeText.fg },
    StatusLineDiffRemove   { bg = t.StatusLine.bg, fg = t.DeleteText.fg },

    StatusLineLspClient       { t.StatusLine },
    StatusLineDiagnosticError { bg = t.StatusLine.bg, fg = t.ErrorText.fg },
    StatusLineDiagnosticWarn  { bg = t.StatusLine.bg, fg = t.WarningText.fg },
    StatusLineDiagnosticInfo  { t.StatusLine },
    StatusLineDiagnosticHint  { StatusLineDiagnosticInfo },

    StatusLineLineInfo        { StatusLineMode },
    StatusLineLineInfoSep     { StatusLineModeSep },
    StatusLineFilePosition    { StatusLineMode },
    StatusLineFilePositionSep { StatusLineMode },

    StatusLineSortStatusLine { t.StatusLineNC },
  }
end)

