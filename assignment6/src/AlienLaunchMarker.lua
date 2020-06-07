--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

AlienLaunchMarker = Class{}

function AlienLaunchMarker:init(world)
    self.world = world

    -- starting coordinates for launcher used to calculate launch vector
    self.baseX = 90
    self.baseY = VIRTUAL_HEIGHT - 100

    -- shifted coordinates when clicking and dragging launch alien
    self.shiftedX = self.baseX
    self.shiftedY = self.baseY

    -- rotation for the trajectory arrow
    self.rotation = 0

    -- whether our arrow is showing where we're aiming
    self.aiming = false

    -- whether we launched the alien and should stop rendering the preview
    self.launched = false

    -- our alien we will eventually spawn
    self.alien = nil
	
	--duplicate aliens for maximum impact
	self.fakeAliens = nil
end

function AlienLaunchMarker:update(dt)
    
    -- perform everything here as long as we haven't launched yet
    if not self.launched then

        -- grab mouse coordinates
        local x, y = push:toGame(love.mouse.getPosition())
        
        -- if we click the mouse and haven't launched, show arrow preview
        if love.mouse.wasPressed(1) and not self.launched then
            self.aiming = true

        -- if we release the mouse, launch an Alien
        elseif love.mouse.wasReleased(1) and self.aiming then
            self.launched = true

            -- spawn new alien in the world, passing in user data of player
            self.alien = Alien(self.world, 'round', self.shiftedX, self.shiftedY, 'Player')

            -- apply the difference between current X,Y and base X,Y as launch vector impulse
            self.alien.body:setLinearVelocity((self.baseX - self.shiftedX) * 10, (self.baseY - self.shiftedY) * 10)

            -- make the alien pretty bouncy
            self.alien.fixture:setRestitution(0.4)
            self.alien.body:setAngularDamping(1)

            -- we're no longer aiming
            self.aiming = false

        -- re-render trajectory
        elseif self.aiming then
            self.rotation = self.baseY - self.shiftedY * 0.9
            self.shiftedX = math.min(self.baseX + 30, math.max(x, self.baseX - 30))
            self.shiftedY = math.min(self.baseY + 30, math.max(y, self.baseY - 30))
		end
	elseif not self.alien.collided and love.keyboard.wasPressed('space') then
				--spawn new aliens in the world, passing in user data of player
				self.fakeAliens = {
									['alien1'] = Alien(self.world, 'round', self.alien.body:getX(), self.alien.body:getY() + 70, 'Player'),  --alien is 35 pixels across so need to make sure it doesn't overlap
									['alien2'] = Alien(self.world, 'round', self.alien.body:getX(), self.alien.body:getY() - 70, 'Player')
								}
				-- apply the difference between current x,y and base x,y as launch vector impulse
				self.fakeAliens['alien1'].body:setLinearVelocity((self.baseX - self.shiftedX ) * 10, (self.baseY - self.shiftedY) * 10)
				self.fakeAliens['alien2'].body:setLinearVelocity((self.baseX - self.shiftedX ) * 10, (self.baseY - self.shiftedY) * 10)
	
				-- make the alien pretty bouncy
				for k, fake in pairs(self.fakeAliens) do
					self.fakeAliens[k].fixture:setRestitution(0.4)
					self.fakeAliens[k].body:setAngularDamping(1)
	
				--we're no longer allowed to create more aliens
					self.fakeAliens[k].collided = true
				end
				
				self.alien.collided = true
    end
end

function AlienLaunchMarker:render()
    if not self.launched then
        
        -- render base alien, non physics based
        love.graphics.draw(gTextures['aliens'], gFrames['aliens'][9], 
            self.shiftedX - 17.5, self.shiftedY - 17.5)

        if self.aiming then
            
            -- render arrow if we're aiming, with transparency based on slingshot distance
            local impulseX = (self.baseX - self.shiftedX) * 10
            local impulseY = (self.baseY - self.shiftedY) * 10

            -- draw 6 circles simulating trajectory of estimated impulse
            local trajX, trajY = self.shiftedX, self.shiftedY
            local gravX, gravY = self.world:getGravity()

            -- http://www.iforce2d.net/b2dtut/projected-trajectory
            for i = 1, 90 do
                
                -- magenta color that starts off slightly transparent
                love.graphics.setColor(255/255, 80/255, 255/255, (1 / 12) * i)
                
                -- trajectory X and Y for this iteration of the simulation
                trajX = self.shiftedX + i * 1/60 * impulseX
                trajY = self.shiftedY + i * 1/60 * impulseY + 0.5 * (i * i + i) * gravY * 1/60 * 1/60

                -- render every fifth calculation as a circle
                if i % 5 == 0 then
                    love.graphics.circle('fill', trajX, trajY, 3)
                end
            end
        end
        
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    elseif self.fakeAliens == nil then
        self.alien:render()
	else
		for k, fake in pairs(self.fakeAliens) do
			self.fakeAliens[k]:render()
		end
		self.alien:render()
    end
end