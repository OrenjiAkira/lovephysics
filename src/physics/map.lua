
local StaticBody = require "physics.static_body"
local DynamicBody = require "physics.dynamic_body"
local Matrix = require "basic.matrix"

local map = {}

function map:__index (k)
  if not k == "new" then
    return getmetatable(self)[k]
  end
end

function map.new (w, h, u)
  local w = {}
  setmetatable(w, map)

  m.unit = u
  m.grid = Matrix:new { w, h, 0 }
  return w
end

function map:draw ()
  for i, row in self.grid:iteraterows() do
    local s = "[ "
    for j = 1, #row do
      s = s .. row[j]
      s = s .. " "
    end
    s = s .. "]"
    print(s)
  end
end

return map
