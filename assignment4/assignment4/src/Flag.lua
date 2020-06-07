Flag = Class{__includes = GameObject}

function Flag:init(def)
	GameObject.init(self, def)
	
	self.currentAnimation = def.animation
end

function Flag:update(dt)
	self.currentAnimation:update(dt)
end

function Flag:render()
	love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()], math.floor(self.x), math.floor(self.y))
end