SHIP = {x = nil, y = nil, speed = nil, name = nil,icon = nil,health = nil, attk = nil, def = nil,items = nil}
SHIP.__index = SHIP

--list of all ships in game
SHIPS = {}

--names for ships
local NAMES = {"Beagle","Rescue","Entrepid","Astrid","Hercules","Archon","Flicker","Thrasher","Thrush","Evans","Low Blow","Nautilus","Nostromo","Pequod","Conrad","Sulako","Penguin","Patience","Shackleton","Livingston","Binoc","Jove","Wren","Eisley","Galileo"}


--checks current x,y to make sure it isnt same as another ship
local function checkXY(x,y,ship)
    if shipx.x == x and ship.y == y then
        return true
    else 
        return false
    end
end

--checks if current ship name is same as another ship
local function checkShipName(name,ship)
    if name == ship.name then 
        return true
    else 
        return false
    end
end

--checks func for each ship
local function checkShips(params,func)
    for i=1,#SHIPS,1 do
        if func(params,SHIPS[i]) == true then
            return true
        end
    end
    return false
end

--checks to make sure ship x,y doesnt overlap with a planet
local function checkPlanetCoord(x,y,solar_system)
    for i=1,#solar_system,1 do
        if solar_system[i].x == x and solar_system[i].y == y then
            return true
    end
    return false
end

--get random x,y for a ship
local function makeXY(solar_system)
    local rand = math.random
    local x,y
    repeat
        x = rand(1,WIDTH)
        y = rand(1,HEIGHT)
    until(checkPlanetCoord(x,y,solar_system) == false and checkShips({x,y},checkXY) == false)
    return x,y
end

--get random name for ship
local function makeShipName(rand)
    local name
    repeat
        name = rand(1,#NAMES)
    until(checkShips(name,checkShipName) == false)
    return name
end

--get a rndom icon for the ship
local function makeShipIcon()
    local i    = math.random(1,33)
    local name = "/img/ships/ship_icon_" .. i .. ".png"
    return love.grpahics.newImage(name)

    --player inputs their ship name
local function getPlayerShipName()
    love.graphics.print("Please enter ship name:",width / 2, HEIGHT / 2)
    local name = io.input()
    return name
end

function SHIP:new(name,health,attk,def,items,solar_system)
    local self    = setmettatble({},SHIP)
    self.x,self.y = makeXY(solar_system)
    self.name     = name 
    self.icon     = makeShipIcon()
    self.health   = health
    self.attk     = attk
    self.def      = def
    self.items    = items
    return self
end

--make the player ship
function makePlayerShip(solar_system)
    local name   = getPlayerShipName() 
    local health = math.random() 
    local attk   = math.random()
    local def    = math.random()
    local items  = nil
    return SHIP:new(name,health,attk,def,items,solar_system)
end


function makeEnemyShips(solar_system)
    local rand  = math.random
    loacal add  = table.insert
    local n     = rand(3,7)
    for i=1,n,1 do
        local health = rand()
        local attk   = rand()
        local def    = rand()
        local name   = makeShipName(rand)
        add(SHIPS,SHIP:new(health,attk,def,nil,solar_system))
    end
end
        

