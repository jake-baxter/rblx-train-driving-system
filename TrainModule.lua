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

	assert(data["throttle"], "Include Throttle Value")
	if not (type(data["throttle"]) == "int") then
		error("Throttle must be an integer!")
	end
	if data["throttle"] < 1 then
		error("Throttle must be greater to or 1!")
	end
	classSelf.throttle = data["throttle"]


	assert(data["brake"], "Include Brake Value")
	if not (type(data["brake"]) == "int") then
		error("Brake must be an integer!")
	end
	if data["brake"] < 1 then
		error("Brake must be greater to or 1!")
	end
	classSelf.brake = data["brake"]


	assert(data["throttlePower"], "Include Throttle Power Value")
	if not (type(data["throttlePower"]) == "int" or type(data["throttlePower"]) == "number" or type(data["throttlePower"]) == "float") then
		error("Throttle Power  must be a number / int / float!")
	end
	if data["throttlePower"] < 0 then
		error("Throttle Power must be greater than 0!")
	end
	classSelf.throttlePower = data["throttlePower"]


	assert(data["brakePower"], "Include Throttle Power Value")
	if not (type(data["brakePower"]) == "int" or type(data["brakePower"]) == "number" or type(data["brakePower"]) == "float") then
		error("Brake Power  must be a number / int / float!")
	end
	if data["brakePower"] < 0 then
		error("Brake Power must be greater than 0!")
	end
	classSelf.brakePower = data["brakePower"]


	assert(data["throttleFullTime"], "Include Throttle Up Time Value")
	if not (type(data["throttleFullTime"]) == "int" or type(data["throttleFullTime"]) == "number" or type(data["throttleFullTime"]) == "float") then
		error("Throttle Up Time  must be a number / int / float!")
	end
	if data["throttleFullTime"] < 0 then
		error("Throttle Up Time must be greater than 0!")
	end
	classSelf.throttleFullTime = data["throttleFullTime"]


	assert(data["throttleIdleTime"], "Include Throttle Down Time Value")
	if not (type(data["throttleIdleTime"]) == "int" or type(data["throttleIdleTime"]) == "number" or type(data["throttleIdleTime"]) == "float") then
		error("Throttle Down Time  must be a number / int / float!")
	end
	if data["throttleIdleTime"] < 0 then
		error("Throttle Down Time must be greater than 0!")
	end
	classSelf.throttleIdleTime = data["throttleIdleTime"]


	assert(data["brakeFullTime"], "Include Brake Up Time Value")
	if not (type(data["brakeFullTime"]) == "int" or type(data["brakeFullTime"]) == "number" or type(data["brakeFullTime"]) == "float") then
		error("Brake Up Time  must be a number / int / float!")
	end
	if data["brakeFullTime"] < 0 then
		error("Brake Up Time must be greater than 0!")
	end
	classSelf.brakeFullTime = data["brakeFullTime"]


	assert(data["brakeIdleTime"], "Brake Throttle Down Time Value")
	if not (type(data["brakeIdleTime"]) == "int" or type(data["brakeIdleTime"]) == "number" or type(data["brakeIdleTime"]) == "float") then
		error("Brake Down Time  must be a number / int / float!")
	end
	if data["brakeIdleTime"] < 0 then
		error("Brake Down Time must be greater than 0!")
	end
	classSelf.brakeIdleTime = data["brakeIdleTime"]
end

return TrainModule