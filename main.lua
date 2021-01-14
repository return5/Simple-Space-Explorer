local Planets = require("aux_files.planet")
local Ships   = require("aux_files.ship")
local Trade   = require("aux_files.trade")
local  utf8   = require("utf8")

local WINDOW_WIDTH  = 800   --width of display window
local WINDOW_HEIGHT = 800   --height of display window
--canvas to print along with main canvas during openspace
local CANVASES      = {planets = nil, ships = nil,border = nil}

--print remaining time to main screen
local function printTime()
    TIME_LEFT = TOTAL_TIME - (love.timer.getTime() - START_TIME)
    local str = string.format("time remaining: %.2f",TIME_LEFT)
    love.graphics.print(str,1,(MAIN_FONT:getHeight() * 3) + 10)
end

--print player info on main screen
local function printUI()
    love.graphics.print("player's fuel is: " .. PLAYER.inv["Fuel"].quant,1,1)
    love.graphics.print("player money is: " .. PLAYER.money,1,MAIN_FONT:getHeight() + 10)
    love.graphics.print("Player score is: " .. PLAYER_SCORE,1,(MAIN_FONT:getHeight() * 2) + 10)
    printTime()
end

--when player gets a game over, print this stuff
local function gameOver()
    ENGINE_SOUND:stop()
    love.graphics.setCanvas()
    love.graphics.clear()
    love.graphics.setFont(LARGE_FONT)
    local title     = "You just got a Game Over my friend."
    local title_len = LARGE_FONT:getWidth(title)
    love.graphics.print(title,HALF_W - title_len / 2,1)
    love.graphics.setFont(MAIN_FONT)
    love.graphics.print("Your score is: " .. PLAYER_SCORE,HALF_W - title_len / 2 + 20,10 + LARGE_FONT:getHeight())
    love.graphics.print("Thank you for playing.Please press excape to exit",HALF_W - title_len / 2,20 + LARGE_FONT:getHeight() + MAIN_FONT:getHeight())
end

--draw open space with ships and planets.
local function openSpace()
    love.graphics.push()
    love.graphics.translate(-PLAYER.x + HALF_W, -PLAYER.y + HALF_H)
    for _,canvas in pairs(CANVASES) do
        love.graphics.draw(canvas)
    end
    if MOVE_PLAYER == true then
        love.graphics.draw(THRUSTER,PLAYER.x,PLAYER.y,PLAYER.angle,nil,nil,THRUSTER:getWidth() / 2,PLAYER.y_off)
    end
    PLAYER:print(PLAYER)
    love.graphics.pop()
    printUI()
end
--
--get the direction which the ship should face based on the location of the mouse
local function getDirection()
    local mouse_x = love.mouse.getX() + PLAYER.x - HALF_W
    local mouse_y = love.mouse.getY() + PLAYER.y - HALF_H
    local angle   = math.atan2(mouse_y - PLAYER.y,mouse_x - PLAYER.x)
    PLAYER.angle  = angle
end

--draw thruster flame at back of player's ship'
local function printPlayerThruster()
    love.graphics.translate(-PLAYER.x + HALF_W, -PLAYER.y + HALF_H)
end

--when player ship is moving, update it's x and y
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

--print the white broder around the edge of map
local function printBorderToCanvas(canvas)
    love.graphics.setCanvas(canvas)
    love.graphics.setColor(1,1,1)
    love.graphics.setLineWidth(10)
    love.graphics.line(1,1,WIDTH,1)
    love.graphics.line(1,HEIGHT,WIDTH,HEIGHT)
    love.graphics.line(1,1,1,HEIGHT)
    love.graphics.line(WIDTH,1,WIDTH,HEIGHT)
end

--print ships, planets, border to their own canvases
local function printObjectsToCanvas()
    CANVASES.planets = love.graphics.newCanvas(WIDTH,HEIGHT)
    CANVASES.ships   = love.graphics.newCanvas(WIDTH,HEIGHT)
    CANVASES.border  = love.graphics.newCanvas(WIDTH,HEIGHT)
    printObjects(SOLAR_SYSTEM,CANVASES.planets)
    printObjects(SHIPS,CANVASES.ships)
    printBorderToCanvas(CANVASES.border)
    love.graphics.setCanvas()
end

--when player presses the 't' key
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


