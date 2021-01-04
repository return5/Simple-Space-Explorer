ITEM = {}
ITEM.__index = ITEM


function ITEM:new()
    local self = setmettable({},ITEM)
    return self
end


function makePlanetItems()
    return ITEM:new()
end


