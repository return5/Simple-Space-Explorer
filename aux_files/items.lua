ITEM = {}
ITEM.__index = ITEM


function ITEM:new()
    local self = setmetatable({},ITEM)
    return self
end


function makePlanetItems()
    return ITEM:new()
end


