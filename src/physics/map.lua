
local StaticBody = require "physics.static_body"
local DynamicBody = require "physics.dynamic_body"
local Cell = require "physics.cell"
local Matrix = require "basic.matrix"

local map = {}

function map:__index (k)
  if not k == "new" then
    return getmetatable(self)[k]
  end
end

function map.new (w, h)
  local m = {}
  setmetatable(m, map)

  m.grid = Matrix:new { w, h, Cell.new() }
  return m
end

function map:get_grid ()
  return self.grid
end

function map:occupy (pos, size, body)
  local grid = self:get_grid()
  for i = pos.y, pos.y + size.y do
    for j = pos.x, pos.x + size.x do
      local cell = grid:get_cell(i, j)
      cell:add_item(body)
    end
  end
end

function map:unnocupy (pos, size, body)
  local grid = self:get_grid()
  for i = pos.y, pos.y + size.y do
    for j = pos.x, pos.x + size.x do
      local cell = grid:get_cell(i, j)
      cell:remove_item(body)
    end
  end
end

function map:is_occupied (pos, size)
  local grid = self:get_grid()
  for i = pos.y, pos.y + size.y do
    for j = pos.x, pos.x + size.x do
      local cell = grid:get_cell(i, j)
      local list = cell:get_list()
      if #list > 0 then
        return list
      end
    end
  end
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
