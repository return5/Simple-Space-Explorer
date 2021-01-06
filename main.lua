local Planets = require("aux_files.planet")
local Ships   = require("aux_files.ship")
local WINDOW_WIDTH  = 800
local WINDOW_HEIGHT = 800
local HALF_W        = WINDOW_WIDTH / 2
local HALF_H        = WINDOW_HEIGHT / 2

function love.draw(dt)
    love.graphics.translate(-PLAYER.x + HALF_W, -PLAYER.y + HALF_H)
    printShips()
    printPlanets()
    PLAYER:print()
end

local function getDirection()
    local mouse_x = love.mouse.getX() + PLAYER.x - HALF_W
    local mouse_y = love.mouse.getY() + PLAYER.y - HALF_H
    local angle   = math.atan2(mouse_y - PLAYER.y,mouse_x - PLAYER.x)
    PLAYER.angle  = angle
end

local function movePlayerShip(dt)
    local cos    = math.cos(PLAYER.angle)
    local sin    = math.sin(PLAYER.angle) 
    PLAYER.x     = PLAYER.x + 200 * cos * dt
    PLAYER.y     = PLAYER.y + 200 * sin * dt
end

function love.update(dt)
    getDirection()
    movePlayerShip(dt)
end


function love.load()
    math.randomseed(os.time())
    HEIGHT       = 3000
    WIDTH        = 3000
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT)
    SOLAR_SYSTEM = makeSolarSystem()
    PLAYER       = makePlayerShip(SOLAR_SYSTEM)
    SHIPS        = makeEnemyShips(SOLAR_SYSTEM)
end

