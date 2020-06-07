--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
	local isCollision =
        not (self.x + self.width < target.x or self.x > target.x + target.width or self.y + self.height < target.y or
        self.y > target.y + target.height)

    local isNotCollision =
        not (self.x + self.width <= target.x or self.x >= target.x + target.width or self.y + self.height <= target.y or
        self.y >= target.y + target.height)

    if isNotCollision and target.solid then
        if self.direction == 'right' then
            self.x = target.x - self.width
        end
        if self.direction == 'left' then
            self.x = target.x + target.width
        end
        if self.direction == 'down' then
            self.y = target.y - self.height
        end
        if self.direction == 'up' then
            self.y = target.y + target.height
        end
    end
    return isCollision
end

function Player:heal(heal)
    self.health = math.min(6, self.health + heal)
end

function Player:render()
    Entity.render(self)
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end