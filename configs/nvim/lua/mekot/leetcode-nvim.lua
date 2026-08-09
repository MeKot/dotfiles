-- leetcode.nvim
-- Solve LeetCode problems within Neovim
-- https://github.com/kawre/leetcode.nvim

-- leetcode.nvim's mkdir isn't recursive, and stdpath("cache") may not exist yet
vim.fn.mkdir(vim.fn.stdpath("cache") .. "/leetcode", "p")

require 'leetcode'.setup {
  picker = { provider = "telescope" },
}
