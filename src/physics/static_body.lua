
local Vector = require "basic.vector"
local CollisionObject = require "physics.collision_object"

return function (t)
  local self = CollisionObject()
  self:type("static_body")

  -- private
  local pos = Vector:new { t[1] or 1, t[2] or 1 }
  local size = Vector:new { t[3] or 1, t[4] or 1 }
  local centered

  if t.centered == false then centered = false
  else centered = true end

  local function occupy ()
    local map = self:get_map()
    local ps = self:get_corner("top_left")
    map:occupy(ps, size, self)
  end

  local function unoccupy ()
    local map = self:get_map()
    local ps = self:get_corner("top_left")
    map:unoccupy(ps, size, self)
  end

  -- public
  function self:get_pos ()
    local fpos = pos * 1
    math.floor(fpos.x)
    math.floor(fpos.y)
    return fpos
  end

  function self:set_pos (v)
    assert(v:get_type() == "vector",
      [[Invalid argument to method 'set_pos' (from StaticBody).
      Expected 'vector', got: ]] .. type(v))
    unoccupy()
    pos:set(v:unpack())
    occupy()
  end

  function self:get_size ()
    return size * 1
  end

  function self:set_size (v)
    assert(v:get_type() == "vector")
    size:set(v:unpack())
  end

  function self:get_corner (corner)
    local ps = self:get_pos()
    local sz = self:get_size()
    local offset = centered and ps - (sz / 2) or ps

    if corner == "top_left" then
      sz:mul(0)
    elseif corner == "top_right" then
      s.y = 0
    elseif corner == "bottom_left" then
      s.y = 0
    elseif corner == "bottom_right" then
      sz = sz
    else
      error("Invalid argument to method 'get_corner' (from StaticBody): '" .. corner .. "'. Expected 'top_left', 'top_right', 'bottom_left' or 'bottom_right'.")
    end

    return offset + sz
  end

  return self
end
