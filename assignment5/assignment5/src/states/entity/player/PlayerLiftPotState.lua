PlayerPotLiftState = Class{__includes = EntityIdleState}

function PlayerPotLiftState:init(entity, dungeon)
    self.entity = entity

    self.dungeon = dungeon

     -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
	
	self.entity:changeAnimation('pot-lift-' .. self.entity.direction)
end

function PlayerPotLiftState:enter(params)


   self.pot = table.remove(self.dungeon.currentRoom.pots, params.potK)
    Timer.tween(
        0.5,
        {
            [self.pot] = {x = self.entity.x, y = self.entity.y - self.pot.height}
        }
    ):finish(
        function()
            self.entity:changeState('pot-lift', {potK = self.pot}) 
        end
    )
    self.entity.currentAnimation:refresh()
end

function PlayerPotLiftState:update(dt)
end

function PlayerPotLiftState:render()
    local animation = self.entity.currentAnimation
    love.graphics.draw(
        gTextures[animation.texture],
        gFrames[animation.texture][animation:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX),
        math.floor(self.entity.y - self.entity.offsetY)
    )
    self.pot:render(0, self.entity.height / 3)
end