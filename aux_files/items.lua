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
local function upgradeWeapon(name,print_str)
    if print_str == nil then
        print_str = true
    end
    local weapon
    if name == "Weapon I" and PLAYER.attk_level < 1 then
         weapon = PLAYER.attk / 4
         PLAYER.attk_level = 1
    elseif name == "Weapon II"  and PLAYER.attk_level < 2 then
        if PLAYER.attk_level < 2 then
            upgradeWeapon("Weapon I",false)
        end
         weapon = PLAYER.attk / 3
         PLAYER.attk_level = 2
    elseif name == "Weapon III" and PLAYER.attk_level < 3 then
        if PLAYER.attk_level < 2 then
            upgradeWeapon("Weapon II",false)
        end
         weapon = PLAYER.attk / 2
         PLAYER.attk_level = 3
    else
        return string.format("%s wasn't able to upgrade their weapons",PLAYER.name),false
    end
    local prev_weapon = PLAYER.attk
    PLAYER.attk = PLAYER.attk + weapon
    return string.format("%s upgraded their weapon from %d to %d",PLAYER.name,prev_weapon,PLAYER.attk),print_str
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
    local n = rand(0,12)
    local name
    if n < 8 then
        name = "Weapon I"
    elseif n < 12 then
        name = "Weapon II"
    else
        name = "Weapon III"
    end
    local price = setWeaponPrice(rand,name)
    return ITEM:new(name,upgradeWeapon,price,1)
end

--Player can upgrade their ship's hull
local function upgradeHull(name,print_str)
    local hull
    if print_str == nil then
        print_str = true
    end
    if name == "Hull I"  and PLAYER.hull_level < 1 then
        hull = PLAYER.hull / 4
        PLAYER.hull_level = 1
    elseif name == "Hull II" and PLAYER.hull_level < 2 then
        if PLAYER.hull_level < 1 then
            upgradeHull("Hull I",false)
        end
        hull = PLAYER.hull / 3
        PLAYER.hull_level = 2
    elseif name == "Hull III" and PLAYER.hull_level < 3 then
        if PLAYER.hull_level < 2 then
            upgradeHull("Hull II",false)
        end
        hull = PLAYER.hull / 2
        PLAYER.hull_level = 3
    else
        return string.format("%s wasn't able to upgrade their hull.",PLAYER.name),false
    end
    local prev_hull = PLAYER.hull
    PLAYER.hull = PLAYER.hull + hull
    return string.format("%s upgraded their hull from %d to %d",PLAYER.name,prev_hull,PLAYER.hull),print_str
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
    local n = rand(0,12)
    local name
    if n < 8 then
        name = "Hull I"
    elseif n < 12 then
        name = "Hull II"
    else
        name = "Hull III"
    end
    local price = setHullPrice(rand,name)
    return ITEM:new(name,upgradeHull,price,1)
end

--Player can upgrade thier engine
local function upgradeEngine(name,print_str)
    if print_str == nil then
        print_str = true
    end
    local speed
    if name == "Engine I"  and PLAYER.engine_level < 1 then
        speed = PLAYER.speed / 4
        PLAYER.engine_level = 1
    elseif name == "Engine II" and PLAYER.engine_level < 2 then
        if PLAYER.engine_level < 1 then
            upgradeEngine("Engine I",false)
        end
        speed = PLAYER.speed / 3
        PLAYER.engine_level = 2
    elseif name == "Engine III" and PLAYER.engine_level < 3 then
        if PLAYER.engine_level < 2 then
            upgradeEngine("Engine II",false)
        end
        speed = PLAYER.speed / 2
        PLAYER.engine_level = 3
    else
        return string.format("%s wasn't able to upgrade their engines",PLAYER.name),false
    end
    local prev_speed = PLAYER.speed
    PLAYER.speed = PLAYER.speed + speed
    return string.format("%s upgraded their engines from %d to %d",PLAYER.name,prev_speed,PLAYER.speed),print_str
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
    local n = rand(0,12)
    local name
    if n < 8 then
        name = "Engine I"
    elseif n < 12 then
        name = "Engine II"
    else
        name = "Engine III"
    end
    local price = setEnginePrice(rand,name)
    return ITEM:new(name,upgradeEngine,price,1)
end

function makeFuel(rand,min,max)
    local quant = rand(min,max)
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
   local n = rand(0,16)
   if n < 5 then
       return makeUpgradedEngine(rand)
   elseif n < 10 then
       return makeUpgradedHull(rand)
   elseif n < 15 then
       return makeUpgradedWeapon(rand)
   else
       return makeRareItem(rand)
   end
end

function addItem(inv,item,quant)
    if inv[item.name] ~= nil then
        inv[item.name].quant = inv[item.name].quant + quant
    else
        inv[item.name] = item
    end
end

function removeItem(inv,item,quant)
    if inv[item.name].quant <= quant then
        inv[item.name] = nil
    else
        inv[item.name].quant = inv[item.name].quant - quant
    end
end

--Make the inventory for an OBJECT
function makeInv(rand,add,min,max,func)
    local n         = rand(min,max)
    local inv       = {}
    local additem   = addItem
    for i=1,n,1 do
        local item = func(rand)
        additem(inv,item,item.quant)
    end
       additem(inv,makeFuel(rand,10,400))
    return inv
end

function makeplayerinv()
    local inv = {}
    inv["Weapon III"] = ITEM:new("Weapon III",upgradeWeapon,1,1)
    inv["Hull III"] = ITEM:new("Hull III",upgradeHull,1,1)
    inv["Engine III"] = ITEM:new("Engine III",upgradeEngine,1,1)
    return inv
end
