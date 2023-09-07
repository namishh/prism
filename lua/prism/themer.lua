local M          = {}
local prismPath  = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
vim.g.themeCache = vim.fn.stdpath "data" .. "/prism/"
local hl_files   = prismPath .. "/highlights"
-- default colors
M.colors         = require("prism.schemes.onedarker")
M.transparent    = false
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

function M:load()
  M:compile()
  for _, file in ipairs(vim.fn.readdir(vim.g.themeCache)) do
    dofile(vim.g.themeCache .. file)
  end
end

function M:setup(opts)
  opts = opts or {}
  if type(opts.colors) == "string" then
    self.colors = require("prism.schemes." .. opts.colors)
  else
    self.colors = opts.colors or self:getColors()
  end
  M.transparent = opts.transparent or M.transparent
  M.customFiles = opts.customFiles or vim.fn.stdpath "config" .. "/lua/hls"
  M.customFilesPath = opts.customFilesPath or "hls"

  M:load()
end

return M
