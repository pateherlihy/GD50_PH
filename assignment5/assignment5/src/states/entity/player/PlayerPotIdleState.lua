--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPotIdleState = Class {__includes = BaseState}

function PlayerPotIdleState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    self.player:changeAnimation('pot-idle-' .. self.player.direction)
end

function PlayerPotIdleState:enter(pot)
    self.pot = pot.pot
end

function PlayerPotIdleState:update(dt)
    if
        love.keyboard.isDown('left') or love.keyboard.isDown('right') or love.keyboard.isDown('up') or
            love.keyboard.isDown('down')
     then
        self.player:changeState('pot-walk', {pot = self.pot})
    end

    if love.keyboard.wasPressed('e') then
        self.player:changeState('pot-throw', {pot = self.pot})
    end
end

function PlayerPotIdleState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(
        gTextures[anim.texture],
        gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX),
        math.floor(self.player.y - self.player.offsetY)
    )
    self.pot:render(0, self.player.height / 3)

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end