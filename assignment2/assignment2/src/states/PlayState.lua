--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
	self.currentPaddle = params.currentPaddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.level = params.level
	self.paddleSize = params.paddleSize

    self.recoverPoints = 5000
	self.paddlePoints = 5000
	
	self.ballPowerUp = PowerUp(1)
	
	self.ball1 = 0
	self.ball2 = 0
	
	--start off without the key
	self.hasKey = params.hasKey
	
	self.needKey = false
	
	self.key = PowerUp(2)


    -- give ball random starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)

end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end
	
	--update whether to generate a key
	for k, brick in pairs(self.bricks) do
		if brick.isLock then
			if self.hasKey == false and self.key.x == 0 then
				self.needKey = true
			end
		end
	end
	

	if self.key:collides(self.paddle) then
		self.hasKey = true
		self.key:reset()
	end
		

	
	if self.key.y > VIRTUAL_HEIGHT then
			self.key:reset()
	end
	
	
	
	

    -- update positions based on velocity
	
	if self.ballPowerUp:collides(self.paddle) then
		self.ballPowerUp:reset()
		
			
		self.ball1 = Ball()
		self.ball1.skin = math.random(7)
		self.ball1.x = self.paddle.x
		self.ball1.y = self.paddle.y
		
			
		self.ball2 = Ball()
		self.ball2.skin = math.random(7)
		self.ball2.x = self.paddle.x
		self.ball2.y = self.paddle.y
		
		self.ball1.dx = math.random(-200, 200)
		self.ball1.dy = math.random(-50, -60)
		
		self.ball2.dx = math.random(-200, 200)
		self.ball2.dy = math.random(-50, -60)
	end
	
    self.paddle:update(dt)
    self.ball:update(dt)
	self.ballPowerUp:update(dt)
	self.key:update(dt)
	
	if self.ball1 ~= 0 then
		self.ball1:update(dt)		
		
		if self.ball1:collides(self.paddle) then
			-- raise ball above paddle in case it goes below it, then reverse dy
			self.ball1.y = self.paddle.y - 8
			self.ball1.dy = -self.ball1.dy
	
			--
			-- tweak angle of bounce based on where it hits the paddle
			--
	
			-- if we hit the paddle on its left side while moving left...
			if self.ball1.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
				self.ball1.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball1.x))
			
			-- else if we hit the paddle on its right side while moving right...
			elseif self.ball1.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
				self.ball1.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball1.x))
			end
	
			gSounds['paddle-hit']:play()
		end
	end

	if self.ball2 ~= 0 then
		self.ball2:update(dt)
		
		if self.ball2:collides(self.paddle) then
			-- raise ball above paddle in case it goes below it, then reverse dy
			self.ball2.y = self.paddle.y - 8
			self.ball2.dy = -self.ball2.dy
	
			--
			-- tweak angle of bounce based on where it hits the paddle
			--
	
			-- if we hit the paddle on its left side while moving left...
			if self.ball2.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
				self.ball2.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball2.x))
			
			-- else if we hit the paddle on its right side while moving right...
			elseif self.ball2.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
				self.ball2.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball2.x))
			end
	
			gSounds['paddle-hit']:play()
		end
	end
	
	
	
	if self.ballPowerUp.y > VIRTUAL_HEIGHT then
		self.ballPowerUp:reset()
	end
	

    if self.ball:collides(self.paddle) then
        -- raise ball above paddle in case it goes below it, then reverse dy
        self.ball.y = self.paddle.y - 8
        self.ball.dy = -self.ball.dy

        --
        -- tweak angle of bounce based on where it hits the paddle
        --

        -- if we hit the paddle on its left side while moving left...
        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
        
        -- else if we hit the paddle on its right side while moving right...
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
        end

        gSounds['paddle-hit']:play()
    end

    -- detect collision across all bricks with the ball
    for k, brick in pairs(self.bricks) do
		
			-- only check collision if we're in play
			if brick.inPlay and self.ball:collides(brick) then
		
				if self.ballPowerUp.x == 0 and self.ball1 == 0 and self.ball2 == 0 and math.random(0,10) > 7 then
					self.ballPowerUp:generate(self.ball.x, self.ball.y)
				end
				
				if self.needKey then
					if self.key.x == 0 and self.hasKey == false then
						self.key:generate(self.ball.x, self.ball.y)
					end
				end
				
				-- add to score
				self.score = self.score + (brick.tier * 200 + brick.color * 25)
	
				--only trigger the hit function if we have the key when locked, or everytime if not locked
				-- trigger the brick's hit function, which removes it from play
				if (brick.isLock and self.hasKey) or brick.isLock == false then
					brick:hit()
				end
	
				-- if we have enough points, recover a point of health
				if self.score > self.recoverPoints then
					-- can't go above 3 health
					self.health = math.min(3, self.health + 1)
	
					-- multiply recover points by 2
					self.recoverPoints = math.min(100000, self.recoverPoints * 2)
	
					-- play recover sound effect
					gSounds['recover']:play()
				end
				
				--if we have enough points, decrease paddle size
				if self.score > self.paddlePoints then
					--can't have go below min paddle size
					self.paddleSize = math.max(1, self.paddleSize - 1)
					
					self.paddle = Paddle(self.currentPaddle, self.paddleSize)
					
					--multiply paddle points by 1.5
					self.paddlePoints = math.min(300000, self.paddlePoints * 1.5)
					
					--play paddle increase sound effect
					gSounds['recover']:play()
				end
	
				-- go to our victory screen if there are no more bricks left
				if self:checkVictory() then
					gSounds['victory']:play()
	
					gStateMachine:change('victory', {
						level = self.level,
						paddle = self.paddle,
						health = self.health,
						score = self.score,
						highScores = self.highScores,
						ball = self.ball,
						paddleSize = self.paddleSize,
						hasKey = self.hasKey
					})
				end
	
				--
				-- collision code for bricks
				--
				-- we check to see if the opposite side of our velocity is outside of the brick;
				-- if it is, we trigger a collision on that side. else we're within the X + width of
				-- the brick and should check to see if the top or bottom edge is outside of the brick,
				-- colliding on the top or bottom accordingly 
				--
	
				-- left edge; only check if we're moving right, and offset the check by a couple of pixels
				-- so that flush corner hits register as Y flips, not X flips
				if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
					
					-- flip x velocity and reset position outside of brick
					self.ball.dx = -self.ball.dx
					self.ball.x = brick.x - 8
				
				-- right edge; only check if we're moving left, , and offset the check by a couple of pixels
				-- so that flush corner hits register as Y flips, not X flips
				elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
					
					-- flip x velocity and reset position outside of brick
					self.ball.dx = -self.ball.dx
					self.ball.x = brick.x + 32
				
				-- top edge if no X collisions, always check
				elseif self.ball.y < brick.y then
					
					-- flip y velocity and reset position outside of brick
					self.ball.dy = -self.ball.dy
					self.ball.y = brick.y - 8
				
				-- bottom edge if no X collisions or top collision, last possibility
				else
					
					-- flip y velocity and reset position outside of brick
					self.ball.dy = -self.ball.dy
					self.ball.y = brick.y + 16
				end
	
				-- slightly scale the y velocity to speed up the game, capping at +- 150
				if math.abs(self.ball.dy) < 150 then
					self.ball.dy = self.ball.dy * 1.02
				end
	
				-- only allow colliding with one brick, for corners
				break
			end
	
		
		if self.ball1 ~= 0 then
			
				if brick.inPlay and self.ball1:collides(brick) then
				
				-- add to score
				self.score = self.score + (brick.tier * 200 + brick.color * 25)
	
				-- trigger the brick's hit function, which removes it from play
				if (brick.isLock and self.hasKey) or brick.isLock == false then
					brick:hit()
				end
				
				-- if we have enough points, recover a point of health
				if self.score > self.recoverPoints then
					-- can't go above 3 health
					self.health = math.min(3, self.health + 1)
	
					-- multiply recover points by 2
					self.recoverPoints = math.min(100000, self.recoverPoints * 2)
	
					-- play recover sound effect
					gSounds['recover']:play()
				end
				
				--if we have enough points, decrease paddle size
				if self.score > self.paddlePoints then
					--can't have go below min paddle size
					self.paddleSize = math.max(1, self.paddleSize - 1)
					
					self.paddle = Paddle(self.currentPaddle, self.paddleSize)
					
					--multiply paddle points by 1.5
					self.paddlePoints = math.min(300000, self.paddlePoints * 1.5)
					
					--play paddle increase sound effect
					gSounds['recover']:play()
				end
	
				-- go to our victory screen if there are no more bricks left
				if self:checkVictory() then
					gSounds['victory']:play()
	
					gStateMachine:change('victory', {
						level = self.level,
						paddle = self.paddle,
						health = self.health,
						score = self.score,
						highScores = self.highScores,
						ball = self.ball1,
						paddleSize = self.paddleSize,
						hasKey = self.hasKey
					})
				end
	
				--
				-- collision code for bricks
				--
				-- we check to see if the opposite side of our velocity is outside of the brick;
				-- if it is, we trigger a collision on that side. else we're within the X + width of
				-- the brick and should check to see if the top or bottom edge is outside of the brick,
				-- colliding on the top or bottom accordingly 
				--
	
				-- left edge; only check if we're moving right, and offset the check by a couple of pixels
				-- so that flush corner hits register as Y flips, not X flips
				if self.ball1.x + 2 < brick.x and self.ball1.dx > 0 then
					
					-- flip x velocity and reset position outside of brick
					self.ball1.dx = -self.ball1.dx
					self.ball1.x = brick.x - 8
				
				-- right edge; only check if we're moving left, , and offset the check by a couple of pixels
				-- so that flush corner hits register as Y flips, not X flips
				elseif self.ball1.x + 6 > brick.x + brick.width and self.ball1.dx < 0 then
					
					-- flip x velocity and reset position outside of brick
					self.ball1.dx = -self.ball1.dx
					self.ball1.x = brick.x + 32
				
				-- top edge if no X collisions, always check
				elseif self.ball1.y < brick.y then
					
					-- flip y velocity and reset position outside of brick
					self.ball1.dy = -self.ball1.dy
					self.ball1.y = brick.y - 8
				
				-- bottom edge if no X collisions or top collision, last possibility
				else
					
					-- flip y velocity and reset position outside of brick
					self.ball1.dy = -self.ball1.dy
					self.ball1.y = brick.y + 16
				end
	
				-- slightly scale the y velocity to speed up the game, capping at +- 150
				if math.abs(self.ball1.dy) < 150 then
					self.ball1.dy = self.ball1.dy * 1.02
				end
	
				-- only allow colliding with one brick, for corners
				break
			end

	end

	if self.ball2 ~= 0 then
		
			if brick.inPlay and self.ball2:collides(brick) then
				-- add to score
				self.score = self.score + (brick.tier * 200 + brick.color * 25)
	
				-- trigger the brick's hit function, which removes it from play
				if (brick.isLock and self.hasKey) or brick.isLock == false then
					brick:hit()
				end
	
				-- if we have enough points, recover a point of health
				if self.score > self.recoverPoints then
					-- can't go above 3 health
					self.health = math.min(3, self.health + 1)
	
					-- multiply recover points by 2
					self.recoverPoints = math.min(100000, self.recoverPoints * 2)
	
					-- play recover sound effect
					gSounds['recover']:play()
				end
				
				--if we have enough points, decrease paddle size
				if self.score > self.paddlePoints then
					--can't have go below min paddle size
					self.paddleSize = math.max(1, self.paddleSize - 1)
					
					self.paddle = Paddle(self.currentPaddle, self.paddleSize)
					
					--multiply paddle points by 1.5
					self.paddlePoints = math.min(300000, self.paddlePoints * 1.5)
					
					--play paddle increase sound effect
					gSounds['recover']:play()
				end
	
				-- go to our victory screen if there are no more bricks left
				if self:checkVictory() then
					gSounds['victory']:play()
	
					gStateMachine:change('victory', {
						level = self.level,
						paddle = self.paddle,
						health = self.health,
						score = self.score,
						highScores = self.highScores,
						ball = self.ball2,
						paddleSize = self.paddleSize,
						hasKey = self.hasKey
					})
				end
	
				--
				-- collision code for bricks
				--
				-- we check to see if the opposite side of our velocity is outside of the brick;
				-- if it is, we trigger a collision on that side. else we're within the X + width of
				-- the brick and should check to see if the top or bottom edge is outside of the brick,
				-- colliding on the top or bottom accordingly 
				--
	
				-- left edge; only check if we're moving right, and offset the check by a couple of pixels
				-- so that flush corner hits register as Y flips, not X flips
				if self.ball2.x + 2 < brick.x and self.ball2.dx > 0 then
					
					-- flip x velocity and reset position outside of brick
					self.ball2.dx = -self.ball2.dx
					self.ball2.x = brick.x - 8
				
				-- right edge; only check if we're moving left, , and offset the check by a couple of pixels
				-- so that flush corner hits register as Y flips, not X flips
				elseif self.ball2.x + 6 > brick.x + brick.width and self.ball2.dx < 0 then
					
					-- flip x velocity and reset position outside of brick
					self.ball2.dx = -self.ball2.dx
					self.ball2.x = brick.x + 32
				
				-- top edge if no X collisions, always check
				elseif self.ball2.y < brick.y then
					
					-- flip y velocity and reset position outside of brick
					self.ball2.dy = -self.ball2.dy
					self.ball2.y = brick.y - 8
				
				-- bottom edge if no X collisions or top collision, last possibility
				else
					
					-- flip y velocity and reset position outside of brick
					self.ball2.dy = -self.ball2.dy
					self.ball2.y = brick.y + 16
				end
	
				-- slightly scale the y velocity to speed up the game, capping at +- 150
				if math.abs(self.ball2.dy) < 150 then
					self.ball2.dy = self.ball2.dy * 1.02
				end
	
				-- only allow colliding with one brick, for corners
				break
			end
		end
