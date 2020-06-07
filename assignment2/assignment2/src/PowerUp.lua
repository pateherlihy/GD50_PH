--PowerUp class
PowerUp = Class{}

function PowerUp:init(skin)
	self.width = 16
	self.height = 16
	
	self.x = -50
	self.y = -50
	
	self.dy = DROP_SPEED
	
	self.skin = skin 
	
end

function PowerUp:generate(x, y)
    self.x = x 
    self.y = y
end

function PowerUp:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function PowerUp:update(dt)

    self.y = self.y + self.dy * dt
	
end

function PowerUp:reset()
   self.x = 0
   self.y = 0
end

function PowerUp:render()
	love.graphics.draw(gTextures['main'], gFrames['powerups'][self.skin],
        self.x, self.y)
end

