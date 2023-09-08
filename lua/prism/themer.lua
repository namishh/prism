local M           = {}
local prismPath   = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
vim.g.themeCache  = vim.fn.stdpath "data" .. "/prism/"
local hl_files    = prismPath .. "/highlights"
local schemefiles = prismPath .. "/schemes"
-- default colors
M.colors          = {}

M.themes          = {}

function M:gendef()
  for _, file in ipairs(vim.fn.readdir(schemefiles)) do
    local filename = vim.fn.fnamemodify(file, ":r")
    local a = require("prism.schemes." .. filename)
    table.insert(self.themes, a)
  end
end

M.transparent = false
function M:mergeTb(...)
  return vim.tbl_deep_extend("force", ...)
end

function M:loadLocalTb(g)
  g = require(M.customFilesPath .. "." .. g)
  return g
end

function M:loadTb(g)
  g = require("prism.highlights." .. g)
  return g
end

function M:tableToStr(tb)
  local result = ""

  for hlgroupName, hlgroup_vals in pairs(tb) do
    local hlname = "'" .. hlgroupName .. "',"
    local opts = ""

    for optName, optVal in pairs(hlgroup_vals) do
      local valueInStr = ((type(optVal)) == "boolean" or type(optVal) == "number") and tostring(optVal)
          or '"' .. optVal .. '"'
      opts = opts .. optName .. "=" .. valueInStr .. ","
    end

    result = result .. "vim.api.nvim_set_hl(0," .. hlname .. "{" .. opts .. "})"
  end

  return result
end

function M:getColors()
  if M.transparent then
    self.colors.background = "NONE"
  end
  return self.colors
end

function M:toCache(filename, tb)
  local lines = "return string.dump(function()" .. self:tableToStr(tb) .. "end, true)"
  local file = io.open(vim.g.themeCache .. filename, "wb")

  if file then
    ---@diagnostic disable-next-line: deprecated
    file:write(loadstring(lines)())
    file:close()
  end
end

function M:compile()
  if not vim.loop.fs_stat(vim.g.themeCache) then
    vim.fn.mkdir(vim.g.themeCache, "p")
  end

  for _, file in ipairs(vim.fn.readdir(hl_files)) do
    local filename = vim.fn.fnamemodify(file, ":r")
    M:toCache(filename, M:loadTb(filename))
  end


  for _, file in ipairs(vim.fn.readdir(M.customFiles)) do
    local filename = vim.fn.fnamemodify(file, ":r")
    M:toCache(filename, M:loadLocalTb(filename))
  end
end

function M:setTermCols()
  vim.g.terminal_color_0 = self.colors.color0
  vim.g.terminal_color_1 = self.colors.color1
  vim.g.terminal_color_2 = self.colors.color2
  vim.g.terminal_color_3 = self.colors.color3
  vim.g.terminal_color_4 = self.colors.color4
  vim.g.terminal_color_5 = self.colors.color5
  vim.g.terminal_color_6 = self.colors.color6
  vim.g.terminal_color_7 = self.colors.color7
  vim.g.terminal_color_8 = self.colors.color8
  vim.g.terminal_color_9 = self.colors.color9
  vim.g.terminal_color_10 = self.colors.color10
  vim.g.terminal_color_11 = self.colors.color11
  vim.g.terminal_color_12 = self.colors.color12
  vim.g.terminal_color_13 = self.colors.color13
  vim.g.terminal_color_14 = self.colors.color14
  vim.g.terminal_color_15 = self.colors.color15
end

function M:load()
  M:compile()
  for _, file in ipairs(vim.fn.readdir(vim.g.themeCache)) do
    dofile(vim.g.themeCache .. file)
  end
  M:setTermCols()
end

local function indexOf(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

function M:setup(opts)
  self:gendef()
  opts = opts or {}
  local customSchemes = opts.customSchemes or {}
  local currentTheme = opts.currentTheme or "cat"
  for _, t in ipairs(customSchemes) do
    for _, i in ipairs(self.themes) do
      if i.name == t.name then
        table.remove(self.themes, indexOf(self.themes, i))
        break
      end
    end
    table.insert(self.themes, t)
  end
  local curr = {}
  for _, t in ipairs(self.themes) do
    if t.name == currentTheme then
      curr = t
      break
    end
  end
  self.colors = curr
  M.transparent = opts.transparent or M.transparent
  M.customFiles = opts.customFiles or vim.fn.stdpath "config" .. "/lua/hls"
  local function mysplit(inputstr, sep)
    if sep == nil then
      sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
      table.insert(t, str)
    end
    return t
  end

  local a = tostring(M.customFiles):gsub(tostring(vim.fn.stdpath "config" .. "/lua/"), "")
  local f = mysplit(a, "/")
  local n = table.concat(f, ".")
  M.customFilesPath = n or "hls"

  M:load()
end

return M
