local Object = require("aux_files.object")

PLANET = {}
PLANET.__index = PLANET
setmetatable(PLANET,OBJECT)

local PLANET_NAMES  = {
                "Bob","Omicron 8","Tyroid","Persus 4","Wisseau","Amina","Klandathu","Sigma 7","Decument",
                "Kelvar","Romulax","Hellena","Ariax","Nilmen","Collosix","Naliux","Sirux","Watermux","Neptunia",
                "Posidia","Ares 5","Ki-pi","Marchus","Hannux",""
            }

local SOLAR_SYSTEM = {}

local function getPlanetIcon(rand)
    local i    = rand(1,38)
    local name = "/img/planets/planet_icon_" .. i ..".png"
    return love.graphics.newImage(name)
end

--get a unique name for a new planet
local function getPlanetName(rand)
    local name
    repeat
        name = PLANET_NAMES[rand(1,#PLANET_NAMES)]
    until(iterateObjects(SOLAR_SYSTEM,{name = name},checkName) == false)
    return name
end

function PLANET:new(rand,add)
    local name  = getPlanetName(rand) 
    local icon  = getPlanetIcon(rand)
    local o     = setmetatable(OBJECT:new(icon,name,rand,add,6,SOLAR_SYSTEM,nil),PLANET)
    return o
end

function makeSolarSystem()
    local rand    = math.random
    local n       = rand(15,#PLANET_NAMES)
    local additem = table.insert
    for i=1,n,1 do
        additem(SOLAR_SYSTEM,PLANET:new(rand,additem))
    end
    return SOLAR_SYSTEM
end


