
local framedelay = 0
local framerate = 60
local frameunit = 1/framerate

local window_width = 1024
local window_height = 640

unit = 32

local input = require "input"
local physics = require "physics"
local game = {}

local Vector = require "basic.vector"

--------------------------
--[[ Basic Game Logic ]]--
--------------------------

local world
local dynbody1
local statbody1
local w1, h1, w2, h2 = 8, 6, 6, 6
local speed = .05

local move = function (body, direction)
  body:try_move(direction)
end

local execute = {
  hold_up = function ()
    move(dynbody1, Vector:new { 0, -speed })
  end,
  hold_down = function ()
    move(dynbody1, Vector:new { 0,  speed })
  end,
  hold_left = function ()
    move(dynbody1, Vector:new {-speed,  0 })
  end,
  hold_right = function ()
    move(dynbody1, Vector:new { speed,  0 })
  end,
  release_quit = function ()
    love.event.quit()
  end
}

function game.printbodies ()
  print("dynamicbody: " .. tostring(dynbody1:get_float_pos()))
  print("staticbody:  " .. tostring(statbody1:get_float_pos()))
end

function game.load ()
  local w, h = window_width / unit, window_height / unit
  world = physics.new_map(w, h)
  dynbody1 = physics.new_dynamic_body(world, math.random(1, w - w1), math.random(1, h - h1), w1, h1, false)
  statbody1 = physics.new_static_body(world, math.random(1, w - w2), math.random(1, h - h2), w2, h2, false)
  game.printbodies()
end

function game.actions ()
  local action = input.get_next_input()
  while action do
    print("EXECUTING ACTION:", action)
    if execute[action] then execute[action]() end
    game.printbodies()
    -- done, do next
    action = input.get_next_input()
  end
end

function game.update ()
  input.update()
  game.actions()
  physics.update()
end

function game.draw ()
  local correction = Vector:new { -1, -1 }
  local p1 = (dynbody1:get_float_pos() + correction) * unit
  local p2 = (statbody1:get_float_pos() + correction) * unit
  local s1 = dynbody1:get_size() * unit
  local s2 = statbody1:get_size() * unit
  love.graphics.setColor(255, 255, 255)
  world:draw()
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
