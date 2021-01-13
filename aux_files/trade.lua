--File contains function for trading between player and other ships or planets



function sellScreen()
    love.graphics.setCanvas()
    love.graphics.print(BOUGHT_STR,1,1)
    love.graphics.print("press escape to exit.",1,MAIN_FONT:getHeight() * 2 + 10)
end


--player or ship successfully sold an item
local function successSellItem(buyer,seller,i)
   local str    = string.format("%s bought %s for %d space dollars.",buyer.name,seller.inv[i].name,seller.inv[i].price)
   buyer.money  = buyer.money - seller.inv[i].price
   seller.money = seller.money + seller.inv[i].price
   table.insert(buyer.inv,seller.inv[i])
   table.remove(seller.inv,i)
   return str
end

--player or ship/planet sells an item
local function sellItem(buyer,seller,i)
    if buyer.money >= seller.inv[i].price then
        return successSellItem(buyer,seller,i)
    end
        return string.format("sorry, but %s cannot afford to buy %s",buyer.name,seller.inv[i].name)
end

--player sells item to a planet or ship from the 'buying' column
local function buyItem(buyer,seller,i)
    if iterateObjects(seller.inv,{name = buyer.buy[i].name},checkNAme) ~= -1 then
        return sellItem(buyer,seller,i)
    end
        return string.format("Sorry, but %s doesnt have %s.",seller.name,buyer.buy[i].name)
end

--check the y position of the mouse compared to what is on the screen
local function checkYLocationOfClick(inv,y)
    if inv ~= nil then
        local base = LARGE_FONT:getHeight() + 20
        local i    = (y - base + MAIN_FONT:getHeight()) / 20 
        i = math.modf(i)
        if y > base and i <= #inv then
            return i
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
        return checkYLocationOfClick(PLAYER.inv,y),"Player Sell"
        
     --player clicks on an item in thrade partner's  inventory   
    elseif x > player_canvas and x <= sell_canvas and DRAW_TRADE == true then
        return checkYLocationOfClick(TRADE_PARTNER.inv,y),"Partner Sell"

    --player clicks on an item in buying column
    elseif x > sell_canvas and x <= TRADE_PARTNER.buy_canvas:getWidth() + sell_canvas and DRAW_TRADE == true then
        return checkYLocationOfClick(TRADE_PARTNER.buy,y),"Partner Buy"
    else
        return -1,nil
    end
end

--trade an item to/from player and another ship or planet
function tradeItem(i,verb)
    local str
    if verb == "Player Sell" then
        str = sellItem(TRADE_PARTNER,PLAYER,i)
    elseif verb == "Partner Sell" then
        str = sellItem(PLAYER,TRADE_PARTNER,i)
    elseif verb == "Partner Buy" then
        str = buyItem(TRADE_PARTNER,PLAYER,i)
    end
    return str
end

--player uses item to upgrade ship
function upgradeShip(i,_)
    if PLAYER.inv[i].func ~= nil then
        local str = PLAYER.inv[i].func()
        table.remove(PLAYER.inv,i)
        return str
    end
end

--find the correct item borresponding to the name displayed on screen based on mouse x,y
function getInvItemFromClick(x,y,func)
    local i,verb = checkXLocationOfClick(x,y)
        if i ~= -1 then
        DRAW_TRADE = false
        DRAW_SPACE = false
        DRAW_INV   = false
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
    drawObjectCanvas(PLAYER.inv,1,PLAYER.sell_canvas,false,PLAYER.sell_title)
    love.graphics.print("press esc to exit.", 5,LARGE_FONT:getHeight() + 10 + (20 * (#PLAYER.inv + 1)))
end

function tradeScreen()
    local p_width    = PLAYER.sell_canvas:getWidth() + 20
    playerInventory()
    drawObjectCanvas(TRADE_PARTNER.inv,p_width,TRADE_PARTNER.sell_canvas,true,TRADE_PARTNER.sell_title)
    drawObjectCanvas(TRADE_PARTNER.buy,p_width + TRADE_PARTNER.sell_canvas:getWidth() + 20,TRADE_PARTNER.buy_canvas,true,TRADE_PARTNER.buy_title)
end

