PlayerPotThrowState = Class {__includes = BaseState}

function PlayerPotThrowState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    self.player:changeAnimation('pot-throw-' .. player.direction)
end

function PlayerPotThrowState:enter(params)
    self.pot = params.pot

    local finishX = self.player.x
	local finishY = self.player.y
    
    local dx = 0
    local dy = 0
	
    if self.player.direction == 'left' then
        finishX = self.player.x - self.pot.width
        dx = -150
    elseif self.player.direction == 'right' then
        finishX = self.player.x + self.player.width
        dx = 150
    elseif self.player.direction == 'down' then
        finishY = self.player.y + self.player.height
        dy = 150
    else
        finishY = self.player.y - self.pot.height
        dy = -150
    end
    Timer.tween(
        0.155,
        {
            [self.pot] = {x = finishX, y = finishY}
        }
    ):finish(
        function()
            self.player:changeState('idle')
            local thrownPot = GAME_OBJECT_DEFS['pot']
			thrownPot.state = 'broken'
            thrownPot.dx = dx
            thrownPot.dy = dy
            thrownPot.adjacentYOffset = self.player.height / 3
            local brokePot = Projectile(thrownPot, finishX, finishY)
            table.insert(self.dungeon.currentRoom.objects, brokePot)
        end
    )
    self.player.currentAnimation:refresh()
end

function PlayerPotThrowState:update(dt)
end

function PlayerPotThrowState:render()
    local animation = self.player.currentAnimation
    love.graphics.draw(
        gTextures[animation.texture],
        gFrames[animation.texture][animation:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX),
        math.floor(self.player.y - self.player.offsetY)
    )
    self.pot:render(0, self.player.height / 3)
end