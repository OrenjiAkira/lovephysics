
local framedelay = 0
local framerate = 60
local frameunit = 1/framerate

local window_width = 1024
local window_height = 640
local unit = 32

local input = require "input"
local physics = require "basic.physics"
local game = {}

local Vector = require "basic.vector"

--------------------------
--[[ Basic Game Logic ]]--
--------------------------

local world
local dynbody
local w, h = 1, 1
local speed = .05

local move = function (body, direction)
  body:move(direction)
end

local execute = {
  hold_up = function ()
    move(dynbody, Vector:new { 0, -speed })
  end,
  hold_down = function ()
    move(dynbody, Vector:new { 0,  speed })
  end,
  hold_left = function ()
    move(dynbody, Vector:new {-speed,  0 })
  end,
  hold_right = function ()
    move(dynbody, Vector:new { speed,  0 })
  end,
  release_quit = function ()
    love.event.quit()
  end
}

function game.printbodies ()
  print("dynamicbody: " .. tostring(dynbody:get_pos()))
end

function game.load ()
  local mapwidth, mapheight = window_width / unit, window_height / unit
  --world = physics.new_map(mapwidth, mapheight)
  world = physics.new_map_from_matrix(require 'dummy_map', unit)
  dynbody = physics.new_body(world, math.random(1, mapwidth - w), math.random(1, mapheight - h), w, h)
  game.printbodies()
end

function game.actions ()
  local action = input.get_next_input()
  while action do
    if execute[action] then execute[action]() end
    -- done, do next
    action = input.get_next_input()
  end
  --game.printbodies()
end

function game.update ()
  input.update()
  game.actions()
  physics.update()
end

function game.draw ()
  local correction = Vector:new { -1, -1 }
  local rectangle = dynbody:get_shape()
  local p1 = (rectangle:get_pos() + correction) * unit
  local s1 = rectangle:get_size() * unit
  local grid = world:get_grid()

  for i, j, u in grid:iterate() do
    if u ~= 0 then
      local x, y = (j - 1) * unit, (i - 1) * unit
      love.graphics.setColor(255, 255, 255)
      love.graphics.rectangle("fill", x, y, unit, unit)
    end
  end

  love.graphics.setColor(255, 200, 100, 155)
  love.graphics.rectangle("fill", p1.x, p1.y, s1.x, s1.y)
end

--------------------------
--[[ Love Game Logic ]]--
--------------------------

function love.load ()
  -- random
  love.math.setRandomSeed(tonumber(tostring(os.time()):reverse():sub(1,6)))
  math.random = love.math.random

  -- map
  love.window.setMode(window_width, window_height)
  love.graphics.setDefaultFilter("nearest", "nearest")

  game.load()
end

function love.update (dt)
  framedelay = framedelay + dt
  while framedelay >= frameunit do
    framedelay = framedelay - frameunit
    game.update()
  end
end

function love.draw ()
  game.draw()
end
