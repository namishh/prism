local colors = require("prism.themer"):getColors()

return {
  NotifyERRORBorder = { fg = colors.red },
  NotifyERRORIcon = { fg = colors.red },
  NotifyERRORTitle = { fg = colors.red, italic = true },
  NotifyWARNBorder = { fg = colors.yellow },
  NotifyWARNIcon = { fg = colors.yellow },
  NotifyWARNTitle = { fg = colors.yellow, italic = true },
  NotifyINFOBorder = { fg = colors.color4 },
  NotifyINFOIcon = { fg = colors.color4 },
  NotifyINFOTitle = { fg = colors.color4, italic = true },
  NotifyDEBUGBorder = { fg = colors.color9 },
  NotifyDEBUGIcon = { fg = colors.color9 },
  NotifyDEBUGTitle = { fg = colors.color9, italic = true },
  NotifyTRACEBorder = { fg = colors.foreground },
  NotifyTRACEIcon = { fg = colors.foreground },
  NotifyTRACETitle = { fg = colors.foreground, italic = true },
}
