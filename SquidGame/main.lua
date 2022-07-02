math.randomseed(os.time())
push = require 'push'
Class = require 'class'
require 'StateMachine'
require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/RedLightGreenLight'
require 'states/SugarHoneycombs'
require 'player'
require 'Doll'
WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 600

love.window.setTitle('Squid Games')

function love.load()
    VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 1200, 600
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = true,
        resizable = true
    })
    love.graphics.setFont(love.graphics.newFont(30))
    red_background = love.graphics.newImage('assets/red_background.jpg')
    red_circle = love.graphics.newImage('assets/red_circle.png')
    yellow_circle = love.graphics.newImage('assets/yellow_circle.png')
    blue_circle = love.graphics.newImage('assets/blue_circle.png')
    green_background = love.graphics.newImage('assets/green_background.jpg')

    gStateMachine = StateMachine({
        title = function () return TitleScreenState() end,
        game1 = function () return Game1() end,
        game2 = function () return Game2() end
    })
    gStateMachine:change('title')


end

function love.resize(w, h)
    push:resize(w, h)
    
end

function love.mousepressed(x, y, button)
    local mouseX, mouseY = push:toGame(x, y)
    gStateMachine.current:mouse_pressed(mouseX, mouseY, button)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    
end

function love.update(dt)
    gStateMachine:update(dt)
end


function love.draw()
    push:start()
    
    gStateMachine:render()
    love.graphics.print(tostring(love.timer.getFPS()))
    push:finish()
end