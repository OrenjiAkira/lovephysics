
local Vector = require "basic.vector"
local CollisionObject = require "physics.collision_object"

return function (t)
  local self = CollisionObject()

  -- private
  local pos = Vector:new { t[1] or 1, t[2] or 1 }
  local size = Vector:new { t[3] or 1, t[4] or 1 }
  local centered = t.centered == false and false or true

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
    pos:set(v:unpack())
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
      sz *= 0
    else if corner == "top_right" then
      s.y = 0
    else if corner == "bottom_left" then
      s.y = 0
    else if corner == "bottom_right" then
      sz = sz
    else
      error("Invalid argument to method 'get_corner' (from StaticBody): '" .. corner .. "'. Expected 'top_left', 'top_right', 'bottom_left' or 'bottom_right'.")
    end

    return offset + sz
  end

  return self
end
