local Planets = require("aux_files.planet")
local Ships   = require("aux_files.ship")
local Trade   = require("aux_files.trade")

local DRAWFUNC
local CANVASES      = {planets = nil, ships = nil}



--draw open space with ships and planets.
local function openSpace()
    love.graphics.translate(-PLAYER.x + HALF_W, -PLAYER.y + HALF_H)
    love.graphics.draw(CANVASES.planets)
    love.graphics.draw(CANVASES.ships)
    PLAYER:print(PLAYER)
end
--
--get the direction which the ship should face based on the location of the mouse
local function getDirection()
    local mouse_x = love.mouse.getX() + PLAYER.x - HALF_W
    local mouse_y = love.mouse.getY() + PLAYER.y - HALF_H
    local angle   = math.atan2(mouse_y - PLAYER.y,mouse_x - PLAYER.x)
    PLAYER.angle  = angle
end

--move the Player's ship forward
local function movePlayerShip(dt)
    local cos    = math.cos(PLAYER.angle)
    local sin    = math.sin(PLAYER.angle) 
    PLAYER.x     = PLAYER.x + PLAYER.speed * cos * dt
    PLAYER.y     = PLAYER.y + PLAYER.speed * sin * dt
end

--as player flys around decrease the ammount of fuel
local function useUpFuel()
    PLAYER.fuel = PLAYER.fuel - 1
end

--if flying in outerspace then get direction and move ship
local function playerShipSpace(dt)
    getDirection()
    if love.keyboard.isScancodeDown("w") then
        movePlayerShip(dt)
        useUpFuel()
        ENGINE_SOUND:play()
    else
        ENGINE_SOUND:stop()
        if love.keyboard.isScancodeDown("i") then
            DRAW_INV = true
        elseif love.keyboard.isScancodeDown("t") then
            playerPressedT()
        end
    end
end

local function printObjectsToCanvas()
    CANVASES.planets = love.graphics.newCanvas(HEIGHT,WIDTH)
    CANVASES.ships   = love.graphics.newCanvas(HEIGHT,WIDTH)
    printObjects(SOLAR_SYSTEM,CANVASES.planets)
    printObjects(SHIPS,CANVASES.ships)
    love.graphics.setCanvas()
end

function love.draw(dt)
    DRAWFUNC()
end

function love.update(dt)
    if DRAW_INV == true then
        DRAWFUNC = playerInventory
    elseif DRAW_TRADE == true then
        DRAWFUNC = tradeScreen
    elseif DRAW_SPACE == true then
        playerShipSpace(dt)
        DRAWFUNC = openSpace
    end
end

function love.load()
    math.randomseed(os.time())
    HEIGHT        = 3000     --height of entire game world
    WIDTH         = 3000     --width of entire game world
    WINDOW_WIDTH  = 800
    WINDOW_HEIGHT = 800
    HALF_W        = WINDOW_WIDTH / 2  --half the width of the window
    HALF_H        = WINDOW_HEIGHT / 2 --half the height of window
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT)
    MAIN_FONT     = love.graphics.newFont()
    SOLAR_SYSTEM  = makeSolarSystem()              --list of all planets
    PLAYER        = makePlayerShip(SOLAR_SYSTEM)   --player ship
    SHIPS         = makeComputerShips(SOLAR_SYSTEM)   --list of non player controlled ships
    printObjectsToCanvas()
    ENGINE_SOUND  = love.audio.newSource("/sounds/Engine.flac","static")
    DRAW_TRADE    = false    -- should trade screen be drawn
    DRAW_SPACE    = true     --should open space screen be drawn
    DRAW_INV      = false    --should inventory screen be drawn
    TRADE_PARTNER = PLAYER
end

