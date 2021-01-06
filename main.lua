local Planets = require("aux_files.planet")
local Ships   = require("aux_files.ship")
local WINDOW_WIDTH  = 800
local WINDOW_HEIGHT = 800

function love.draw(dt)
    love.graphics.translate(-PLAYER.x + HALF_W, -PLAYER.y + HALF_H)
    PLAYER:print()
    printShips()
    printPlanets()
end

function love.update(dt)
    local mouse_x,mouse_y = love.mouse.getPosition()
    local angle = math.atan2(mouse_y - PLAYER.y,mouse_x - PLAYER.x)
    local cos   = math.cos(angle)
    local sin   = math.sin(angle) 
    PLAYER.x    = PLAYER.x + 200 * cos * dt
    PLAYER.y    = PLAYER.y + 200 * sin * dt
end


function love.load()
    math.randomseed(os.time())
    HEIGHT       = 3000
    WIDTH        = 3000
    HALF_W       = WINDOW_WIDTH / 2
    HALF_H       = WINDOW_HEIGHT / 2
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT)
    SOLAR_SYSTEM = makeSolarSystem()
    PLAYER       = makePlayerShip(SOLAR_SYSTEM)
    SHIPS        = makeEnemyShips(SOLAR_SYSTEM)
end

