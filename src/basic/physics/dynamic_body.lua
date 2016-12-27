
local vector = require 'basic.vector'

local dynamic_body = require 'basic.physics.collision_object' :new {
  0, 0, 0, 0,
  __type = 'dynamic_body',
}

function dynamic_body:__init ()
  self.shape = require 'basic.rectangle' :new {
    self[1], self[2], self[3], self[4]
  }
  self.pos = self.shape.pos -- i want the pointer to be the same
  self.movement = require 'basic.vector' :new {}
end

function dynamic_body:get_shape ()
  return self.shape
end

function dynamic_body:move (v)
  self.movement:add(v)
end

function dynamic_body:get_movement ()
  return self.movement * 1
end

function dynamic_body:resolve_movement ()
  -- if no movement, return
  if self.movement:sqrlen() == 0 then return end

  -- if no map, error
  local map = self:get_map()
  assert(map, "Body's map is undefined. Create a map and set the body to it first.")

  -- get points, check points
  local points = self.shape:get_border_points()
  local moveable = true
  for n = 1, #points do
    local point = points[n]
    local x, y = math.floor(point.x), math.floor(point.y)
    if map:is_occupied(x, y) then
      moveable = false
    end
  end

  -- if nothing is in the way, move
  if moveable then
    self:move_pos(self.movement)
  end
  self.movement:set()
end

function dynamic_body:intersects_with (body)
  return self:get_shape():intersect(body:get_shape())
end

function dynamic_body:set_pos (x, y)
  self.pos:set(x, y)
end

function dynamic_body:move_pos (v)
  self.pos:add(v)
end

function dynamic_body:get_pos ()
  return self.pos * 1
end

return dynamic_body
