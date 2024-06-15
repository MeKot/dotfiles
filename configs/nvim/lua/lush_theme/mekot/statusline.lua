-- Highlights used with statusline defined in `../../statusline.lua`.
local t = require'lush_theme.mekot'

---@diagnostic disable: undefined-global
return require'lush'(function()
  return {
    StatusLineMode    { bg = t.GreenBg.bg, fg = t.MagentaFg.fg },
    StatusLineModeSep { bg = t.StatusLine.bg, fg = t.GreenFg.fg },

    StatusLineFileName { t.DarkGreenBg, fg = t.MainFg.fg, gui = 'italic' },

    StatusLineGitBranch             { t.StatusLine, gui = 'bold' },
    StatusLineGitBranchSeparator    { t.StatusLine, fg = t.StatusLine.bg },
    StatusLineDiffAdd               { bg = t.StatusLine.bg, fg = t.AddText.fg },
    StatusLineDiffModified          { bg = t.StatusLine.bg, fg = t.ChangeText.fg },
    StatusLineDiffRemove            { bg = t.StatusLine.bg, fg = t.DeleteText.fg },

    StatusLineFileNameSeparator { StatusLineFileName, fg = StatusLineGitBranch.bg },

    StatusLineDiagnosticError { bg = t.StatusLine.bg, fg = t.ErrorText.fg },
    StatusLineDiagnosticWarn  { bg = t.StatusLine.bg, fg = t.WarningText.fg },
    StatusLineDiagnosticInfo  { t.StatusLine },
    StatusLineDiagnosticHint  { StatusLineDiagnosticInfo },

    StatusLineLspClient          { StatusLineMode, gui = 'italic' },
    StatusLineLspClientSeparator { StatusLineModeSep },
  }
end)

