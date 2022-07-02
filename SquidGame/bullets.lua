Bullet = Class{}
VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 1200, 600
function Bullet:init(Etable)
    self.width = 5
    self.height = 5
    self.x = VIRTUAL_WIDTH/2 - self.width/2
    self.y = 20 + 40/2 - self.height
    self.DestinationX = Etable.x + Etable.width/2
    self.DestinationY = Etable.y
    self.slope = math.atan2(self.DestinationY - self.y, self.DestinationX - self.x)
    self.xincrement = math.cos(self.slope) * 1000
    self.yincrement = math.sin(self.slope) * 1000
end

function Bullet:update(dt)
    self.x = self.x + self.xincrement * dt
    self.y = self.y + self.yincrement * dt
end

function Bullet:render()
    love.graphics.rectangle("fill",self.x, self.y, self.width, self.height)
end