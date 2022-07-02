Player = Class{}


function Player:init()
    self.width = VIRTUAL_WIDTH/10 - 40
    self.height = 40
    self.x = VIRTUAL_WIDTH/10 * 5 + 20
    self.y = VIRTUAL_HEIGHT - self.height
    self.speed = 40
    self.moving = false
end


function Player:update(dt)
    if love.keyboard.isDown('w') then
        self.y = self.y - self.speed * dt
        self.moving = true
    elseif love.keyboard.isDown('s') then
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.speed * dt)
        self.moving = true
    else
        self.moving = false
    end
end


function Player:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end