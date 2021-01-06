local Items  = require("aux_files.items")

OBJECT = {name = nil, x = nil, y = nil, inv = nil, icon = nil, x_off = nil, y_off = nil,angle = nil,discovered = false}
OBJECT.__index = OBJECT



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

function iterateObjects(objects,params,func)
    if objects ~= nil then
        for i=1,#objects,1 do
            if func(objects[i],params) == true then
                return true
            end
        end
    end
    return false
end

local function makeXY(rand,solar_system,ships)
    local x,y
    local check = checkIfOverlap
    repeat
        x = rand(1,WIDTH)
        y = rand(1,HEIGHT)
        local params = {x = x, y = y}
    until(iterateObjects(solar_system,params,check) == false and iterateObjects(ships,params,check) == false)
    return x,y
end

function OBJECT:new(icon,name,rand,add,max,solar_system,ships)
    self           = setmetatable({},OBJECT)
    self.x,self.y  = makeXY(rand,solar_system,ships)
    self.name      = name 
    self.inv       = makeInv(rand,add,max)
    self.icon      = icon 
    self.x_off     = self.icon:getWidth() / 2
    self.y_off     = self.icon:getHeight() / 2
    return self
end

local function checkIfVisible(player,obj)
    if obj.y < player.y + HALF_H  and obj.y > player.y - HALF_H then
        if obj.x < player.x + HALF_W  and obj.x > player.x - HALF_W  then
            return true
        end
    end
    return false
end

function OBJECT:print(player)
    if player == nil or checkIfVisible(player,self) == true then
        love.graphics.print(self.name,self.x - self.x_off,self.y - self.y_off - 15) 
        love.graphics.draw(self.icon,self.x,self.y,self.angle,nil,nil,self.x_off,self.y_off)
        if self.discovered == false then
            self.discovered = true
        end
    end
end

function printObjects(objs,player)
    for i=1,#objs,1 do
        objs[i]:print(player)
    end
end

