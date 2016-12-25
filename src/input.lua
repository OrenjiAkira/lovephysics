
local Queue = require "basic.queue"

local input = {}

local values = Queue:new { 16 }
local keymap = {
  up = "up",
  down = "down",
  left = "left",
  right = "right",
  f8 = "quit",
}

local function handle_press (key)
  local action = keymap[key]
  if action then
    values:enqueue("press_" .. action)
  end
end

local function handle_release (key)
  local action = keymap[key]
  if action then
    values:enqueue("release_" .. action)
  end
end

local function handle_hold (key)
  local action = keymap[key]
  if action then
    values:enqueue("hold_" .. action)
  end
end

function input.update ()
  for key in pairs(keymap) do
    if love.keyboard.isDown(key) then
      handle_hold(key)
    end
  end
end

function input.get_next_input ()
  if values:is_empty() then
    return false
  else
    return values:dequeue()
  end
end

function love.keypressed (key)
  handle_press(key)
end

function love.keyreleased (key)
  handle_release(key)
end

return input
