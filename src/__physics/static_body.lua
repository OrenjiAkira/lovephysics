
local Vector = require "basic.vector"
local CollisionObject = require "physics.collision_object"

return function (t)
  local self = CollisionObject()
  self:type("static_body")

  -- private
  local pos = Vector:new { t[1] or 1, t[2] or 1 }
  local size = Vector:new { t[3] or 1, t[4] or 1 }

  local function occupy ()
    local map = self:get_map()
    local ps = self:get_pos()
    map:occupy(ps, size, self)
  end

  local function unoccupy ()
    local map = self:get_map()
    local ps = self:get_pos()
    map:unoccupy(ps, size, self)
  end

  local function check_outer_bounds ()
    local mapwidth, mapheight = self:get_map():get_dimensions()
    if pos.x < 1 then
      pos.x = 1
    end
    if pos.x + size.x - 1 >= mapwidth then
      pos.x = mapwidth - size.x + 1
    end
    if pos.y < 1 then
      pos.y = 1
    end
    if pos.y + size.y - 1 >= mapheight then
      pos.y = mapheight - size.y + 1
    end
  end

  -- public
  function self:get_pos ()
    local fpos = pos * 1
    fpos.x = math.floor(fpos.x)
    fpos.y = math.floor(fpos.y)
    return fpos
  end

  function self:get_float_pos ()
    return pos * 1
  end

  function self:set_pos (v)
    assert(v:get_type() == "vector",
      [[Invalid argument to method 'set_pos' (from StaticBody).
      Expected 'vector', got: ]] .. type(v))
    unoccupy()
    print(v)
    pos:set(v:unpack())
    occupy()
  end

  function self:move (v)
    assert(v:get_type() == "vector")
    pos:add(v)
    check_outer_bounds()
  end

  function self:get_size ()
    return size * 1
  end

  function self:set_size (v)
    assert(v:get_type() == "vector")
    v:set(math.floor(v.x), math.floor(v.y))
    size:set(v:unpack())
  end

  return self
end
