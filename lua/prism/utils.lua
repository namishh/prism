local M = {}

local function hexToRgb(c)
  c = string.lower(c)
  return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

local function rgbToHsl(r, g, b)
  r, g, b = r / 255, g / 255, b / 255 -- Normalize RGB values to the range [0, 1]
  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local h, s, l
  l = (max + min) / 2
  if max == min then
    h = 0
    s = 0 -- Monochromatic
  else
    local d = max - min
    s = l > 0.5 and d / (2 - max - min) or d / (max + min)
    if max == r then
      h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
      h = (b - r) / d + 2
    else
      h = (r - g) / d + 4
    end
    h = h / 6
  end
  return h, s, l
end

local function hslToRgb(h, s, l)
  if s == 0 then
    return l, l, l -- Achromatic (gray)
  end

  h = (h % 1 + 1) % 1             -- Ensure h is in the range [0, 1]
  s = math.min(1, math.max(0, s)) -- Clamp s to [0, 1]
  l = math.min(1, math.max(0, l)) -- Clamp l to [0, 1]

  local function hueToRgb(p, q, t)
    if t < 0 then t = t + 1 end
    if t > 1 then t = t - 1 end
    if t < 1 / 6 then return p + (q - p) * 6 * t end
    if t < 1 / 2 then return q end
    if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
    return p
  end

  local q = l < 0.5 and l * (1 + s) or l + s - l * s
  local p = 2 * l - q
  local r = hueToRgb(p, q, h + 1 / 3)
  local g = hueToRgb(p, q, h)
  local b = hueToRgb(p, q, h - 1 / 3)

  return r, g, b
end

M.blend    = function(foreground, background, alpha)
  alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
  local bg = hexToRgb(background)
  local fg = hexToRgb(foreground)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02x%02x%02x", blendChannel(1), blendChannel(2), blendChannel(3))
end

M.darken   = function(hex, bg, amount)
  return M.blend(hex, bg, amount)
end

M.lighten  = function(hex, fg, amount)
  return M.blend(hex, fg, amount)
end

M.mix      = function(c1, c2, wt)
  local r1 = tonumber(string.sub(c1, 2, 3), 16)
  local g1 = tonumber(string.sub(c1, 4, 5), 16)
  local b1 = tonumber(string.sub(c1, 6, 7), 16)

  local r2 = tonumber(string.sub(c2, 2, 3), 16)
  local g2 = tonumber(string.sub(c2, 4, 5), 16)
  local b2 = tonumber(string.sub(c2, 6, 7), 16)

  wt = math.min(1, math.max(0, wt))

  local nr = math.floor((1 - wt) * r1 + wt * r2)
  local ng = math.floor((1 - wt) * g1 + wt * g2)
  local nb = math.floor((1 - wt) * b1 + wt * b2)

  return string.format("#%02X%02X%02X", nr, ng, nb)
end

M.saturate = function(c, factor)
  local r = tonumber(string.sub(c, 2, 3), 16)
  local g = tonumber(string.sub(c, 4, 5), 16)
  local b = tonumber(string.sub(c, 6, 7), 16)
  local h, s, l = rgbToHsl(r, g, b)
  s = s + factor

  s = math.min(1, math.max(0, s))

  r, g, b = hslToRgb(h, s, l)
  local newHexColor = string.format("#%02X%02X%02X", r * 255, g * 255, b * 255)

  return newHexColor
end

M.moreRed  = function(c, f)
  local r = tonumber(string.sub(c, 2, 3), 16)
  local g = tonumber(string.sub(c, 4, 5), 16)
  local b = tonumber(string.sub(c, 6, 7), 16)
  r = r + f
  r = math.min(255, math.max(0, r))
  return string.format("#%02X%02X%02X", r, g, b)
end


M.moreGreen = function(c, f)
  local r = tonumber(string.sub(c, 2, 3), 16)
  local g = tonumber(string.sub(c, 4, 5), 16)
  local b = tonumber(string.sub(c, 6, 7), 16)
  g = g + f
  g = math.min(255, math.max(0, g))
  return string.format("#%02X%02X%02X", r, g, b)
end


M.moreBlue = function(c, f)
  local r = tonumber(string.sub(c, 2, 3), 16)
  local g = tonumber(string.sub(c, 4, 5), 16)
  local b = tonumber(string.sub(c, 6, 7), 16)
  b = b + f
  b = math.min(255, math.max(0, b))
  return string.format("#%02X%02X%02X", r, g, b)
end

M.cold = function(c, f)
  return M.moreBlue(c, f)
end

M.warm = function(c, f)
  local r = tonumber(string.sub(c, 2, 3), 16)
  local g = tonumber(string.sub(c, 4, 5), 16)
  local b = tonumber(string.sub(c, 6, 7), 16)
  r = r + f
  g = g + f
  r = math.min(255, math.max(0, r))
  g = math.min(255, math.max(0, g))
  return string.format("#%02X%02X%02X", r, g, b)
end

return M
