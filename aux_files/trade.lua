--File contains function for trading between player and other ships or planets




local function tradeWithObject(obj)

end

function checkForTradePartner(partners)
    local params        = {x = PLAYER.x,y = PLAYER.y} 
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



