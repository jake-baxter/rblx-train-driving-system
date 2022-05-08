--[[
	// FileName: RodSystem.lua
	// Written by: Jake Baxter
	// Version: v0.0.0-alpha.2
	// Description: Prepares NWSpacek Rod System for driving system.

	// Contributors:
        
--]]

local Plugin = {}
Plugin.Name = "RodSystem"
Plugin.Version = {0, 0, 0} --//Change the first two numbers to the appropiate driving, the last one is optional for plugin identification
Plugin.__index = Plugin

function Plugin.init(superiorSelf, EventListener)
	local classSelf = {}
	setmetatable(classSelf, Plugin)


    local LocalScriptCopy = script:FindFirstChild("LocalScript")
    if not LocalScriptCopy then
        return Plugin
    end

	classSelf.superiorSelf = superiorSelf
    classSelf.RegisteredFunctions = {}








    
	return classSelf
end


function Plugin:OnDisable()
    if not self then
        return false
    end

    for _, functionsToDisable in pairs(self.RegisteredFunctions) do
        if (typeof(functionsToDisable) == "function") then
            functionsToDisable:Disconnect()
        end
    end

	return true
end


return Plugin