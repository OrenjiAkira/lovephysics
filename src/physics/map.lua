
local StaticBody = require "physics.static_body"
local DynamicBody = require "physics.dynamic_body"
local Cell = require "physics.cell"
local Matrix = require "basic.matrix"

local map = {}

local function set_drawable_debugger (m)
  m.drawable = {}
  m.drawable.sprbatch = love.graphics.newSpriteBatch( love.graphics.newImage("physics/squares.png"), m:get_width() * m:get_height())
  m.drawable.quads = {
    love.graphics.newQuad(0, 0, 1, 1, m.drawable.sprbatch:getTexture():getDimensions()),
    love.graphics.newQuad(1, 0, 1, 1, m.drawable.sprbatch:getTexture():getDimensions()),
  }
  local sprbatch, quads = m.drawable.sprbatch, m.drawable.quads
  for i, j in m.grid:iterate() do
    local id = 1
    if i % 2 == 0 then
      if j % 2 == 0 then
        id = 1
      else
        id = 2
      end
    else
      if j % 2 == 0 then
        id = 2
      else
        id = 1
      end
    end
    sprbatch:add(quads[id], (j - 1), (i - 1))
  end
end

function map:__index (k)
  if k ~= "new" then
    return getmetatable(self)[k]
  end
end

function map.new (w, h)
  local m = {}
  setmetatable(m, map)

  m.grid = Matrix:new { w, h, false }
  for i, j in m.grid:iterate() do
    m.grid:set_cell(i, j, Cell.new())
  end

  set_drawable_debugger(m)

  return m
end

function map:get_grid ()
  return self.grid
end

function map:occupy (pos, size, body)
  print("occupy")
  local grid = self:get_grid()
  for i = pos.y, pos.y + size.y - 1 do
    for j = pos.x, pos.x + size.x - 1 do
      local cell = grid:get_cell(i, j)
      if cell then
        cell:add_item(body)
      end
    end
  end
end

function map:unoccupy (pos, size, body)
  print("unoccupy")
  local grid = self:get_grid()
  for i = pos.y, pos.y + size.y - 1 do
    for j = pos.x, pos.x + size.x - 1 do
      local cell = grid:get_cell(i, j)
      if cell then
        cell:remove_item(body)
      end
    end
  end
end

function map:is_occupied (pos, size)
  local grid = self:get_grid()
  for i = pos.y, pos.y + size.y - 1 do
    for j = pos.x, pos.x + size.x - 1 do
      local cell = grid:get_cell(i, j)
      if cell then
        local list = cell:get_list()
        if #list > 0 then
          return list
        end
      end
    end
  end
end

function map:get_width ()
  return self:get_grid():get_width()
end

function map:get_height ()
  return self:get_grid():get_height()
end

function map:get_dimensions ()
  return self:get_width(), self:get_height()
end

function map:draw ()
  love.graphics.draw(self.drawable.sprbatch, 0, 0, 0, unit, unit)
end

return map
