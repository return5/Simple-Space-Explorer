ITEM = {name = nil, func = nil, price = nil, quant = nil}
ITEM.__index = ITEM


function ITEM:new()
    local self = setmetatable({},ITEM)
    return self
end


function makePlanetItems()
    return ITEM:new()
end


function makeInv(rand,add)
    return ITEM:new()
end


