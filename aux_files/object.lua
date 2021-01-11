--File contains functions for generateing and manipulating 'OBJECT' objects

local Items  = require("aux_files.items")

OBJECT = {
            name = nil, x = nil, y = nil, inv = nil, icon = nil, x_off = nil, y_off = nil,
            angle = nil,discovered = false, buy = nil,sell_canvas = nil, buy_canvas = nil
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
        love.graphics.print(inv_item.price,params[1] + (inv_item.name:len()) + 30 ,params[2])
    end
    params[2] = params[2] + 20
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

--prints inventory of the object to screen
function drawInventory(inv,inv_string,start_x,start_y,show_price)
    love.graphics.setNewFont(20)
    love.graphics.print(inv_string,start_x,start_y)
    love.graphics.setNewFont()
    local i = 1
    if inv ~= nil then
        iterateObjects(inv,{start_x + 4,start_y + 30,show_price},printInventoryItem)
        i = #inv
    end
    if love.keyboard.isScancodeDown("escape") then
        DRAW_INV   = false
        DRAW_TRADE = false
    end
    return i
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

local function makeCanvas(inv,title)
    local canvas = love.graphics.newCanvas(MAIN_FONT:getWidth(title .. "    "),WINDOW_HEIGHT)
    love.graphics.setCanvas(canvas)
    love.graphics.print(title,1,1)
    if inv ~= nil then
        for i=1,#inv,1 do
            love.graphics.print(inv[i].name,4,10 + 20 * i)
        end
    end
    love.graphics.setCanvas()
    return canvas
end

--make new OBJECT object
function OBJECT:new(icon,name,rand,add,max,solar_system,ships)
    self             = setmetatable({},OBJECT)
    self.x,self.y    = makeXY(rand,solar_system,ships)
    self.name        = name 
    self.inv         = makeInv(rand,add,max)
    self.icon        = icon 
    --set a random angle for the object to be at.
    self.angle       =  -3.14159 + rand() * 6.28318 
    self.x_off       = self.icon:getWidth() / 2
    self.y_off       = self.icon:getHeight() / 2
    self.buy         = makeBuyable(rand,add,max)
    self.buy_canvas  = makeCanvas(self.buy,self.name .. " is buying:")
    self.sell_canvas = makeCanvas(self.buy,self.name .. " is selling:")
    return self
end

--prints current object to screen
function OBJECT:print()
    love.graphics.print(self.name,self.x - self.x_off,self.y - self.y_off - 15) 
    love.graphics.draw(self.icon,self.x,self.y,self.angle,nil,nil,self.x_off,self.y_off)
end

--iterate over a list of Objects and call its print function
function printObjects(objs,canvas)
    love.graphics.setCanvas(canvas)
    for i=1,#objs,1 do
        objs[i]:print(player)
    end
end

