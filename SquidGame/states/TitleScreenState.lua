TitleScreenState = Class{__includes =   BaseState}

function TitleScreenState:init()
    self.playButton = {}
    self.playButton.width = 50
    self.playButton.height = 20
    self.playButton.x = VIRTUAL_WIDTH/2 - self.playButton.width/2
    self.playButton.y = VIRTUAL_HEIGHT/2 - self.playButton.height/2
end
local score = 0

function TitleScreenState:mouse_pressed(x1, y1, button1)
    x = x1
    y = y1
    
end

function TitleScreenState:update(dt)
    if x ~= nil and y ~= nil then
        if x >= self.playButton.x and y <= self.playButton.x + self.playButton.width and x >= self.playButton.y and y <= self.playButton.y + self.playButton.width then
            x, y = nil, nil
            gStateMachine:change('game1')
            
            --score = score + 1
        end
    end 
end

function TitleScreenState:render()
    love.graphics.rectangle("fill", self.playButton.x, self.playButton.y, self.playButton.width, self.playButton.height)
end