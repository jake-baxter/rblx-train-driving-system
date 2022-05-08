--[[
	// FileName: CustomUI.lua
	// Written by: Jake Baxter
	// Version: v0.0.0-alpha.2
	// Description: CustomUI builder that generates a driving UI

	// Contributors:
        
--]]

local Plugin = {}
Plugin.Name = "CustomUI"
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

    table.insert(classSelf.RegisteredFunctions, superiorSelf:GetServerEventConnection():connect(function(ModuleName, SentData)
        if ModuleName == "base" then
            return false
        end
        if not(type(SentData) == "table") then
            return false
        end
        if not (SentData["action"] == "DriverIn") then
            return false
        end
        local EnteredDriver = SentData["player"]
        local PlayerGui = EnteredDriver["PlayerGui"]
        local trainUi = Instance.new("ScreenGui")
        trainUi.Name = "TrainGui"
        trainUi.ResetOnSpawn = false
        trainUi.Parent = PlayerGui
        LocalScriptCopy:Clone().Parent = trainUi
    end))
    superiorSelf.UIEnabled = false
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
    if not self.superiorSelf.UIEnabled then
        self.superiorSelf.UIEnabled = true
    end
	return true
end


return Plugin