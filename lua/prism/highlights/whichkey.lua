local colors = require("prism.themer"):getColors()

return {
  WhichKey = { fg = colors.color4 },
  WhichKeySeparator = { fg = colors.color8 },
  WhichKeyDesc = { fg = colors.color1 },
  WhichKeyGroup = { fg = colors.color3 },
  WhichKeyValue = { fg = colors.color5 },
  WhichKeyFloat = { bg = colors.darker },
}
