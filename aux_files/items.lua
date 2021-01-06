ITEM = {name = nil, func = nil, price = nil, quant = nil}
ITEM.__index = ITEM

local RARE_ITEMS = {"Mystery Box","E.T. Cartridge Game","Sonichu Medallion","Asperchu Medallion","Spock's Brain","Kurlan Naiskos","D.B Cooper's Frozen Head","Apple Newton","Bill Of Rights","Blood Source Code","Apolo 11 flag","Luke's Blue LightSaber"}


function ITEM:new(name,func,price,quant)
    local self = setmetatable({},ITEM)
    self.name  = name
    self.func  = func
    self.price = price
    self.quant = quant
    return self
end

local function makeRareItem(rand)
    local i = rand(1,#RARE_ITEMS)
    return ITEM:new(RARE_ITEMS[i],nil,rand(200,800),1)
end

local function upgradeWeapon(name,player)
    local weapon
    if name == "Weapon I" and player.attk < 11 then
        player.attk =  player.attk + 10
    elseif name == "Weapon II"  and player.attk < 21 then
        if player.attk < 15 then
            player.attk = 15
        end
        player.attk = player.attk + 15
    elseif name == "Wapon III" and player.attk < 35 then
        if player.attk < 30 then
            player.attk = 30
        end
        player.attk = player.attk + 20
    else
        return false
    end
    return true
end

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

local function upgradeHull(name,player)
    local hull
    if name == "Hull I"  and player.hull < 151 then
        player.hull = player.hull + 50
    elseif name == "Hull II" and player.hull < 201 then
        if player.hull < 120 then
            player.hull = 120
        end
        player.hull = player.hull + 75
    elseif name == "Hull III" and player.hull < 276 then
        if player.hull < 195 then
            player.hull = 195
        end
        player.hull = player.hull + 100
    else
        return false
    end
    return true
end

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

local function upgradeEngine(name,player)
    local speed
    if name == "Engine I"  and player.speed < 111 then
        player.speed = player.speed + 50
    elseif name == "Engine II" and player.speed < 161 then
        if player.speed < 120 then
            player.speed = 120
        end
        player.speed = player.speed + 75 
    elseif name == "Engine III" and player.speed < 236 then
        if player.speed < 195 then
            player.speed = 195
        end
        player.speed = player.speed + 100
    else
        return false
    end
    return true
end

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

local function updateQuantity(i,item,inv)
    inv[i].quant = inv[i].quant + item.quant
end

local function checkForItem(item,inv)
    for i=1,#inv,1 do
        if inv[i].name == item.name then
            return i
        end
    end
    return -1
end

local function getRandItem(rand)
   local n = rand(0,17)
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

function makeInv(rand,add,max)
    local n         = rand(0,max)
    local inv       = {}
    local checkitem = checkForItem
    local upquant   = updateQuantity
    local getRand   = getRandItem
    for i=1,n,1 do
        local item = getRand(rand)
        local i    = checkitem(item,inv)
        if i == -1 then
            add(inv,item)
        else
            upquant(i,item,inv)
        end
    end
    return inv
end

function playerUpgradeShip(i,player)
    if player.inv[i] ~= nil and player.inv[i].quant > 0 then
        if player.inv[i].func(player.inv[i].name,player) == true then
            player.inv[i].quant = player.inv[i].quant - 1
            if player.inv[i].quant <= 0 then
                player.inv[i] = nil
            end
        end
    end
end


