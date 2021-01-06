local Planets = require("aux_files.planet")
local Ships   = require("aux_files.ship")
local WINDOW_WIDTH  = 800
local WINDOW_HEIGHT = 800
local drawFunc


local function drawSpace()
    love.graphics.translate(-PLAYER.x + HALF_W, -PLAYER.y + HALF_H)
    printObjects(SHIPS,PLAYER)
    printObjects(SOLAR_SYSTEM,PLAYER)
    PLAYER:print(PLAYER)
end

local function drawInventory()
    love.graphics.setNewFont(20)
    love.graphics.print("player inventory:",4,1)
    love.graphics.setNewFont()
    for i=1,#PLAYER.inv,1 do
        love.graphics.print(PLAYER.inv[i].name,22, 10 + 20 * i)
    end
    love.graphics.print("press esc to exit.", 4, 10 + 20 * (#PLAYER.inv + 1))
    if love.keyboard.isScancodeDown("escape") then
        DRAW_INV   = false
        DRAW_SPACE = true
    end
end

function love.draw(dt)
    drawFunc()
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
    PLAYER.x     = PLAYER.x + PLAYER.speed * cos * dt
    PLAYER.y     = PLAYER.y + PLAYER.speed * sin * dt
end

local function playerShipSpace(dt)
    getDirection()
    if love.keyboard.isScancodeDown("w") then
        movePlayerShip(dt)
    elseif love.keyboard.isScancodeDown("i") then
        DRAW_INV   = true
        DRAW_SPACE = false
    end
end

function love.update(dt)
    if DRAW_SPACE == true then
        playerShipSpace(dt)
        drawFunc = drawSpace
    elseif DRAW_INV == true and PLAYER.inv ~= nil then
        drawFunc = drawInventory
    end
end


function love.load()
    math.randomseed(os.time())
    HEIGHT       = 3000
    WIDTH        = 3000
    DRAW_SPACE   = true
    DRAW_INV     = false
    DRAW_TRADE   = false
    HALF_W       = WINDOW_WIDTH / 2
    HALF_H       = WINDOW_HEIGHT / 2
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT)
    SOLAR_SYSTEM = makeSolarSystem()
    PLAYER       = makePlayerShip(SOLAR_SYSTEM)
    SHIPS        = makeEnemyShips(SOLAR_SYSTEM)
end

