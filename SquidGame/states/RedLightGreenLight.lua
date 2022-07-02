Game1 = Class{__includes = BaseState}
require 'bullets'
-- timer for changing light to green or red
local timer = math.random(1, 4)
-- table containing other bot enemies
local ManyEnemy = {}
-- table storing bullet shot by the doll
local ManyBullets = {}
-- table containing players who moved on red light
local violatedPlayers = {}
-- table containg player who moved on red light for collision detection as an innocent person who is front can get shot if 
-- the violated player is hiding behind that innocent person
local BulletProneEnemies = {}
-- initial color at the start of game
local color = "green"

-- will create the initial starting line enemies at the start of the level
local function createBotEnemies()
    local width = VIRTUAL_WIDTH / 10
    for i = 0, 9 do
        if i == 5 then 
        -- the player at index 5 will be us
        else
            local enemy = {}
            enemy.width = width - 40
            enemy.height = 40
            enemy.x = i * width + 20
            enemy.y = VIRTUAL_HEIGHT - enemy.height
            enemy.speed = math.random(10, 40)
            enemy.iq = math.random(110, 150)
            enemy.hasViolated = false
            table.insert(ManyEnemy, enemy)
        end
    end
    return ManyEnemy
end



-- ABAB collision logic
local function EnemyBulletCollision(enemytable, bulletTable)
    return enemytable.x + enemytable.width > bulletTable.x and
        enemytable.x < bulletTable.x + bulletTable.width and
        enemytable.y + enemytable.height > bulletTable.y and
        enemytable.y < bulletTable.y + bulletTable.height
end


local function punishViolatedPlayer(dt)
    if violatedPlayers ~= nil then
        for key, value in pairs(violatedPlayers) do
            value[2] = value[2] - dt
            if value[2] < 0 then
                --createBullet(value[1])
                table.insert(ManyBullets, Bullet(value[1]))
                table.remove(violatedPlayers, key)
            end
        end
    end
end

-- if violation duration increases more than main_player_warn then only shoot the player
local main_player_warn = 0.25
local gameover = false
local levelCompleted = false


function Game1:init()
    self.player = Player()
    self.enemies = createBotEnemies()
    self.doll = Doll()
end

function Game1:mouse_pressed(x1, y1, button1)
    
end


function Game1:update(dt)
    if gameover and levelCompleted == false then
        gStateMachine:change('title')
    elseif gameover and levelCompleted then
        gStateMachine:change('game1')
    end

    self.player:update(dt)
    self.doll:update(dt)
    
    -- if we cross the line we win
    if self.player.y < 60 then
        levelCompleted = true
        gameover = true
    end

    timer = timer - dt

    if timer < 0 then
        timer = math.random(1, 4)
        if color == "green" then
            color = "red"
        else
            color = "green"
            main_player_warn = 0.25
        end
    end

    -- update the enemies
    for key, value in pairs(self.enemies) do
        if color == "red" then
            if value.iq < 100 then -- if the iq of enemy has decreased then only move the enemy
                value.y = value.y - value.speed * dt
                if not value.hasViolated then
                    value.hasViolated = true
                    table.remove(ManyEnemy, key)
                    -- move the violated enemy to another table so to prevent innocent player getting shot
                    table.insert(BulletProneEnemies, value)
                    -- shoot bullet after 0.5 sec to make it seem real
                    table.insert(violatedPlayers, {value, 0.5})
                end
            end
            
        elseif color == "green" then
            value.y = value.y - value.speed * dt
        end

        -- remove the bot player after they have reached the line
        if value.y < 60 then
            table.remove(self.enemies, key)
        end
        value.iq = value.iq - dt
    end

    if color == "red" then
        if self.player.moving then
            main_player_warn = main_player_warn - dt
            if main_player_warn < 0 then
                table.insert(violatedPlayers, {self.player, 0})
                main_player_warn = 5 -- dont change this is bullet timer cooldown
            end
        end
    end


    punishViolatedPlayer(dt)

    -- update the bullet movement
    if ManyBullets ~= nil then
        for key, value in pairs(ManyBullets) do
            value:update(dt)
        end
    end
    
    -- check for bullet collision with violated enemies
    for key, value in pairs(BulletProneEnemies) do
        value.y = value.y - value.speed * dt
        for key1, value1 in pairs(ManyBullets) do
            if EnemyBulletCollision(value, value1) then
                table.remove(BulletProneEnemies, key)
                table.remove(ManyBullets, key1)
            end
        end
    end

    -- check bullet player collision(us)
    if ManyBullets ~= nil then
        for key, value in pairs(ManyBullets) do
            if EnemyBulletCollision(self.player, value) then
                table.remove(ManyBullets, key)
                --self.player = nil
                gameover = true
                levelCompleted = false
                break
            end
        end
    end
end

function Game1:render()
    if color == "green" then
        love.graphics.draw(green_background, 0, 0, 0, WINDOW_WIDTH/green_background:getWidth(), WINDOW_HEIGHT/green_background:getHeight())
    elseif color == "red" then
        love.graphics.draw(red_background, 0, 0, 0, WINDOW_WIDTH/red_background:getWidth(), WINDOW_HEIGHT/red_background:getHeight())
    end


    --love.graphics.rectangle("fill", self.player.x, self.player.y, self.player.wdith, self.player.height)
    if self.player ~= nil then
        self.player:render()
    end
    
    if self.enemies ~= nil then
        for key, value in pairs(self.enemies) do
            love.graphics.rectangle("fill", value.x, value.y, value.width, value.height)
        end
    end
    self.doll:render()

    if BulletProneEnemies ~= nil then
        for key, value in pairs(BulletProneEnemies) do 
            love.graphics.rectangle("fill", value.x, value.y, value.width, value.height)
        end
    end

    if ManyBullets ~= nil then
        for key, value in pairs(ManyBullets) do
            value:render()
        end
    end

    love.graphics.print(color, 0, 50)
end

function Game1:exit()
    gameover = false
    ManyEnemy = {}
    ManyBullets = {}
    violatedPlayers = {}
    BulletProneEnemies = {}
    color = "red"
    timer = -1
end