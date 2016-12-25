
local MAX_LAYERS = 16

return function ()
  local self = {}

  -- private
  local layers = {}
  local collision_layers = {}
  local map, type_

  local function set_table_nums (t, l)
    for i = 1, MAX_LAYERS do
      t[i] = false
    end
    for _,i in ipairs(l) do
      if i > 0 and i <= MAX_LAYERS then
        t[i] = true
      end
    end
  end

  local function init ()
    set_table_nums(layers, { 1 })
    set_table_nums(collision_layers, { 1 })
  end

  -- public
  function self:update ()
    -- implement on child
  end

  function self:type (t)
    if t then type_ = t end
    return type_
  end

  function self:set_map (m)
    map = m
  end

  function self:get_map ()
    return map
  end

  function self:set_layers (l)
    assert(type(l) == "table", "Invalid argument to 'set_layers'. Expected 'table', got " .. type(l))
    set_table_nums(layers, l)
  end

  function self:set_collision_layers (l)
    assert(type(l) == "table", "Invalid argument to 'set_collision_layers'. Expected 'table', got " .. type(l))
    set_table_nums(collision_layers, l)
  end

  function self:collides_with (n)
    return collision_layers[n]
  end

  function self:is_in_layer (n)
    return layers[n]
  end

  function self:is_layer_colliding (other_obj)
    for n = 1, MAX_LAYERS do
      if self:collides_with(n) and other_obj:is_in_layer(n) then
        return true
      end
    end
  end

  init()
  return self
end
