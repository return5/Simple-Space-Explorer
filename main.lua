local Planets = require("aux_files.planet")
local Ships   = require("aux_files.ship")
local Trade   = require("aux_files.trade")

local WINDOW_WIDTH  = 800
local WINDOW_HEIGHT = 800
local CANVASES      = {planets = nil, ships = nil}



--draw open space with ships and planets.
local function openSpace()
    love.graphics.print("player's fuel is: " .. PLAYER.fuel,1,1)
    love.graphics.translate(-PLAYER.x + HALF_W, -PLAYER.y + HALF_H)
    love.graphics.draw(CANVASES.planets)
    love.graphics.draw(CANVASES.ships)
    if MOVE_PLAYER == true then
        love.graphics.draw(THRUSTER,PLAYER.x,PLAYER.y,PLAYER.angle,nil,nil,THRUSTER:getWidth() / 2,PLAYER.y_off)
    end
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

local function printPlayerThruster()
    love.graphics.translate(-PLAYER.x + HALF_W, -PLAYER.y + HALF_H)
end

--when player ship is moving, update it's x and y'
local function updatePlayerShipLocation(dt)
    local cos  = math.cos(PLAYER.angle)
    local sin  = math.sin(PLAYER.angle) 
    PLAYER.x   = PLAYER.x + PLAYER.speed * cos * dt
    PLAYER.y   = PLAYER.y + PLAYER.speed * sin * dt
end

--as player flys around decrease the ammount of fuel
local function useUpFuel()
    PLAYER.fuel = PLAYER.fuel - 1
end

--move the Player's ship forward
local function movePlayerShip(dt)
    if PLAYER.fuel > 0  then
        updatePlayerShipLocation(dt)
        useUpFuel()
        ENGINE_SOUND:play()
    end
end

local function printObjectsToCanvas()
    CANVASES.planets = love.graphics.newCanvas(HEIGHT,WIDTH)
    CANVASES.ships   = love.graphics.newCanvas(HEIGHT,WIDTH)
    printObjects(SOLAR_SYSTEM,CANVASES.planets)
    printObjects(SHIPS,CANVASES.ships)
    love.graphics.setCanvas()
end

function playerPressedT()
    TRADE_PARTNER = checkForTradePartner({SOLAR_SYSTEM,SHIPS})
    if TRADE_PARTNER ~= nil then
        DRAW_TRADE = true
    end
end

function love.draw(dt)
    if DRAW_INV == true then
        playerInventory()
    elseif DRAW_TRADE == true then
        tradeScreen()
    elseif DRAW_SPACE == true then
        openSpace()
    end
end


function love.keypressed(_,scancode)
    if scancode == "t" then
        playerPressedT()
    elseif scancode == "i" then
        DRAW_INV = not DRAW_INV
    elseif scancode == "escape" then
        DRAW_INV   = false
        DRAW_TRADE = false
    end
end

function love.update(dt)
    if DRAW_SPACE == true then
        getDirection(dt)
        if love.keyboard.isScancodeDown('w') then
            movePlayerShip(dt)
            MOVE_PLAYER = true
        else
            ENGINE_SOUND:stop()
            MOVE_PLAYER = false
        end
    end
end

function love.load()
    math.randomseed(os.time())
    HEIGHT        = 3000     --height of entire game world
    WIDTH         = 3000     --width of entire game world
    HALF_W        = WINDOW_WIDTH / 2  --half the width of the window
    HALF_H        = WINDOW_HEIGHT / 2 --half the height of window
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT)
    love.keyboard.setKeyRepeat(true)
    LARGE_FONT    = love.graphics.newFont(20)
    MAIN_FONT     = love.graphics.newFont()
    SOLAR_SYSTEM  = makeSolarSystem()              --list of all planets
    SHIPS         = makeComputerShips(SOLAR_SYSTEM)   --list of non player controlled ships
    PLAYER        = makePlayerShip(SOLAR_SYSTEM)   --player ship
    printObjectsToCanvas()
    ENGINE_SOUND  = love.audio.newSource("/sounds/Engine.flac","static")
    DRAW_TRADE    = false    -- should trade screen be drawn
    DRAW_SPACE    = true     --should open space screen be drawn
    DRAW_INV      = false    --should inventory screen be drawn
    TRADE_PARTNER = nil
    MOVE_PLAYER   = false
    THRUSTER      = love.graphics.newImage("/img/effects/thrust.png")
end

