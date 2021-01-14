local Planets = require("aux_files.planet")
local Ships   = require("aux_files.ship")
local Trade   = require("aux_files.trade")

local WINDOW_WIDTH  = 800
local WINDOW_HEIGHT = 800
local CANVASES      = {planets = nil, ships = nil,border = nil}



--print remaining time to main screen
local function printTime()
    local time = string.format("Remaining time: %.1f",TOTAL_TIME - (love.timer.getTime() - START_TIME))
    love.graphics.print(time,1,(MAIN_FONT:getHeight() * 3) + 10)
end

--print player info on main screen
local function printUI()
    love.graphics.print("player's fuel is: " .. PLAYER.inv["Fuel"].quant,1,1)
    love.graphics.print("player money is: " .. PLAYER.money,1,MAIN_FONT:getHeight() + 10)
    love.graphics.print("Player score is: " .. PLAYER_SCORE,1,(MAIN_FONT:getHeight() * 2) + 10)
    printTime()
end

--draw open space with ships and planets.
local function openSpace()
    printUI()
    love.graphics.translate(-PLAYER.x + HALF_W, -PLAYER.y + HALF_H)
    for _,canvas in pairs(CANVASES) do
        love.graphics.draw(canvas)
    end
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
    local cos   = math.cos(PLAYER.angle)
    local sin   = math.sin(PLAYER.angle) 
    local new_x = PLAYER.x + PLAYER.speed * cos * dt
    local new_y = PLAYER.y + PLAYER.speed * sin * dt
    if (new_x > 10 and new_x < WIDTH - 10) and (new_y > 10 and new_y < HEIGHT - 10) then
        PLAYER.x = new_x
        PLAYER.y = new_y
    end
end

--as player flys around decrease the ammount of fuel
local function useUpFuel()
    PLAYER.inv["Fuel"].quant = PLAYER.inv["Fuel"].quant - 1
end

--move the Player's ship forward
local function movePlayerShip(dt)
    if PLAYER.inv["Fuel"].quant > 0  then
        updatePlayerShipLocation(dt)
        useUpFuel()
        ENGINE_SOUND:play()
        MOVE_PLAYER = true
    else
        MOVE_PLAYER = false
        ENGINE_SOUND:stop()
    end
end

local function printBorderToCanvas(canvas)
    love.graphics.setCanvas(canvas)
    love.graphics.setColor(1,1,1)
    love.graphics.setLineWidth(10)
    love.graphics.line(1,1,WIDTH,1)
    love.graphics.line(1,HEIGHT,WIDTH,HEIGHT)
    love.graphics.line(1,1,1,HEIGHT)
    love.graphics.line(WIDTH,1,WIDTH,HEIGHT)
end

local function printObjectsToCanvas()
    CANVASES.planets = love.graphics.newCanvas(WIDTH,HEIGHT)
    CANVASES.ships   = love.graphics.newCanvas(WIDTH,HEIGHT)
    CANVASES.border  = love.graphics.newCanvas(WIDTH,HEIGHT)
    printObjects(SOLAR_SYSTEM,CANVASES.planets)
    printObjects(SHIPS,CANVASES.ships)
    printBorderToCanvas(CANVASES.border)
    love.graphics.setCanvas()
end

function playerPressedT()
    TRADE_PARTNER = checkForTradePartner({SOLAR_SYSTEM,SHIPS})
    if TRADE_PARTNER ~= nil then
        DRAW_TRADE = true
        DRAW_SPACE = false
        if TRADE_PARTNER.discovered == false then
            TRADE_PARTNER.discovered = true
            PLAYER_SCORE             = PLAYER_SCORE + 20
        end
    end
end

local function getPlayerName()
    local title = "please enter name: "
    love.graphics.print(title,1,1)
    love.graphics.print(PLAYER_NAME,MAIN_FONT:getWidth(title) + 5,1)
end

function love.draw(dt)
    if DRAW_SELL == true then
        sellScreen()
    elseif DRAW_INV == true then
        playerInventory()
    elseif DRAW_TRADE == true then
        tradeScreen()
    elseif DRAW_SPACE == true then
        openSpace()
    elseif GET_P_NAME == true then
        getPlayerName()
    end
end

function love.mousepressed(x,y,button,_,_)
    if button == 1 and DRAW_TRADE == true then
        BOUGHT_STR = getInvItemFromClick(x,y,tradeItem)
    elseif button == 1 and DRAW_INV == true then
        BOUGHT_STR = getInvItemFromClick(x,y,upgradeShip)
    end
end

function love.textinput(t)
    if GET_P_NAME == true then
        PLAYER_NAME = PLAYER_NAME .. t
    end
end

function love.keypressed(_,scancode)
    if GET_P_NAME == true and scancode == "return" then
        GET_P_NAME = false
        DRAW_SPACE = true
    elseif scancode == "t" then
        playerPressedT()
    elseif scancode == "i" then
        DRAW_INV = not DRAW_INV
        DRAW_SPACE = not DRAW_SPACE
    elseif scancode == "escape" then
        if DRAW_SELL == false then
            DRAW_INV   = false
            DRAW_TRADE = false
            DRAW_SPACE = true
        end
        DRAW_SELL = false
    end
end

function love.update(dt)
    if DRAW_SPACE == true then
        getDirection(dt)
        if love.keyboard.isScancodeDown('w') then
            movePlayerShip(dt)
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
    GET_P_NAME    = true
    PLAYER_NAME   = ""
    MOVE_PLAYER   = false
    DRAW_TRADE    = false    -- should trade screen be drawn
    DRAW_SPACE    = false     --should open space screen be drawn
    DRAW_INV      = false    --should inventory screen be drawn
    DRAW_SELL     = false   --should screen showing sold/bought be displayed
    BOUGHT_STR    = nil
    SOLAR_SYSTEM  = makeSolarSystem()              --list of all planets
    SHIPS         = makeComputerShips(SOLAR_SYSTEM)   --list of non player controlled ships
    PLAYER        = makePlayerShip(SOLAR_SYSTEM)   --player ship
    printObjectsToCanvas()
    ENGINE_SOUND  = love.audio.newSource("/sounds/Engine.flac","static")
    TRADE_PARTNER = PLAYER
    THRUSTER      = love.graphics.newImage("/img/effects/thrust.png")
    PLAYER_SCORE  = 0
    TOTAL_TIME    = 180
    START_TIME    = love.timer.getTime()
end

