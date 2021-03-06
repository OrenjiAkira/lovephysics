
local queue = require 'basic.prototype' :new {
  256, -- basic size
  true, -- whether it worries about overflows
  __type = 'queue'
}

function queue:__init ()

  -- queue attributes (intern use only, please, unless you REALLY know what you're doing)
  self.queue = {}
  self.head = 1
  self.tail = 1
  self.size = self[1]
  self.overflow = self[2]

  self:clear()
end

function queue:clear ()
  -- allocating all of the queue in the same space for performance
  for i = 1, self.size do self.queue[i] = false end
  self.tail = self.head
end

function queue:is_empty ()
  return self.tail == self.head
end

function queue:enqueue (item)
  self.queue[self.tail] = item
  self.tail = self.tail % self.size + 1
  if self.overflow then
    assert(self.tail ~= self.head, "Queue overflow. Use a larger sized queue (currently is " .. tostring(self.size) .. ").")
  end
end

function queue:dequeue ()
  if self:is_empty() then return end
  local item = self.queue[self.head]
  self.queue[self.head] = false
  self.head = self.head % self.size + 1
  return item
end

function queue:__tostring ()
  local s = "== Queue == \n"-- body...
  s = s .. "> SIZE: " .. self.size .. "\n"
  s = s .. "> HEAD: #" .. self.head .. ", value: " .. tostring(self.queue[self.head]) .. "\n"
  s = s .. "> TAIL: #" .. self.tail .. ", value: " .. tostring(self.queue[self.tail]) .. "\n"
  return s
end

return queue
