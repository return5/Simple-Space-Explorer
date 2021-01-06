local Object = require("aux_files.object")

SHIP = { speed = nil, attk = nil, def = nil,hostile = nil}
SHIP.__index = SHIP
setmetatable(SHIP,OBJECT)

--list of all ships in game
local SHIPS = {}

--names for ships
local SHIP_NAMES = {
                "Beagle","Rescue","Entrepid","Astrid","Hercules","Archon","Flicker","Thrasher","Thrush","Evans","Fong","Nautilus","Nostromo","Pequod",
                "Conrad","Sulako","Penguin","Patience","Shackleton","Livingston","Binoc","Jove","Wren","Eisley","Galileo","Excalibre","Excelsior","Cardigan",
                "Parssons","Constitution","Reliant","Junko","Cardinal","Bishop","Prince","Earl","Duke","Mockingbird","Contagion","Regent"
            }

--get random name for ship
local function makeShipName(rand)
    local name
    repeat
        name = SHIP_NAMES[rand(1,#SHIP_NAMES)]
    until(iterateObjects(SHIPS,{name = name},checkName) == false)
    return name
end

--get a rndom icon for the ship
local function makeShipIcon(rand)
    local i    = rand(1,34)
    local name = "/img/ships/ship_icon_" .. i .. ".png"
    return love.graphics.newImage(name)
end

    --player inputs their ship name
local function getPlayerShipName()
    love.graphics.print("Please enter ship name:",WIDTH / 2, HEIGHT / 2)
    local name = io.input()
    return name
end

function SHIP:new(name,attk,hull,money,solar_system,rand,add)
    local name = name 
    local icon = makeShipIcon(rand)
    local o    = setmetatable(OBJECT:new(icon,name,rand,add,3,solar_system,ships),SHIP)
    o.attk     = attk
    o.hull     = hull
    o.items    = items
    o.money    = money
    o.speed    = rand(70,110)
    o.hostile  = rand(0,10) < 6 and false or true
    o.angle    =  -3.14 + math.random() * (3.14 * 2) 
    return o
end

--make the player ship
function makePlayerShip(solar_system)
    local rand   = math.random
    local name   = "return5"--getPlayerShipName() 
    local attk   = rand(5,10)
    local hull   = rand(70,150)
    local money  = rand(200,600)
    local ship   = SHIP:new(name,attk,hull,money,solar_system,rand,table.insert)
    ship.inv     = nil
    return ship
end

function makeEnemyShips(solar_system)
    local rand  = math.random
    local add   = table.insert
    local n     = rand(5,#SHIP_NAMES / 2)
    for i=1,n,1 do
        local attk   = rand(2,15)
        local hull   = rand(45,200)
        local name   = makeShipName(rand)
        local money  = rand(300,800)
        local ship   = SHIP:new(name,attk,hull,money,solar_system,rand,add)
        add(SHIPS,ship)
    end
    return SHIPS
end
        

