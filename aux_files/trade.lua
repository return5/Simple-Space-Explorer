--File contains function for trading between player of other ships or planets




local function tradeWithObject(obj)

end

local function checkForTrade()
    local params = {x = PLAYER.x,y = PLAYER.y} 
    local i      = iterateObjects(SOLAR_SYSTEM,params,checkIfPlayerIsTouching)
    local trade_partner
    if i ~= -1 then
        trade_partner = SOLAR_SYSTEM[i]
    else
        i = iterateObjects(SHIPS,params,checkIfPlayerIsTouching)
        if i ~= -1 then
           trade_partner = SHIPS[i]
        end
    end
    if trade_partner ~= nil and trade_partner.inv ~= nil then
        DRAW_TRADE = true
    end
    return trade_partner
end

function tradeScreen()
    local player_string = PLAYER.name .. "'s Inventory:"
    local trade_string  = TRADE_PARTNER.name .. "'s Inventory:" 
    local buy_string    = TRADE_PARTNER.name .. " is buying:"
    local i             = drawInventory(PLAYER.inv,player_string,1,1)
    drawInventory(TRADE_PARTNER.inv,trade_string,player_string:len() * 12,1)
    drawInventory(TRADE_PARTNER.buy,buy_string,(player_string:len() + trade_string:len()) * 12,1)
    love.graphics.print("press esc to exit.", 4,30 * (i + 1))
end

function playerInventory()
    local i = drawInventory(PLAYER.inv,PLAYER.name .. "'s Inventory:" ,1,1)
    love.graphics.print("press esc to exit.",4,30 * (i + 1))
end

function playerPressedT()
    TRADE_PARTNER = checkForTrade()
    if TRADE_PARTNER ~= nil then
        DRAW_INV   = false
        DRAW_TRADE = true
    end
end


