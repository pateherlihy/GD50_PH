--[[
    GD50
    Pokemon

    Author: Patrick Herlihy

]]

LevelUpMenuState = Class{__includes = BaseState}
--may or may not be the BattleMessageState with added stats in msg :P

function LevelUpMenuState:init(stats, onClose, canInput)
    msg = "HP: " ..tostring(stats.current.HP) .. " + " .. tostring(stats.increase.HP) .. " = " .. tostring(stats.current.HP + stats.increase.HP) .. "\n"
	.. "Attack: " ..tostring(stats.current.attack) .. " + " .. tostring(stats.increase.attack) .. " = " .. tostring(stats.current.attack + stats.increase.attack) .. "\n"
	.. "Defense: " ..tostring(stats.current.defense) .. " + " .. tostring(stats.increase.defense) .. " = " .. tostring(stats.current.defense + stats.increase.defense) .. "\n"
	.. "Speed: " ..tostring(stats.current.speed) .. " + " .. tostring(stats.increase.speed) .. " = " .. tostring(stats.current.speed + stats.increase.speed)
			
	self.textbox = Textbox(VIRTUAL_WIDTH - 100, VIRTUAL_HEIGHT - 64, 100, 64, msg, gFonts['small'])

    -- function to be called once this message is popped
    self.onClose = onClose or function() end

    -- whether we can detect input with this or not; true by default
    self.canInput = canInput

    -- default input to true if nothing was passed in
    if self.canInput == nil then self.canInput = true end
	
end

function LevelUpMenuState:update(dt)
    if self.canInput then
		self.textbox:update(dt)
		
		if self.textbox:isClosed() then
			gStateStack:pop()
			self.onClose()
		end
	end
end

function LevelUpMenuState:render()
    self.textbox:render()
end