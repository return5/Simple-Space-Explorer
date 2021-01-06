local Planets = require("aux_files.planet")
local Ships   = require("aux_files.ship")
local WINDOW_WIDTH  = 800
local WINDOW_HEIGHT = 800
local drawFunc


--draw open space with ships and planets.
local function drawSpace()
    love.graphics.translate(-PLAYER.x + HALF_W, -PLAYER.y + HALF_H)
    printObjects(SHIPS,PLAYER)
    printObjects(SOLAR_SYSTEM,PLAYER)
    PLAYER:print(PLAYER)
end

--prints player inventory selection screen
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

--if flying in outerspace then get direction and move ship
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
    HEIGHT       = 3000     --height of entire game world
    WIDTH        = 3000     --width of entire game world
    DRAW_SPACE   = true     --should open space screen be drawn
    DRAW_INV     = false    --should inventory screen be drawn
    DRAW_TRADE   = false    -- should trade screen be drawn
    HALF_W       = WINDOW_WIDTH / 2  --half the width of the window
    HALF_H       = WINDOW_HEIGHT / 2 --half the height of window
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT)
    SOLAR_SYSTEM = makeSolarSystem()              --list of all planets
    PLAYER       = makePlayerShip(SOLAR_SYSTEM)   --player ship
    SHIPS        = makeComputerShips(SOLAR_SYSTEM)   --list of non player controlled ships
end

