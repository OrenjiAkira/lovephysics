
local StaticBody = require "physics.static_body"

return function (t)
  local self = StaticBody(t)
  self:type("dynamic_body")

  -- private
  local movement = require "basic.vector" :new {}

  -- public
  function self:get_movement ()
    local fmovement = movement * 1
    math.floor(fmovement.x)
    math.floor(fmovement.y)
    return fmovement
  end

  function self:move (v)
    assert(v:get_type() == "vector")
    movement:set(v:unpack())
  end

  return self
end
