--File contains functions for generating and using ITEM objects

ITEM = {name = nil, func = nil, price = nil, quant = nil}
ITEM.__index = ITEM

--list of names for rare items
local RARE_ITEMS = {
                    "Mystery Box","E.T. Cartridge Game","Sonichu Medallion","Asperchu Medallion","Spock's Brain",
                    "Kurlan Naiskos","D.B Cooper's Frozen Head","Apple Newton","Bill Of Rights","Blood Source Code",
                    "Apolo 11 flag","Luke's Blue LightSaber"
                }

--Generate new ITEM object
function ITEM:new(name,func,price,quant)
    local o = setmetatable({},ITEM)
    o.name  = name
    o.func  = func
    o.price = price
    o.quant = quant
    return o
end

--player can buy fuel for their ship
function getFuel()
    --to do
end

--Make a Rare ITEM object
function makeRareItem(rand)
    local i = rand(1,#RARE_ITEMS)
    return ITEM:new(RARE_ITEMS[i],nil,rand(200,800),1)
end

function makeAllRareItems(rand)
    local inv = {}
    for i=1,#RARE_ITEMS,1 do
        inv[RARE_ITEMS[i]] = ITEM:new(RARE_ITEMS[i],nil,rand(200,300),1)
    end
    return inv
end


--Player can upgrade their ship's weapon
local function upgradeWeapon(name)
    local weapon
    if name == "Weapon I" and PLAYER.attk < 11 then
         weapon = 10
    elseif name == "Weapon II"  and PLAYER.attk < 21 then
        if PLAYER.attk < 15 then
            PLAYER.attk = 15
        end
         weapon = 15
    elseif name == "Wapon III" and PLAYER.attk < 35 then
        if PLAYER.attk < 30 then
            PLAYER.attk = 30
        end
        weapon =  20
    else
        return string.format("%s wasn't able to upgrade their weapons",PLAYER.name),false
    end
    local prev_weapon = PLAYER.attk
    PLAYER.attk = PLAYER.attk + weapon
    return string.format("%s upgraded their weapon from %d to %d",PLAYER.name,prev_weapon,PLAYER.attk),true
end

--sets the price of weapon upgrades.
local function setWeaponPrice(rand,name)
    local min,max
    if name == "Weapon I" then
        min = 120
        max = 215
    elseif name == "Weapon II" then
        min = 215
        max = 315
    else
        min = 315
        max = 450
    end
    return rand(min,max)
end

--MAke a upgrade weapon ITEM object
local function makeUpgradedWeapon(rand)
    local n = rand(0,16)
    local name
    if n < 8 then
        name = "Weapon I"
    elseif n < 13 then
        name = "Weapon II"
    else
        name = "Weapon III"
    end
    local price = setWeaponPrice(rand,name)
    return ITEM:new(name,upgradeWeapon,price,1)
end

--Player can upgrade their ship's hull
local function upgradeHull(name)
    local hull
    if name == "Hull I"  and PLAYER.hull < 151 then
        hull = 50
    elseif name == "Hull II" and PLAYER.hull < 201 then
        if PLAYER.hull < 120 then
            PLAYER.hull = 120
        end
        hull = 75
    elseif name == "Hull III" and PLAYER.hull < 276 then
        if PLAYER.hull < 195 then
            PLAYER.hull = 195
        end
        hull = 110
    else
        return string.format("%s wasn't able to upgrade their hull.",PLAYER.name),false
    end
    local prev_hull = PLAYER.hull
    PLAYER.hull = PLAYER.hull + hull
    return string.format("%s upgraded their hull from %d to %d",PLAYER,name,prev_hull,PLAYER.hull),true
end

--Set the price of hull upgrade ITEM objects
local function setHullPrice(rand,name)
    local min,max
    if name == "Hull I" then
        min = 150
        max = 275
    elseif name == "Hull II" then
        min = 275
        max = 425
    else
        min = 475
        max = 650
    end
    return rand(min,max)
end

--Generate a hull upgrade ITEM object
local function makeUpgradedHull(rand)
    local n = rand(0,16)
    local name
    if n < 8 then
        name = "Hull I"
    elseif n < 13 then
        name = "Hull II"
    else
        name = "Hull III"
    end
    local price = setHullPrice(rand,name)
    return ITEM:new(name,upgradeHull,price,1)
end

--Player can upgrade thier engine
local function upgradeEngine(name)
    local speed
    if name == "Engine I"  and PLAYER.speed < 111 then
        speed = 50
    elseif name == "Engine II" and PLAYER.speed < 161 then
        if PLAYER.speed < 120 then
            PLAYER.speed = 120
        end
        speed = 75 
    elseif name == "Engine III" and PLAYER.speed < 236 then
        if PLAYER.speed < 195 then
            PLAYER.speed = 195
        end
        speed = 110
    else
        return string.format("%s wasn't able to upgrade their engines",PLAYER.name),false
    end
    local prev_speed = PLAYER.speed
    PLAYER.speed = PLAYER.speed + speed
    return string.format("%s upgraded their engines from %d to %d",PLAYER.name,prev_speed,PLAYER.speed),true
end

--Set the price of an engine upgrade object
local function setEnginePrice(rand,name)
    local min,max
    if name == "Engine I" then
        min = 100
        max = 250
    elseif name == "Engine II" then
        min = 250
        max = 375
    else
        min = 450
        max = 600
    end
    return rand(min,max)
end

--generate a new upgrade engine ITEM object
local function makeUpgradedEngine(rand)
    local n = rand(0,16)
    local name
    if n < 8 then
        name = "Engine I"
    elseif n < 13 then
        name = "Engine II"
    else
        name = "Engine III"
    end
    local price = setEnginePrice(rand,name)
    return ITEM:new(name,upgradeEngine,price,1)
end

function makeFuel(rand)
    local quant = rand(40,240)
    local name  = "Fuel"
    local price = rand(1,15)
    return ITEM:new(name,getFuel,price,quant)
end

--update the number of and item in inventory
local function updateQuantity(inv,item)
    inv[item.name].quant = inv[item.name].quant + item.quant
end

--Randomly select a new ITEM object to create
function getRandItem(rand)
   local n = rand(0,22)
   if n < 5 then
       return makeUpgradedEngine(rand)
   elseif n < 10 then
       return makeUpgradedHull(rand)
   elseif n < 15 then
       return makeUpgradedWeapon(rand)
   elseif n < 20 then
       return makeFuel(rand)
   else
       return makeRareItem(rand)
   end
end

--Make the inventory for an OBJECT
function makeInv(rand,add,min,max,func)
    local n         = rand(min,max)
    local inv       = {}
    local upquant   = updateQuantity
    for i=1,n,1 do
        local item = func(rand)
        if inv[item.name] ~= nil then 
            upquant(inv,item)
        else
            inv[item.name] = item
        end
    end
    return inv
end

