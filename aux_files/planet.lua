local Object = require("aux_files.object")

--list of all planets
local SOLAR_SYSTEM = {}
PLANET = {}
PLANET.__index = PLANET
setmetatable(PLANET,OBJECT)

--names for the planets
local PLANET_NAMES  = {
                "Bob","Omicron 8","Tyroid","Perseus 4","Wisseau","Amina","Klandathu","Sigma 7","Decument",
                "Kelvar","Romulax","Hellena","Ariax","Nilmen","Collosix","Naliux","Sirux","Watermux","Neptunia",
                "Posidia","Ares 5","Ki-pi","Marchus","Hannux"
            }


--get a random icon for the planet
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
    until(iterateObjects(SOLAR_SYSTEM,{name = name},checkName) == -1)
    return name
end

--make new planet object
function PLANET:new(rand,add)
    local name  = getPlanetName(rand) 
    local icon  = getPlanetIcon(rand)
    local o     = setmetatable(OBJECT:new(icon,name,rand,add,2,8,3,10),PLANET)
    addItem(o.inv,makeFuel(rand,600,2300))
    return o
end

--make a list of planets for game
function makeSolarSystem()
    local rand    = math.random
    local n       = rand(15,#PLANET_NAMES)
    local additem = table.insert
    for i=1,n,1 do
        additem(SOLAR_SYSTEM,PLANET:new(rand,additem))
    end
    return SOLAR_SYSTEM
end

