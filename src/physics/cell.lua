
local cell = {}

function cell.new ()
  local c = {}
  setmetatable(c, map)

  c.list = {}
  return c
end

function cell:get_list ()
  return c.list
end

function cell:add_item (item)
  local list = self:get_list()
  local k = table.find(list, item)
  if not k then
    table.insert(list, item)
  end
end

function cell:get_item (item)
  local list = self:get_list()
  local k = table.find(list, item)
  return list[k]
end

function cell:remove_item (item)
  local list = self:get_list()
  local k = table.find(list, item)
  table.remove(list, k)
end

return cell
