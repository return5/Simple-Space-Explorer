--File contains function  for trading between player of other ships or planets

local function tradeWithObject(obj)

end

function checkForTrade()
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
        DRAW_SPACE = false
        DRAW_TRADE = true
    end
    return trade_partner
end

