PlayerPotLiftState = Class{__includes = BaseState}

function PlayerPotLiftState:init(player, dungeon)
    self.player = player

    self.dungeon = dungeon

     -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0
	
	self.player:changeAnimation('pot-lift-' .. self.player.direction)
end

function PlayerPotLiftState:enter(potK)
print('here')
	print(potK)

   self.pot = self.dungeon.currentRoom.pots[potK.potK]
   table.remove(self.dungeon.currentRoom.pots, 1)
    Timer.tween(
        0.5,
        {
            [self.pot] = {x = self.player.x, y = self.player.y - self.pot.height}
        }
    ):finish(
        function()
            self.player:changeState('pot-idle', {pot = self.pot}) 
        end
    )
    self.player.currentAnimation:refresh()
end

function PlayerPotLiftState:update(dt)
end

function PlayerPotLiftState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(
        gTextures[anim.texture],
        gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX),
        math.floor(self.player.y - self.player.offsetY)
    )
    self.pot:render(0, self.player.height / 3)
end