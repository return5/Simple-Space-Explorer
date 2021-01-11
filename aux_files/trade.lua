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


function playerInventory()
    drawObjectCanvas(PLAYER.inv,1,PLAYER.sell_canvas)
    love.graphics.print("press esc to exit.", 5,LARGE_FONT:getHeight() + 10 + (20 * (#PLAYER.inv + 1)))
end

function tradeScreen()
    local p_width = PLAYER.sell_canvas:getWidth() + 20
    playerInventory()
    drawObjectCanvas(TRADE_PARTNER.inv,p_width,TRADE_PARTNER.sell_canvas)
    drawObjectCanvas(TRADE_PARTNER.buy,p_width + TRADE_PARTNER.sell_canvas:getWidth() + 20,TRADE_PARTNER.buy_canvas)
end

function playerPressedT()
    TRADE_PARTNER = checkForTrade()
end


