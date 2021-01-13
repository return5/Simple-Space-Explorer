--File contains functions for generateing and manipulating 'OBJECT' objects

local Items  = require("aux_files.items")

OBJECT = {
            name = nil, x = nil, y = nil, inv = nil, icon = nil, x_off = nil, y_off = nil,
            angle = nil,discovered = false, buy = nil,sell_canvas = nil, buy_canvas = nil,
            buy_title = nil,sell_title = nil,money
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
    if params.x > (object.x - 175) and params.x < (object.x + 175) then
        if params.y > (object.y - 175) and params.y < (object.y + 175) then
            return true
        end
    end
    return false
end


local function printInventoryItem(inv_item,params)
    love.graphics.print(inv_item.name,params[1],params[2])
    if params[3] == true then
        love.graphics.print(inv_item.price,params[1] + (MAIN_FONT:getWidth(inv_item.name)) + 10 ,params[2])
    end
    params[2] = params[2] + 20
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

--prints inventory of the object to canvas
local function drawInventory(inv,price,title)
    if inv ~= nil then
        love.graphics.setFont(LARGE_FONT)
        love.graphics.print(title,1,1)
        love.graphics.setFont(MAIN_FONT)
        iterateObjects(inv,{10,LARGE_FONT:getHeight() + 20,price},printInventoryItem)
    end
end

--make a new random x,y for an object
local function makeXY(rand,solar_system,ships)
    local x,y
    local check = checkIfOverlap
    repeat
        x = rand(1,WIDTH)
        y = rand(1,HEIGHT)
        local params = {x = x, y = y}
    until(iterateObjects(solar_system,params,check) == -1 and iterateObjects(ships,params,check) == -1)
    return x,y
end

local function makeCanvas(title)
    local canvas = love.graphics.newCanvas(LARGE_FONT:getWidth(title .. "    "),WINDOW_HEIGHT)
    return canvas
end

--make new OBJECT object
function OBJECT:new(icon,name,rand,add,min_sell,max_sell,min_buy,max_buy,solar_system,ships)
    local o       = setmetatable({},OBJECT)
    o.x,o.y       = makeXY(rand,solar_system,ships)
    o.name        = name 
    o.inv         = makeInv(rand,add,min_sell,max_sell)
    o.icon        = icon 
    --set a random angle for the object to be at.
    o.angle       =  -3.14159 + rand() * 6.28318 
    o.x_off       = o.icon:getWidth() / 2
    o.y_off       = o.icon:getHeight() / 2
    o.buy         = makeBuyable(rand,add,min_buy,max_buy)
    o.buy_title   = o.name .. " is buying:"
    o.sell_title  = o.name .. " is selling:"
    o.buy_canvas  = makeCanvas(o.buy_title)
    o.sell_canvas = makeCanvas(o.sell_title)
    o.money       = rand(200,2000)
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

--draws teh buy/sell canvas of an object
function drawObjectCanvas(inv,start_x,canvas,show_price,title)
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    drawInventory(inv,show_price,title)
    love.graphics.setCanvas()
    love.graphics.draw(canvas,start_x,1)
end


