
require "basic.tableutility"

local Map = require "physics.map"
local DynamicBody = require "physics.dynamic_body"
local StaticBody = require "physics.static_body"

local physics = {}
local maps = {}
local bodies = {}

local function add_body (body, map)
  assert(map, "Map undefined! Create map first with 'physics.new_map()'.")
  body:set_map(map)
  table.insert(bodies, body)
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

function physics.new_map (w, h, u)
  local m = Map.new(w, h, u)
  table.insert(maps)
  return m
end

function physics.update ()
  for _,map in ipairs(maps) do
    map:draw()
  end
end

init()

return physics
