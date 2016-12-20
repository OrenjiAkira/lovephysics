
local Vector = require "basic.vector"

return function (t)
  local self = {}

  -- private
  local pos = Vector:new { t[1], t[2] }
  local size = Vector:new { t[3], t[4] }
  local centred = true

  -- public
  function self:get_pos ()
    local fpos = pos * 1
    math.floor(fpos.x)
    math.floor(fpos.y)
    return fpos
  end

  function self:set_pos (v)
    assert(v:get_type() == "vector")
    pos:set(v:unpack())
  end

  function self:get_size ()
    return size * 1
  end

  function self:set_size (v)
    assert(v:get_type() == "vector")
    size:set(v:unpack())
  end

  return self
end
