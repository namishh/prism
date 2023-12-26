local M              = {}
local prismPath      = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
vim.g.themeCache     = vim.fn.stdpath "data" .. "/prism/"
vim.g.themeTempCache = vim.fn.stdpath "data" .. "/prism_temp/"
local hl_files       = prismPath .. "/highlights"
local schemefiles    = prismPath .. "/schemes"

M.colors             = {}
M.modules            = {}
M.themes             = {}
M.transparent        = false

local function indexOf(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

function M:gendef()
  for _, file in ipairs(vim.fn.readdir(schemefiles)) do
    local filename = vim.fn.fnamemodify(file, ":r")
    local a = require("prism.schemes." .. filename)
    table.insert(self.themes, a)
  end
end

function M:genCustom()
    for _, t in ipairs(self.customSchemes) do
    for _, i in ipairs(self.themes) do
      if i.name == t.name then
        table.remove(self.themes, indexOf(self.themes, i))
        break
      end
    end
    table.insert(self.themes, t)
  end
  vim.g.prismThemes = self.themes
end

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

function M:toCache(filename, tb, path)
  local lines = "return string.dump(function()" .. self:tableToStr(tb) .. "end, true)"
  local file = io.open(path .. filename, "wb")

  if file then
    ---@diagnostic disable-next-line: deprecated
    file:write(loadstring(lines)())
    file:close()
  end
end

function M:compile(path)
  if not vim.loop.fs_stat(path) then
    vim.fn.mkdir(path, "p")
  end

  local allThemes = {}

  for _, file in ipairs(vim.fn.readdir(hl_files)) do
    local filename = vim.fn.fnamemodify(file, ":r")
    local a = M:loadTb(filename)
    for k, f in pairs(a) do
      allThemes[k] = f
    end
  end
  if M.customFiles ~= "" then
    for _, file in ipairs(vim.fn.readdir(M.customFiles)) do
      local filename = vim.fn.fnamemodify(file, ":r")
      local a = M:loadLocalTb(filename)
      for k, f in pairs(a) do
        for _, i in pairs(allThemes) do
          if i == f then
            table.remove(allThemes, indexOf(allThemes, i))
            break
          end
        end
        allThemes[k] = f
      end
    end
  end

  self:toCache("allThemes", allThemes, path)
end

function M:setTermCols(colors)
  vim.g.terminal_color_0 = colors.color0
  vim.g.terminal_color_1 = colors.color1
  vim.g.terminal_color_2 = colors.color2
  vim.g.terminal_color_3 = colors.color3
  vim.g.terminal_color_4 = colors.color4
  vim.g.terminal_color_5 = colors.color5
  vim.g.terminal_color_6 = colors.color6
  vim.g.terminal_color_7 = colors.color7
  vim.g.terminal_color_8 = colors.color8
  vim.g.terminal_color_9 = colors.color9
  vim.g.terminal_color_10 = colors.color10
  vim.g.terminal_color_11 = colors.color11
  vim.g.terminal_color_12 = colors.color12
  vim.g.terminal_color_13 = colors.color13
  vim.g.terminal_color_14 = colors.color14
  vim.g.terminal_color_15 = colors.color15
end

function M:load(path)
  M:compile(path)
  dofile(path .. "allThemes")
end

function M:loadColsOnly()
  dofile(vim.g.themeCache .. "allThemes")
end

function M:reloadModule(name)
  require("plenary.reload").reload_module(name)
end

function M:reloadAllModules()
  for _, mod in ipairs(self.modules) do
    self:reloadModule(mod)
  end
end

vim.api.nvim_create_autocmd({ "CursorHold" }, {
  callback = function()
    M:gendef()
    M:genCustom()
    M:setCmds()
  end
})

function M:setup(opts)
  opts = opts or {}
  self.customSchemes = opts.customSchemes or {}
  local currentTheme = opts.currentTheme or "cat"
  local reset = false
  if opts.reset == true then
    reset = true
  end
  local mods = opts.reload or {}
  for _, t in ipairs(mods) do
    table.insert(self.modules, t)
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
  M.customFiles = opts.customFiles or ""
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
  M.customFilesPath = n or ""
  if reset then
    M:load(vim.g.themeCache)
  else
    if vim.fn.isdirectory(vim.g.themeCache) ~= 1 then
      M:load(vim.g.themeCache)
    else
      M:loadColsOnly()
    end
  end
end

function M:set(name)
  self:reloadModule("prism.highlights")
  if M.customFiles ~= "" then
    self:reloadModule("" .. self.customFilesPath)
  end
  self:reloadAllModules()
  local theme
  for _, i in ipairs(self.themes) do
    if i.name == name then
      theme = i
      break
    end
  end
  self.colors = theme
  M:setTermCols(theme)
  M:load(vim.g.themeCache)
end

function M:setTemp(name)
  self:reloadModule("prism.highlights")
  if M.customFiles ~= "" then
    self:reloadModule("" .. self.customFilesPath)
  end
  self:reloadAllModules()
  local theme
  for _, i in ipairs(self.themes) do
    if i.name == name then
      theme = i
      break
    end
  end
  self.colors = theme
  M:setTermCols(theme)
  M:load(vim.g.themeTempCache)
end

function M:random()
  self:gendef()
  self:genCustom()
  local theme = self.themes[math.random(#self.themes)]
  self:set(theme.name)
end

local has_value = function(tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end
  return false
end

function M:openTelescope()
  self:gendef()
  self:genCustom()
  require("prism.picker").open(require("telescope.themes").get_dropdown {
    layout_config = {
      preview_cutoff = 1, -- Preview should always show (unless previewer = false)
      width = 69,
      height = 18,
    },
  }
  )
end

function M:setCmds()
  local available_themes = {}
  for _, val in ipairs(M.themes) do
    table.insert(available_themes, val.name)
  end
  table.sort(available_themes)
  local cmd = vim.api.nvim_create_user_command
  cmd(
    'PrismSet',
    function(opts)
      if has_value(available_themes, opts.args) then
        self:set(opts.args)
      else
        print 'Invalid Theme'
      end
    end,
    {
      nargs = 1,
      complete = function()
        return available_themes
      end,

    }
  )
  cmd(
    'PrismRandom',
    function()
      self:random()
    end,
    { nargs = 0 }
  )

  cmd(
    'PrismTelescope',
    function()
      self:openTelescope()
      self:setTemp(M.themes[1].name)
    end,
    { nargs = 0 }
  )
end

return M
