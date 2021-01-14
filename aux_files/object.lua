--File contains functions for generateing and manipulating 'OBJECT' objects

local Items  = require("aux_files.items")

OBJECT = {
            name = nil, x = nil, y = nil, inv = nil, icon = nil, x_off = nil, y_off = nil,
            angle = nil,discovered = nil, buy = nil,sell_canvas = nil, buy_canvas = nil,
            buy_title = nil,sell_title = nil,money = nil, sell_order = nil, buy_order = nil
        }
OBJECT.__index = OBJECT


--checks if player ship is touching the object
function checkIfPlayerIsTouching(obj,player)
    if player.x < obj.x + obj.x_off and player.x >= obj.x  - obj.x_off then
        if player.y < obj.y + obj.y_off and player.y >= obj.y - obj.y_off then
            return true
        end
    end
    return false
end

--make sure obj's x,y arnt too close to edge of map
local function checkDist(x,y)
    if x < 35 or x > WIDTH - 35 then
        return false
    end
    if y < 35 or y > HEIGHT - 35 then
        return false
    end
    return true
end

--checks to see if current name matches that of obj
function checkName(obj,params)
    if params.name == obj.name then
        return true
    else
        return false
    end
end

--check to see if current x,y matches that of another object
function checkIfOverlap(object,params)
    if params.x > (object.x - 210) and params.x < (object.x + 210) then
        if params.y > (object.y - 210) and params.y < (object.y + 210) then
            return true
        end
    end
    return false
end

--print given inv item to the canvas currently set
local function printInventoryItem(inv_item,params)
    love.graphics.setFont(MAIN_FONT)
    love.graphics.print(inv_item.name,params[1],params[2])
    if params[3] == true then
        love.graphics.print(inv_item.price,params[1] + (MAIN_FONT:getWidth(inv_item.name)) + 10 ,params[2])
    end
    params[2] = params[2] + 20
    params[4][#params[4] + 1] = inv_item.name
    return false
end

--iterate over a list of objects. call func on each item, if that function returns true then return true from here
function iterateObjects(objects,params,func)
    if objects ~= nil then
        for i=1,#objects,1 do
            if func(objects[i],params) == true then
                return i
            end
        end
    end
    return -1
end

--iterate over provided inventory. call func with each inv item
local function iterateInventory(inv,params,func)
    if inv ~= nil then
        for _,v in pairs(inv) do
            func(v,params)
        end
    end
    return -1
end

--prints inventory of the object to canvas
local function drawInventory(inv,price,title,order)
    if inv ~= nil then
        love.graphics.setFont(LARGE_FONT)
        love.graphics.print(title,1,1)
        love.graphics.setFont(MAIN_FONT)
        iterateInventory(inv,{10,LARGE_FONT:getHeight() + 20,price,order},printInventoryItem)
    end
end

--make a new random x,y for an object
local function makeXY(rand,solar_system,ships)
    local check   = checkIfOverlap
    local iterate = iterateObjects
    local dist    = checkDist
    local params  = {x = nil, y = nil}
    repeat
        params.x = rand(1,WIDTH)
        params.y = rand(1,HEIGHT)
    until(iterate(solar_system,params,check) == -1 and iterate(ships,params,check) == -1 and dist(params.x,params.y) == true)
    return params.x,params.y
end

--make a new canvas
function makeCanvas(title)
    local len_title = LARGE_FONT:getWidth(title .. "   ")
    --get which is longer, the length of title or length of lonest rare item name
    local length    = len_title > LONGEST_LEN and len_title or LONGEST_LEN
    local canvas    = love.graphics.newCanvas(length,WINDOW_HEIGHT)
    return canvas
end

--make new OBJECT object
function OBJECT:new(icon,name,rand,add,min_item,max_item,min_buy,max_buy)
    local o       = setmetatable({},OBJECT)
    o.x,o.y       = makeXY(rand,SOLAR_SYSTEM,SHIPS)
    o.name        = name 
    o.icon        = icon 
    o.discovered  = false

    --set a random angle for the object to be at.
    o.angle       =  -3.14159 + rand() * 6.28318 
    o.x_off       = o.icon:getWidth() / 2
    o.y_off       = o.icon:getHeight() / 2
    o.buy         = makeInv(rand,add,min_buy,max_buy,makeRareItem)
    o.buy_title   = o.name .. " is buying:"
    o.sell_title  = o.name .. " is selling:"
    o.buy_canvas  = makeCanvas(o.buy_title)
    o.sell_canvas = makeCanvas(o.sell_title)
    o.money       = rand(200,2000)
    o.inv         = makeInv(rand,add,min_item,max_item,getRandItem)
    o.sell_order  = {}
    o.buy_order   = {}
    return o
end

--prints current object to screen
function OBJECT:print()
    love.graphics.draw(self.icon,self.x,self.y,self.angle,nil,nil,self.x_off,self.y_off)
    love.graphics.print(self.name,self.x - self.x_off,self.y - self.y_off - 15) 
end

--iterate over a list of Objects and call its print function
function printObjects(objs,canvas)
    love.graphics.setCanvas(canvas)
    for i=1,#objs,1 do
        objs[i]:print()
    end
    love.graphics.setCanvas()
end

--draws the buy/sell canvas of an object
function drawInvCanvas(obj,start_x,is_player,show_price)
    love.graphics.setCanvas(obj.sell_canvas)
    love.graphics.clear()
    obj.sell_order = {}
    drawInventory(obj.inv,show_price,obj.sell_title,obj.sell_order)
    love.graphics.print(obj.name .. "'s money is: " .. obj.money,5, LARGE_FONT:getHeight() + 10 + 20 * (#obj.sell_order + 1))
    if is_player == false then
        love.graphics.setCanvas(obj.buy_canvas)
        love.graphics.clear()
        obj.buy_order = {}
        drawInventory(obj.buy,show_price,obj.buy_title,obj.buy_order)
    end
    love.graphics.setCanvas()
    love.graphics.draw(obj.sell_canvas,start_x,1)
    love.graphics.draw(obj.buy_canvas,start_x + obj.sell_canvas:getWidth() + 20,1)
end


