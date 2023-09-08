local cmd = vim.api.nvim_create_user_command
local themer = require("prism.themer")

local has_value = function(tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end
  return false
end

cmd(
  'PrismSet',
  function(opts)
    themer:set(opts.args)
  end,
  { nargs = 1 }
)

cmd(
  'PrismRandom',
  function(opts)
    themer:random()
  end,
  { nargs = 0 }
)

cmd(
  'PrismTelescope',
  function(opts)
    require("prism.picker").open()
  end,
  { nargs = 0 }
)
