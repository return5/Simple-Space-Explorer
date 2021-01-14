--File contains function for trading between player and other ships or planets



function sellScreen()
    love.graphics.setCanvas()
    love.graphics.print(BOUGHT_STR,1,1)
    love.graphics.print("press escape to exit.",1,MAIN_FONT:getHeight() * 2 + 10)
end

local function buyFuel(inv,price)
    local quant
    if inv["Fuel"].quant < 25 then
        quant = inv["Fuel"].quant
        price = price / (25 - quant)
    else
        quant = 25
    end
    return string.format("%d Fuel",quant),price,quant
end

--player or ship successfully sold an item
local function successSellItem(buyer,seller,i,price)
    local name  = seller.inv[i].name
    local quant = 1
    if i == "Fuel" then
        name,price,quant = buyFuel(seller.inv,price) 
    end 
    local str    = string.format("%s bought %s for %d space dollars.",buyer.name,name,price)
    buyer.money  = buyer.money - price
    seller.money = seller.money + price
    addItem(buyer.inv,seller.inv[i],quant)
    buyer.inv[i].price = price
    removeItem(seller.inv,seller.inv[i],quant)
    return str
end

--player or ship/planet sells an item
local function sellItem(buyer,seller,name,price)
    if buyer.money >= price then
        return successSellItem(buyer,seller,name,price),true
    end
        return string.format("sorry, but %s cannot afford to buy %s",buyer.name,name),false
end

--player sells item to a planet or ship from the 'buying' column
local function playerSellItem(buyer,seller,name)
    if seller.inv[name] == nil then
        return string.format("Sorry, but %s doesnt have %s.",seller.name,name)
    end
    if buyer.buy[name] ~= nil then
        local price = buyer.buy[name].price
        local str,sold  = sellItem(buyer,seller,name,price)
        if sold == true and buyer.inv[name].item_type == "Rare" then
            PLAYER_SCORE = PLAYER_SCORE + 15
        end
        return str
    end
    return string.format("sorry, but %s isn't buying %s.",buyer.name,name)
end

--check the y position of the mouse compared to what is on the screen
local function checkYLocationOfClick(inv,y)
    if inv ~= nil then
        local base = LARGE_FONT:getHeight() + 20
        local i    = (y - base + MAIN_FONT:getHeight()) / 20 
        i = math.modf(i)
        if y > base and i <= #inv then
            return inv[i]
        end
    end
    return -1
end

--check the x positoon of the mouse compared to what is on the screen
local function checkXLocationOfClick(x,y)
    local player_canvas = PLAYER.sell_canvas:getWidth()
    local sell_canvas   = TRADE_PARTNER.sell_canvas:getWidth() + player_canvas
            --player clicks on an item in their inventory
    if x > 0 and x <= player_canvas then
        return checkYLocationOfClick(PLAYER.sell_order,y),"Player Sell"
        
     --player clicks on an item in thrade partner's  inventory   
    elseif x > player_canvas and x <= sell_canvas and DRAW_TRADE == true then
        return checkYLocationOfClick(TRADE_PARTNER.sell_order,y),"Partner Sell"

    --player clicks on an item in buying column
    elseif x > sell_canvas and x <= TRADE_PARTNER.buy_canvas:getWidth() + sell_canvas and DRAW_TRADE == true then
        return checkYLocationOfClick(TRADE_PARTNER.buy_order,y),"Partner Buy"
    else
        return -1,nil
    end
end

--trade an item to/from player and another ship or planet
function tradeItem(i,verb)
    local str
    if verb == "Player Sell" then
        str = playerSellItem(TRADE_PARTNER,PLAYER,i)
    elseif verb == "Partner Sell" then
        str = sellItem(PLAYER,TRADE_PARTNER,i,TRADE_PARTNER.inv[i].price)
    elseif verb == "Partner Buy" then
        str = playerSellItem(TRADE_PARTNER,PLAYER,i)
    end
    return str
end

--player uses item to upgrade ship
function upgradeShip(i,_)
    local str = "sorry, but you can't upgrade with that item"
    if PLAYER.inv[i].func ~= nil then
        str,succ = PLAYER.inv[i].func(PLAYER.inv[i].name)
        if succ == true then
            removeItem(PLAYER.inv,PLAYER.inv[i],1)
        end
    end
    return str
end

--find the correct item corresponding to the name displayed on screen based on mouse x,y
function getInvItemFromClick(x,y,func)
    local i,verb = checkXLocationOfClick(x,y)
        if i ~= -1 then
        DRAW_SELL  = true
        return func(i,verb)
    end
    return nil
end

--checks if their is a ship or planet at same locations as player ship to trade with
function checkForTradePartner(partners)
    local params   = {x = PLAYER.x,y = PLAYER.y} 
    for i = 1, #partners,1 do
        local j = iterateObjects(partners[i],params,checkIfPlayerIsTouching)
        if j ~= -1 then
            return partners[i][j]
        end
    end
    return nil
end


function playerInventory()
    drawInvCanvas(PLAYER,1,true,false)
    local print_y = LARGE_FONT:getHeight() + 10 + (20 * (#PLAYER.sell_order + 2))
    love.graphics.print("press escape to exit", 5,print_y)
end

function tradeScreen()
    local p_width  = PLAYER.sell_canvas:getWidth() + 21
    playerInventory()
    drawInvCanvas(TRADE_PARTNER,p_width,false,true)
end

