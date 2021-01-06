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

--check to see if current name matches that of another planet
local function checkPlanetName(name,planet)
    if name == planet.name then
        return true
    else
        return false
    end
end

local function getPlanetIcon(rand)
    local i    = rand(1,38)
    local name = "/img/planets/planet_icon_" .. i ..".png"
    return love.graphics.newImage(name)
end

--check to see if current x,y matches that of another planet
local function checkPlanetXY(params,planet)
    if params.x > (planet.x - 175) and params.x < (planet.x + 175) then
        if params.y > (planet.y - 175) and params.y < (planet.y + 175) then
            return true
        end
    end
    return false
end

--loop through solar_system and check function against each planet
--params is a table of parameters, func is function to check against
local function checkPlanets(params,func)
    local cond = false
    for i=1,#SOLAR_SYSTEM,1 do
        cond = func(params,SOLAR_SYSTEM[i])
    end
    return cond
end

--get a unique x,y for a new planet
local function getPlanetXY(rand)
    local x,y
    repeat
        x = rand(0,WIDTH)
        y = rand(0,HEIGHT)
    until(checkPlanets({x = x,y = y},checkPlanetXY) == false)
    return x,y
end

--get a unique name for a new planet
local function getPlanetName(rand)
    local name
    repeat
        name = PLANET_NAMES[rand(1,#PLANET_NAMES)]
    until(checkPlanets({name},checkPlanetName) == false)
    return name
end

function PLANET:new(rand,add)
    local x,y   = getPlanetXY(rand)
    local name  = getPlanetName(rand) 
    local icon  = getPlanetIcon(rand)
    local o     = setmetatable(OBJECT:new(x,y,icon,name,rand,add,6),PLANET)
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