end
    -- if ball goes below bounds, revert to serve state and decrease health and increase paddle size
	
		if self.ball.y >= VIRTUAL_HEIGHT then
			self.health = self.health - 1
			self.paddleSize = math.min(4, self.paddleSize + 1)
			self.paddle = Paddle(self.currentPaddle, self.paddleSize)
			gSounds['hurt']:play()
	
			if self.health == 0 then
				gStateMachine:change('game-over', {
					score = self.score,
					highScores = self.highScores
				})
			else
				gStateMachine:change('serve', {
					paddle = self.paddle,
					currentPaddle = self.currentPaddle,
					bricks = self.bricks,
					health = self.health,
					score = self.score,
					highScores = self.highScores,
					level = self.level,
					paddleSize = self.paddleSize,
					hasKey = self.hasKey
				})
			end
		end
		
		if self.ball1 ~= 0 then
			if self.ball1.y >= VIRTUAL_HEIGHT then
				self.ball1 = 0
			end
		end
		
		if self.ball2 ~= 0 then
			if self.ball2.y >= VIRTUAL_HEIGHT then
				self.ball2 = 0
			end
		end

	

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end
	
	if self.ballPowerUp.x ~= 0 then
		self.ballPowerUp:render()
	end
	
	if self.ball1 ~= 0 then
		self.ball1:render()	
	end
	
	if self.ball2 ~= 0 then
		self.ball2:render()	
	end
	
	if self.key.x ~= 0 then
		self.key:render()
	end
	
	
    self.paddle:render()
    self.ball:render()

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end