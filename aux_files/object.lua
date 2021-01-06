local Items  = require("aux_files.items")

OBJECT = {name = nil, x = nil, y = nil, items = nil, icon = nil, x_off = nil, y_off = nil,angle = nil,discovered = false}
OBJECT.__index = OBJECT


function OBJECT:new(x,y,icon,name,rand,add,max)
    self        = setmetatable({},OBJECT)
    self.x      = x
    self.y      = y
    self.name   = name 
    self.items  = makeInv(rand,add,max)
    self.icon   = icon 
    self.x_off  = self.icon:getWidth() / 2
    self.y_off  = self.icon:getHeight() / 2
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

