Doll = Class{}

function Doll:init()
    self.width = 50
    self.height = 40
    self.x = VIRTUAL_WIDTH/2 - self.width/2
    self.y = 20
    
end

function Doll:update(dt)
    
end

function Doll:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    
end