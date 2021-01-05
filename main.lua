local Planets = require("aux_files.planet")
local Ships   = require("aux_files.ship")


function love.draw()
    love.graphics.draw(PLAYER.icon,PLAYER.x,PLAYER.y)
end

function love.update()

end


function love.load()
    HEIGHT       = 800
    WIDTH        = 900
    love.window.setMode(WIDTH,HEIGHT)
    SOLAR_SYSTEM = makeSolarSystem()
    PLAYER       = makePlayerShip(SOLAR_SYSTEM)
    SHIPS        = makeEnemyShips(SOLAR_SYSTEM)
end

