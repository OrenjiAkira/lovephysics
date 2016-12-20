
local framedelay = 0
local framerate = 60
local frameunit = 1/framerate

local physics = require "physics"
local game = {}

--------------------------
--[[ Basic Game Logic ]]--
--------------------------

function game.load ()
  --
end

function game.update ()
  physics.update()
end

function game.draw ()
  -- body
end

--------------------------
--[[ Love Game Logic ]]--
--------------------------

function love.load ()
  love.math.setRandomSeed(os.time())
  math.random = love.math.random
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