--set the player name and sell title in player object
local function setPlayerName()
    PLAYER.name        = PLAYER_NAME
    PLAYER.sell_title  = PLAYER.name .. " 's inventory:"
    PLAYER.sell_canvas = makeCanvas(PLAYER.sell_title)
    love.graphics.setCanvas(PLAYER.sell)
end

--get the player's name at start of game
local function getPlayerName()
    local title = "please enter name: "
    love.graphics.print(title,1,1)
    love.graphics.print(PLAYER_NAME,MAIN_FONT:getWidth(title) + 5,1)
end

--on each frame draw stuff
function love.draw(dt)
    if GAME_OVER == true then
        gameOver()
    elseif DRAW_SELL == true then
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

--handle mouse clicks
function love.mousepressed(x,y,button,_,_)
    if button == 1 and DRAW_TRADE == true then
        BOUGHT_STR = getInvItemFromClick(x,y,tradeItem)
    elseif button == 1 and DRAW_INV == true then
        BOUGHT_STR = getInvItemFromClick(x,y,upgradeShip)
    end
end

--takes text input. used to get player's name
function love.textinput(t)
    if GET_P_NAME == true then
        PLAYER_NAME = PLAYER_NAME .. t
    end
end

--handle key presses
function love.keypressed(_,scancode)
    --if player is entering their name and presses return then consider name complete
    if GET_P_NAME == true then
        if scancode == "return" then
            GET_P_NAME  = false
            DRAW_SPACE  = true
            setPlayerName()
            START_TIME  = love.timer.getTime()
        --if player hits backspace, delete char. code is copied directly from love2d wiki
        elseif scancode == "backspace" then
            -- get the byte offset to the last UTF-8 character in the string.
            local byteoffset = utf8.offset(PLAYER_NAME, -1)
            if byteoffset then
                -- remove the last UTF-8 character.
                -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
                PLAYER_NAME = string.sub(PLAYER_NAME, 1, byteoffset - 1)
            end
        end
    else
        if GAME_OVER == true and scancode == "escape" then
            love.event.quit()
        elseif scancode == "t" then
            ENGINE_SOUND:stop()
            playerPressedT()
        elseif scancode == "i" then
            ENGINE_SOUND:stop()
            DRAW_INV = not DRAW_INV
            DRAW_SPACE = not DRAW_SPACE
        elseif scancode == "escape" then  --if player presses escape then exit all menus and go back to space
            if DRAW_SELL == false then
                DRAW_INV   = false
                DRAW_TRADE = false
                DRAW_SPACE = true
            end
            DRAW_SELL = false
        end
    end
end

--update with each frame
function love.update(dt)
    --if player runs out of fuel or time
    if PLAYER.inv["Fuel"].quant <= 0 or TIME_LEFT <= 0 then
        GAME_OVER  = true
        DRAW_INV   = false
        DRAW_SPACE = false
        DRAW_TRADE = false
    else
        --if player is in open space and not a trade or inventory menu
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
    GET_P_NAME    = true        --true when player is entering thei name
    PLAYER_NAME   = ""          --hold player name
    GAME_OVER     = false       --is th game over
    MOVE_PLAYER   = false       --is the player ship moving 
    DRAW_TRADE    = false       --should trade screen be drawn
    DRAW_SPACE    = false       --should open space screen be drawn
    DRAW_INV      = false       --should inventory screen be drawn
    DRAW_SELL     = false       --should screen showing sold/bought be displayed
    BOUGHT_STR    = nil         --string to print after player buys/sells item
    LONGEST_LEN   = findLongestName() --length of the longest name in RARE_ITEMS
    SOLAR_SYSTEM  = makeSolarSystem()              --list of all planets
    SHIPS         = makeComputerShips(SOLAR_SYSTEM)   --list of non player controlled ships
    PLAYER        = makePlayerShip(SOLAR_SYSTEM)   --player ship
    printObjectsToCanvas()
    TRADE_PARTNER = PLAYER    --planet or ship plaayer is trading with. init to self to not be nil
    THRUSTER      = love.graphics.newImage("/img/effects/thrust.png")
    ENGINE_SOUND  = love.audio.newSource("/sounds/Engine.flac","static")
    PLAYER_SCORE  = 0
    TOTAL_TIME    = 360    --total time to play game until game_over
    TIME_LEFT     = TOTAL_TIME --time left til game over
    love.window.setTitle("Simple Space Explorer")
end

