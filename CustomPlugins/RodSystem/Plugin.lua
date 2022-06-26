--[[
	// FileName: RodSystem.lua
	// Written by: Jake Baxter
	// Version: v0.0.0-alpha.3
	// Description: Prepares NWSpacek Rod System for driving system. To learn how to use this check "rod values.txt" in the github.

	// Contributors:
        
--]]

local Plugin = {}
Plugin.GloballyAccessible = {}
Plugin.Name = "RodSystem"
Plugin.Version = {0, 0, 0} --//Change the first two numbers to the appropiate driving, the last one is optional for plugin identification
Plugin.__index = Plugin

local HttpService = game:GetService("HttpService")

local function addMyLocalScript(player, LocalScript)
	local localScript = LocalScript:Clone()
	local playerGui = player:WaitForChild("PlayerGui")
	local trainGui = player:FindFirstChild("PersistentTrainGui")
	if not trainGui then
		trainGui = Instance.new("ScreenGui")
		trainGui.Name = "PersistentTrainGui"
		trainGui.ResetOnSpawn = false
		trainGui.Parent = playerGui
	end
	localScript.Parent = trainGui
	return localScript
end

function Plugin.GloballyAccessible.init(superiorSelf, EventListener)
	local classSelf = {}
	setmetatable(classSelf, Plugin)


	local LocalScriptCopy = script:FindFirstChild("LocalScript")
	if not LocalScriptCopy then
		return Plugin
	end


	classSelf.ActiveLocos = {}
	classSelf.superiorSelf = superiorSelf
	classSelf.RegisteredFunctions = {}


	local AddLocoFunc =  superiorSelf:GetServerEventConnection():connect(function(ModuleName, SentData)
		if not (ModuleName == "RodSystem") then
			return false
		end

		if not(type(SentData) == "table") then
			warn("Incorrect Syntax for rods!")
			return false
		end

		if not (SentData["action"] == "AddLoco") then
			return false
		end

		if not (typeof(SentData["Model"]) == "Instance") then
			warn("Set Instance in rods 'Model'!")
			return false
		end


		if not (type(SentData["RodValues"]) == "table") then
			warn("Set Table As RodValues!")
			return false
		end

		if not (SentData["Model"]["Name"] == "Moving Parts") then
			warn("The model of what we're talking about must be called 'Moving Parts' (Rod Script)")
			return false
		end

		if classSelf.ActiveLocos[SentData["Model"]] then
			return false
		end

		classSelf.ActiveLocos[SentData["Model"]] = SentData

		for _,InGPlayers in pairs(game.Players:GetChildren()) do
			local ClonedLocalScript = addMyLocalScript(InGPlayers, LocalScriptCopy)
			if ClonedLocalScript then
				ClonedLocalScript:SetAttribute("Data", HttpService:JSONEncode(SentData["RodValues"]))
				local LocoValue = Instance.new("ObjectValue")
				LocoValue.Name = "loco"
				LocoValue.Value = SentData["Model"]
				LocoValue.Parent = ClonedLocalScript
			end
		end


	end)

	classSelf.RegisteredFunctions[AddLocoFunc] = true


	local PlayerJoined = game.Players.PlayerAdded:connect(function(plr)
		for MovingPartModels, MovingPartsData in pairs(classSelf.ActiveLocos) do
			local ClonedLocalScript = addMyLocalScript(plr, LocalScriptCopy)
			if ClonedLocalScript then
				ClonedLocalScript:SetAttribute("Data", HttpService:JSONEncode(MovingPartsData["RodValues"]))
				local LocoValue = Instance.new("ObjectValue")
				LocoValue.Name = "loco"
				LocoValue.Value = MovingPartModels
				LocoValue.Parent = ClonedLocalScript
			end
		end
	end)
	classSelf.RegisteredFunctions[PlayerJoined] = true



	return classSelf.GloballyAccessible
end


function Plugin.GloballyAccessible:OnDisable()
	if not self then
		return false
	end

	for functionsToDisable, _ in pairs(self.RegisteredFunctions) do
		if (typeof(functionsToDisable) == "function") then
			functionsToDisable:Disconnect()
		end
	end
	return true
end

Plugin.init = Plugin.GloballyAccessible.init

return Plugin