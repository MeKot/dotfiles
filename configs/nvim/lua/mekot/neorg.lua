

local neorg = require "neorg"

neorg.setup {
  load = {
    ["core.defaults"] = {}, -- Loads default behaviour
    ["core.concealer"] = {}, -- Adds pretty icons to your documents
    ["core.ui.calendar"] = {}, -- Adds a calendar picker for the journal -- NEEDS V0.10
    ["core.dirman"] = { -- Manages Neorg workspaces
      config = {
        workspaces = {
          notes = "~/notes",
        },
        default_workspace="notes",
      },
    },
    ["core.autocommands"] = {},
    ["core.integrations.treesitter"] = {},
    ["core.integrations.telescope"] = {
      config = {
        insert_file_link = {
          show_title_preview = true,
        },
      }
    }
  }
}
