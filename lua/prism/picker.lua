local pickers      = require "telescope.pickers"
local finders      = require "telescope.finders"
local actions      = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf         = require("telescope.config").values
local themes       = require("prism.themer")
local M            = {}

local schemes      = {}
for _, file in ipairs(themes.themes) do
  table.insert(schemes, file.name)
end

table.sort(schemes)


M.open = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Change The Spectrum",
    finder = finders.new_table {
      results = schemes
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(buffer)
      actions.select_default:replace(function()
        local theme = action_state.get_selected_entry().value
        themes:set(theme)
        actions.close(buffer)
      end)
      return true
    end,
  }):find()
end

return M
