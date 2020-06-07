PauseState = Class{__includes = BaseState}

function PauseState:enter(pauseBird, pausePipePairs, pauseScore, pauseTimer)
	self.pauseBird = pauseBird
	self.pausePipePairs = pausePipePairs
	self.pauseScore = pauseScore
	self.pauseTimer = pauseTimer
	
end

function PauseState:update(dt)
	if love.keyboard.wasPressed('p') then
		gStateMachine:change('play', {
			pauseBird = self.pauseBird,
			pausePipePairs = self.pausePipePairs,
			pauseScore = self.pauseScore,
			pauseTimer = self.pauseTimer
		})
	end
end

function PauseState:render()
	love.graphics.setFont(flappyFont)
	love.graphics.printf('Game Paused', 0, 64, VIRTUAL_WIDTH, 'center')
	
	love.graphics.draw(pauseSymbol, VIRTUAL_WIDTH / 2.1, VIRTUAL_HEIGHT / 2.25, 0, 0.1, 0.1)
	
	love.graphics.printf('Press \"p\" to continue', 0, 100, VIRTUAL_WIDTH, 'center')
	
end