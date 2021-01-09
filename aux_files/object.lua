--File contains functions for generateing and manipulating 'OBJECT' objects

local Items  = require("aux_files.items")

OBJECT = {name = nil, x = nil, y = nil, inv = nil, icon = nil, x_off = nil, y_off = nil,angle = nil,discovered = false, buy = nil}
OBJECT.__index = OBJECT


--checks if player ship is touching the object
function checkIfPlayerIsTouching(obj,player)
    if player.x < obj.x + obj.x_off and player.x >= obj.x then
        if player.y < obj.y + obj.y_off and player.y >= obj.y then
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

local function printInventoryItem(inv_item,loc)
    love.graphics.print(inv_item.name,22,loc[1])
    loc[1] = loc[1] + 20
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
function drawInventory(obj)
    love.graphics.setNewFont(20)
    love.graphics.print(obj.name .. "'s inventory:",4,1)
    love.graphics.setNewFont()
    local i = 1
    if obj.inv ~= nil then
        iterateObjects(obj.inv,{30},printInventoryItem)
        i = #obj.inv
    end
    love.graphics.print("press esc to exit.", 4, 10 + 20 * (i + 1))
    if love.keyboard.isScancodeDown("escape") then
        DRAW_INV   = false
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

--make new OBJECT object
function OBJECT:new(icon,name,rand,add,max,solar_system,ships)
    self           = setmetatable({},OBJECT)
    self.x,self.y  = makeXY(rand,solar_system,ships)
    self.name      = name 
    self.inv       = makeInv(rand,add,max)
    self.icon      = icon 
    --set a random angle for the object to be at.
    self.angle     =  -3.14159 + rand() * 6.28318 
    self.x_off     = self.icon:getWidth() / 2
    self.y_off     = self.icon:getHeight() / 2
    self.buy       = makeBuyable(rand,add,max)
    return self
end

--checks to see if current object is visible to the plaer
local function checkIfVisible(player,obj)
    if obj.y < player.y + HALF_H  and obj.y > player.y - HALF_H then
        if obj.x < player.x + HALF_W  and obj.x > player.x - HALF_W  then
            return true
        end
    end
    return false
end

--prints current object to screen
function OBJECT:print(player)
    --only print items which are visible or the player's ship
    if player == nil or checkIfVisible(player,self) == true then
        love.graphics.print(self.name,self.x - self.x_off,self.y - self.y_off - 15) 
        love.graphics.draw(self.icon,self.x,self.y,self.angle,nil,nil,self.x_off,self.y_off)
        if self.discovered == false then
            self.discovered = true
        end
    end
end

--iterate over a list of Objects and call its print function
function printObjects(objs,player)
    for i=1,#objs,1 do
        objs[i]:print(player)
    end
end

