--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{}

function Projectile:init(def, x, y)
    GameObject.init(self, def, x, y)
    self.dx = def.dx
    self.dy = def.dy
    self.travelDistance = 0
end

function Projectile:update(dt)
    self.x = self.x + (self.dx * dt)
    self.y = self.y + (self.dy * dt)
    self.travelDistance = self.travelDistance + math.abs(self.dx * dt) + math.abs(self.dy * dt)
end

function Projectile:render(adjacentObjectX, adjacentObjectY)
    GameObject.render(self, adjacentObjectX, adjacentObjectY)
end