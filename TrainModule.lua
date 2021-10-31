--[[
	// **READ-ONLY**
	// FileName: TrainModule.lua
	// Written by: Jake Baxter
	// Version 1.0
	// Description: An API for train control in roblox.

	// Contributors:
		
	

	// Required by:
		Train Scripts

	// Note: for documentation see *inserting devforum link here*
--]]

local TrainModule = {}
TrainModule.Version = {1, 0, 0} --//Update per version
TrainModule.__index = TrainModule


--// Main Function //

function TrainModule.new(trainModel, data)
	local classSelf = {}
	setmetatable(classSelf, TrainModule)
	classSelf.trainModel = trainModel
	classSelf.rawData = data
	classSelf.baseStud = 1
	if not data["baseStud"] then
		classSelf.baseStud = data["baseStud"]
	end


	assert(data["vehicleSeat"], "Include Vehicle Seat Object Reference")
	if not (data["vehicleSeat"]:IsA("VehicleSeat")) then
		error("VehicleSeat must be a vehicle seat (Duh)!")
	end


	assert(data["throttle"], "Include Throttle Value")
	if not (typeof(data["throttle"]) == "number" and math.floor(data["throttle"]) == data["throttle"]) then
		error("Throttle must be an integer!")
	end
	if data["throttle"] < 1 then
		error("Throttle must be greater to or 1!")
	end
	classSelf.throttle = data["throttle"]


	assert(data["brake"], "Include Brake Value")
	if not (typeof(data["brake"]) == "number" and math.floor(data["brake"]) == data["brake"]) then
		error("Brake must be an integer!")
	end
	if data["brake"] < 1 then
		error("Brake must be greater to or 1!")
	end
	classSelf.brake = data["brake"]


	assert(data["throttlePower"], "Include Throttle Power Value")
	if not (typeof(data["throttlePower"]) == "number") then
		error("Throttle Power  must be a number!")
	end
	if data["throttlePower"] < 0 then
		error("Throttle Power must be greater than 0!")
	end
	classSelf.throttlePower = data["throttlePower"]


	assert(data["brakePower"], "Include Throttle Power Value")
	if not (typeof(data["brakePower"]) == "number") then
		error("Brake Power  must be a number!")
	end
	if data["brakePower"] < 0 then
		error("Brake Power must be greater than 0!")
	end
	classSelf.brakePower = data["brakePower"]


	assert(data["throttleFullTime"], "Include Throttle Up Time Value")
	if not (typeof(data["throttleFullTime"]) == "number") then
		error("Throttle Up Time  must be a number!")
	end
	if data["throttleFullTime"] < 0 then
		error("Throttle Up Time must be greater than 0!")
	end
	classSelf.throttleFullTime = data["throttleFullTime"]


	assert(data["throttleIdleTime"], "Include Throttle Down Time Value")
	if not (type(data["throttleIdleTime"]) == "number") then
		error("Throttle Down Time  must be a number!")
	end
	if data["throttleIdleTime"] < 0 then
		error("Throttle Down Time must be greater than 0!")
	end
	classSelf.throttleIdleTime = data["throttleIdleTime"]


	assert(data["brakeFullTime"], "Include Brake Up Time Value")
	if not (typeof(data["brakeFullTime"]) == "number") then
		error("Brake Up Time  must be a number!")
	end
	if data["brakeFullTime"] < 0 then
		error("Brake Up Time must be greater than 0!")
	end
	classSelf.brakeFullTime = data["brakeFullTime"]


	assert(data["brakeIdleTime"], "Brake Throttle Down Time Value")
	if not (typeof(data["brakeIdleTime"]) == "number") then
		error("Brake Down Time  must be a number!")
	end
	if data["brakeIdleTime"] < 0 then
		error("Brake Down Time must be greater than 0!")
	end
	classSelf.brakeIdleTime = data["brakeIdleTime"]


	assert(data["GUI"], "There must be a GUI set!")
	if not (typeof(data["GUI"]) == "Instance") then
		error("GUI needs to be a ScreenGUI instance!")
	end
	if not (data["GUI"]:IsA("ScreenGUI")) then
		error("GUI needs to be a ScreenGUI instance!")
	end


	assert(data["customModules"], "There must be a GUI set!")
	if not(type(data["customModules"]) == "table") then
		error("customModules must be a table!")
	end
	classSelf.modules = {}
	for _, scriptReference in pairs(data["customModules"]) do
		if not (scriptReference:IsA("ModuleScript")) then
			continue
		end
		local tempScriptReferenceRequire = require(scriptReference)
		if not (tempScriptReferenceRequire.Version[0] == TrainModule.Version[0]) then
			continue
		end
		if not (tempScriptReferenceRequire.Version[1] == TrainModule.Version[1]) then
			continue
		end
		local tempScriptInit = tempScriptReferenceRequire.init()
		table.insert(classSelf.modules, {required = tempScriptInit, name = tempScriptReferenceRequire.Name})
	end
end

return TrainModule