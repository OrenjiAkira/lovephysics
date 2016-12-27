
local vector = require 'basic.vector'

local rect = require 'basic.prototype' :new {
  0, 0, 0, 0,
  __type = 'rectangle'
}

function rect:__init ()
  self.pos = vector:new { self[1], self[2] }
  self.size = vector:new { self[3], self[4] }
end

function rect:set_pos (x, y)
  self.pos:set(x, y)
end

function rect:get_pos ()
  return self.pos * 1
end

function rect:set_size (w, h)
  self.size:set(x, y)
end

function rect:get_size ()
  return self.size * 1
end

function rect:intersect (r)
  local a_topleft = self:get_pos()
  local a_bottomright = self:get_pos() + self:get_size()
  local b_topleft = r:get_pos()
  local b_bottomright = r:get_pos() + r:get_size()
  local intersect = true
  if a_topleft.x > b_bottomright.x then
    intersect = false
  elseif a_topleft.y > b_bottomright.y then
    intersect = false
  elseif b_topleft.x > a_bottomright.x then
    intersect = false
  elseif b_topleft.y > a_bottomright.y then
    intersect = false
  end
  return intersect
end

function rect:get_border_points ()
  local points = {}
  local pos, size = self:get_pos(), self:get_size()

  for dy = 0, math.floor(size.y) do
    table.insert(points, vector:new { pos.x,          pos.y + dy })
    table.insert(points, vector:new { pos.x + size.x, pos.y + dy })
  end

  for dx = 0, math.floor(size.x) do
    table.insert(points, vector:new { pos.x + dx, pos.y })
    table.insert(points, vector:new { pos.x + dx, pos.y + size.y })
  end

  return points
end

return rect
