local colors = require("prism.themer"):getColors()
local utils = require("prism.utils")

return {
  DiagnosticError = { fg = colors.color9, bg = utils.darken(colors.color9, colors.black, 0.15) },
  DiagnosticWarn = { fg = colors.color11, bg = utils.darken(colors.color11, colors.black, 0.15) },
  DiagnosticHint = { fg = colors.color6, bg = colors.black },
  DiagnosticInfo = { fg = colors.color4, bg = utils.darken(colors.color4, colors.black, 0.15) },

}
