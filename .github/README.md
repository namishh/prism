<div align="center">
  <img src="prism.png" alt="logo">
  <h1> prism </h1>
  <p> easy and fast way to use custom made colorschemes </p>
</div>

## Install

- lazy.nvim

```lua
{
    "chadcat7/prism",
    events = {"UIEnter", "Colorscheme"},
}
```
## Configuration

```lua
require("prism"):setup({
  colors = {
    comment = "#6c7086",
    background = "#11111b",
    black = "#11111b", -- this is used for text when background is transparent
    darker = "#0d0d15",
    foreground = "#f5e0dc",
    cursorline = "#161623",
    cursor = "#b5bfe2",
    color0 = "#292c35",
    color1 = "#d05759",
    color2 = "#5fbf70",
    color3 = "#e0875f",
    color4 = "#6481d0",
    color5 = "#c669cc",
    color6 = "#61aca2",
    color7 = "#b5bfe2",
    color8 = "#373941",
    color9 = "#e56e70",
    color10 = "#7fd98f",
    color11 = "#efa17f",
    color12 = "#7c98e4",
    color13 = "#d476da",
    color14 = "#70b6ac",
    color15 = "#83889a",
  },
  -- colors = "onedarker", -- you can also use one of the many preinstalled colorschemes
  customFiles = vim.fn.stdpath "config" .. "/lua/hls/",
  transparent = false
})
```

- For using custom highlights, make files in the `customFiles` folder. For example

```lua
-- .config/nvim/lua/hls/alpha.lua
-- you can name the file however you want, because all the files in lua/hls would be read 

local utils = require("prism.utils")
local colors = require("prism.themer"):getColors()

return {
  AlphaHeader = { fg = colors.color4, bg = colors.background },
  AlphaLabel = { fg = colors.color7, bg = colors.background },
  AlphaIcon = { fg = colors.color5, bold = true, },
  AlphaKeyPrefix = { fg = colors.color1, bg = utils.darken(colors.color1, colors.black, 0.04) },
  AlphaMessage = { fg = colors.color2, bg = colors.background },
  AlphaFooter = { fg = colors.comment, bg = colors.background },
}
```

## Utils

For even more options for coloring, a bunch of methods have been provided in `prism.utils`.

- `M.darken(hex, bg, amount)`
- `M.lighten(hex, fg, amount)`
- `M.mix(hex1, hex2, weight)`
- `M.saturate(hex1, factor)`
- `M.moreRed(hex1, factor)`
- `M.moreGreen(hex1, factor)`
- `M.moreBlue(hex1, factor)`
- `M.warm(hex1, factor)`
- `M.cold(hex1, factor)`

## Supported Plugins

- [lualine](https://github.com/nvim-lualine/lualine.nvim)
- [bufferline](https://github.com/akinsho/bufferline.nvim)
- [barbecue](https://github.com/utilyre/barbecue.nvim)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- [nvim-tree](https://github.com/kyazdani42/nvim-tree.lua)
- [telescope](https://github.com/nvim-telescope/telescope.nvim)
- [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [whichkey](https://github.com/folke/which-key.nvim)
- [devicons](https://github.com/rcarriga/nvim-notify)
- [harpoon](https://github.com/ThePrimeagen/harpoon)
- [hop](https://github.com/phaazon/hop.nvim)
- [notify](https://github.com/rcarriga/nvim-notify)

### Todo

- [x] Custom highlights
- [x] Transparency
- [x] Documentation
- [x] Some default themes
- [x] More color related functions
