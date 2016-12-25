
local framedelay = 0
local framerate = 60
local frameunit = 1/framerate

local window_width = 1024
local window_height = 640
local unit = 16

local physics = require "physics"
local game = {}

--------------------------
--[[ Basic Game Logic ]]--
--------------------------

local world
local dynbody1
local statbody1

function game.load ()
  local w, h = window_width / unit, window_height / unit
  world = physics.new_map(w, h)
  dynbody1 = physics.new_dynamic_body(world, math.random(1, w-1), math.random(1, h-1), 2, 4)
  statbody1 = physics.new_static_body(world, math.random(1, w-1), math.random(1, h-1), 4, 4)
  print(dynbody1:get_pos())
  print(statbody1:get_pos())
end

function game.update ()
  physics.update()
end

function game.draw ()
  local p1 = dynbody1:get_pos() * unit
  local p2 = statbody1:get_pos() * unit
  local s1 = dynbody1:get_size() * unit
  local s2 = statbody1:get_size() * unit
  love.graphics.setColor(255, 255, 255, 155)
  love.graphics.rectangle("fill", p1.x, p1.y, s1.x, s1.y)
  love.graphics.setColor(255, 100, 100, 155)
  love.graphics.rectangle("fill", p2.x, p2.y, s2.x, s2.y)
end

--------------------------
--[[ Love Game Logic ]]--
--------------------------

function love.load ()
  -- random
  love.math.setRandomSeed(os.time())
  math.random = love.math.random

  -- map
  love.window.setMode(window_width, window_height)

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
