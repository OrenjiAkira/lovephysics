
local cell = {}

function cell:__index (k)
  if k ~= "new" then
    return getmetatable(self)[k]
  end
end

function cell.new ()
  local c = {}
  setmetatable(c, cell)

  c.list = {}
  return c
end

function cell:get_list ()
  return self.list
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
