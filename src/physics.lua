
require "basic.tableutility"

local Iterate = require "basic.iterate"
local Queue = require "basic.queue"

local Map = require "physics.map"
local DynamicBody = require "physics.dynamic_body"
local StaticBody = require "physics.static_body"

local physics = {}
local maps = {}
local bodies = {}
local collisions = Queue:new { 1024 }

local function add_body (body, map)
  assert(map, "Map undefined! Create map first with 'physics.new_map()'.")
  body:set_map(map)
  body:set_pos(body:get_pos())
  table.insert(bodies, body)
end

local function update_movement (dynBody)
  local movement = dynBody:get_movement()

  if movement:sqrlen() > 0 then
    local moveable = true
    local colliders = dynBody:get_collision()
    if colliders then
      for i = 1, #colliders do
        local otherBody = colliders[i]
        if dynBody ~= otherBody and dynBody:is_layer_colliding(otherBody) then
          if otherBody:type() == "static_body" then
            moveable = false
            print("collision with static body")
          else
            print("collision with non-static body")
          end
          collisions:enqueue { dynBody, otherBody }
        end
      end
    end
    if moveable then
      dynBody:move(movement)
    end
  end
end

function physics.delete_body (body)
  local k = table.find(bodies, body)
  if k then table.remove(bodies, k) end
end

function physics.new_dynamic_body (map, x, y, w, h, center)
  local body = DynamicBody { x, y, w, h, centered = center }
  add_body(body, map)
  return body
end

function physics.new_static_body (map, x, y, w, h, center)
  local body = StaticBody { x, y, w, h, centered = center }
  add_body(body, map)
  return body
end

function physics.new_map (w, h)
  local m = Map.new(w, h)
  table.insert(maps, m)
  return m
end

function physics.get_next_collision ()
  if collisions:empty() then
    return false
  else
    return collisions:dequeue()
  end
end

local function update_bodies ()
  for i = 1, #bodies do
    local body = bodies[i]
    if body:type() == "dynamic_body" then
      update_movement(body)
    end
    body:update()
  end
end

function physics.update ()
  collisions:clear()
  update_bodies()
end

return physics
