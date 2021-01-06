local Items = require("aux_files.items")

PLANET = {name = nil, x = nil, y = nil, items = nil, icon = nil, x_off = nil, y_off = nil}
PLANET.__index = PLANET

local NAMES  = {
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


local function getPlanetIcon()
    local i    = math.random(1,38)
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
local function getPlanetXY()
    local rand = math.random
    local x,y
    repeat
        x = rand(0,WIDTH)
        y = rand(0,HEIGHT)
    until(checkPlanets({x = x,y = y},checkPlanetXY) == false)
    return x,y
end

--get a unique name for a new planet
local function getPlanetName()
    local rand = math.random
    local name
    repeat
        name = NAMES[rand(1,#NAMES)]
    until(checkPlanets({name},checkPlanetName) == false)
    return name
end


function PLANET:print()
    love.graphics.draw(self.icon,self.x,self.y,nil,nil,nil,self.x_off,self.y_off)
end

function printPlanets()
    for i=1,#SOLAR_SYSTEM,1 do
        SOLAR_SYSTEM[i]:print()
    end
end

function PLANET:new()
    local self    = setmetatable({},PLANET)
    self.x,self.y = getPlanetXY()
    self.name     = getPlanetName() 
    self.items    = makePlanetItems()
    self.icon     = getPlanetIcon()
    self.x_off    = self.icon:getWidth() / 2
    self.y_off    = self.icon:getHeight() / 2
    return self
end


function makeSolarSystem()
    local n       = math.random(5,#NAMES)
    local additem = table.insert
    for i=1,n,1 do
        additem(SOLAR_SYSTEM,PLANET:new())
    end
    return SOLAR_SYSTEM
end


