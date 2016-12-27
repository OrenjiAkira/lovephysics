
local StaticBody = require "physics.static_body"

return function (t)
  local self = StaticBody(t)
  self:type("dynamic_body")

  -- private
  local movement = require "basic.vector" :new {}
  local next_pos = require "basic.vector" :new {}

  -- public
  function self:get_movement ()
    return movement * 1
  end

  function self:try_move (v)
    assert(v:get_type() == "vector")
    movement:add(v)
    next_pos:set((self:get_float_pos() + movement):unpack())
  end

  function self:get_next_pos ()
    local fnext_pos = next_pos * 1
    fnext_pos.x = math.floor(fnext_pos.x)
    fnext_pos.y = math.floor(fnext_pos.y)
    return fnext_pos
  end

  function self:get_collision()
    local grid = self:get_map():get_grid()
    local pos = self:get_next_pos()
    local size = self:get_size()
    for i = pos.y, pos.y + size.y do
      for j = pos.x, pos.x + size.x do
        local cell = grid:get_cell(i, j)
        local list = cell and cell:get_list()
        if list and #list > 0 and not (#list == 1 and list[1] == self) then
          return list
        end
      end
    end
  end

  function self:update ()
    movement:set()
    next_pos:set()
  end

  return self
end
