local colors = require("prism.themer"):getColors()
local utils = require("prism.utils")

return {

  BufferLineBackground = {
    fg = colors.comment,
    bg = colors.cursorline,
  },

  BufferlineIndicatorVisible = {
    fg = colors.cursorline,
    bg = colors.cursorline,
  },

  BufferLineBufferSelected = {
    fg = colors.foreground,
    bg = colors.black,
  },

  BufferLineBufferVisible = {
    fg = colors.foreground,
    bg = colors.background,
  },

  BufferLineError = {
    fg = colors.color9,
    bg = colors.cursorline,
  },
  BufferLineErrorDiagnostic = {
    fg = colors.color4,
    bg = colors.cursorline,
  },

  BufferLineCloseButton = {
    fg = colors.background,
    bg = colors.cursorline,
  },
  BufferLineCloseButtonVisible = {
    fg = colors.color9,
    bg = colors.cursorline,
  },
  BufferLineCloseButtonSelected = {
    fg = colors.color9,
    bg = colors.black,
  },
  BufferLineFill = {
    fg = colors.cursorline,
    bg = colors.cursorline,
  },
  BufferlineIndicatorSelected = {
    fg = colors.black,
    bg = colors.black,
  },

  BufferLineModified = {
    fg = colors.color2,
    bg = colors.cursorline,
  },
  BufferLineModifiedVisible = {
    fg = colors.color9,
    bg = colors.cursorline,
  },
  BufferLineModifiedSelected = {
    fg = colors.color2,
    bg = colors.black,
  },

  BufferLineSeparator = {
    fg = colors.cursorline,
    bg = colors.cursorline,
  },
  BufferLineSeparatorVisible = {
    fg = colors.cursorline,
    bg = colors.cursorline,
  },
  BufferLineSeparatorSelected = {
    fg = colors.cursorline,
    bg = colors.cursorline,
  },

  BufferLineTabSelected = {
    fg = colors.black,
    bg = colors.color4,
  },
  BufferLineTabClose = {
    fg = colors.color9,
    bg = colors.black,
  },

  BufferLineDevIconDefaultSelected = {
    bg = "none",
  },

  BufferLineDevIconDefaultInactive = {
    bg = "none",
  },

  BufferLineDuplicate = {
    fg = "NONE",
    bg = colors.cursorline,
  },
  BufferLineDuplicateSelected = {
    fg = colors.color9,
    bg = colors.black,
  },
  BufferLineDuplicateVisible = {
    fg = colors.color12,
    bg = colors.cursorline,
  },

}
