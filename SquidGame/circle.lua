-- class required for game 2
VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 1200, 600
Circle = Class{}

local OuterCircle = {}
OuterCircle.x = VIRTUAL_WIDTH/2
OuterCircle.y = VIRTUAL_HEIGHT/2
OuterCircle.radius = 0.9 * (math.min(VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2))
RED_COLOR_COUNT = 0
function Circle:init()
    valid = true
    while valid do
        self.x = math.random(OuterCircle.x - OuterCircle.radius, OuterCircle.x + OuterCircle.radius)
        self.y = math.random(OuterCircle.y - OuterCircle.radius, OuterCircle.y + OuterCircle.radius)
        if math.sqrt(math.pow(OuterCircle.x - self.x, 2) + math.pow(OuterCircle.y - self.y, 2)) < OuterCircle.radius - 10 then
            valid = false
        end
    end
    self.radius = 0
    self.growing = true
    self.m = math.random()
    self.clicked = false
    if self.m > 0.6 then
        self.color = "red"
        RED_COLOR_COUNT = RED_COLOR_COUNT + 1
    elseif self.m > 0.3 then
        self.color = "blue"
    else
        self.color = "yellow"
    end
end


function touchOtherCircle(circleTable)
    for key, value in pairs(circleTable) do
        for key1, value1 in pairs(circleTable) do
            if value ~= value1 then
                if value.radius + value1.radius >= math.sqrt(math.pow(value.x - value1.x, 2) + math.pow(value.y - value1.y, 2)) then
                    value.growing = false
                    value1.growing = false
                end
            end
        end
    end
    
end


function touchCircleBoundary(circleObject)
    return math.sqrt(math.pow(OuterCircle.x - circleObject.x, 2) + math.pow(OuterCircle.y - circleObject.y, 2)) + circleObject.radius > OuterCircle.radius
end


function Circle:render()
    love.graphics.circle("line", OuterCircle.x, OuterCircle.y, OuterCircle.radius)
    
end

