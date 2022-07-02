Game2 = Class{__includes = BaseState}
require 'circle'

local CircleTable = {}
local targetColor = "red"



function Game2:init()
    for x = 1, 50 do
        table.insert(CircleTable, Circle())
    end
end

local timer = 15

function ifClickedOnCircle(mousex, mousey)
    for key, value in pairs(CircleTable) do
        if math.sqrt(math.pow(value.x - mousex, 2) + math.pow(value.y - mousey, 2)) < value.radius then
            value.clicked = true
            RED_COLOR_COUNT = RED_COLOR_COUNT - 1
            if value.color ~= targetColor then
                gStateMachine:change('title')
            end
        end
    end
end

function Game2:mouse_pressed(x2, y2, button2)
    local mousex = x2
    local mousey = y2
    ifClickedOnCircle(mousex, mousey)
end

function Game2:update(dt)
    if timer < 0 then
        gStateMachine:change("game1")
    end
    for key, value in pairs(CircleTable) do
        if value.growing then
            value.radius = value.radius + 60*dt
        end
        
        if touchCircleBoundary(value) then
            value.growing = false
        end
    end
    touchOtherCircle(CircleTable)
    if RED_COLOR_COUNT == 0 then
        gStateMachine:change('game1')
    end
    timer = timer - dt
end


function Game2:render()
    --[[
    for key, value in pairs(CircleTable) do
        love.graphics.circle("line", value.x, value.y, value.radius)
    end
    ]]
    love.graphics.printf(tostring(math.ceil(timer)), WINDOW_WIDTH/2 + 300, 2, 100, "center")
    love.graphics.printf("Click on all the red circles", 150, 200, 100, "center")
    for key, value in pairs(CircleTable) do
        if not value.clicked then
            if value.color == "red" then
                love.graphics.draw(red_circle, value.x, value.y, 0, 2 * value.radius/red_circle:getWidth(), 2 * value.radius/red_circle:getHeight(), red_circle:getWidth()/2, red_circle:getHeight()/2)
            elseif value.color == "blue" then
                love.graphics.draw(blue_circle, value.x, value.y, 0, 2 * value.radius/blue_circle:getWidth(), 2 * value.radius/blue_circle:getHeight(), blue_circle:getWidth()/2, blue_circle:getHeight()/2)
            else
                love.graphics.draw(yellow_circle, value.x, value.y, 0, 2 * value.radius/yellow_circle:getWidth(), 2 * value.radius/yellow_circle:getHeight(), yellow_circle:getWidth()/2, yellow_circle:getHeight()/2)
            end
        end
    end
    
    Circle:render()
end

function Game2:exit()
    CircleTable = {}
    timer = 15
    RED_COLOR_COUNT = 0
end