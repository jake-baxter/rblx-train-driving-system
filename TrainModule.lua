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
local LocalModule = {}
LocalModule.__index = LocalModule


--// Main Function //

function TrainModule.new(trainModel, data)
	local classSelf = {}
	setmetatable(classSelf, LocalModule)
	classSelf.trainModel = trainModel
	classSelf.rawData = data
	classSelf.currentDriver = nil
	classSelf.reversed = false
	classSelf.canReverse = false
	classSelf.remoteEvent = nil
	classSelf.remoteFunction = nil
	local moduleEvent = Instance.new("BindableEvent")
	classSelf.Event = moduleEvent
	classSelf.baseStud = 1
	if not data["baseStud"] then
		classSelf.baseStud = data["baseStud"]
	end


	assert(data["vehicleSeat"], "Include Vehicle Seat Object Reference")
	if not (data["vehicleSeat"]:IsA("VehicleSeat")) then
		error("VehicleSeat must be a vehicle seat (Duh)!")
	end
	classSelf.vehicleSeat = data["vehicleSeat"]
	local tempRemoteEvent = Instance.new("RemoteEvent")
	tempRemoteEvent.Parent = data["vehicleSeat"]
	tempRemoteEvent.Name = "PlayerRemoteEvent"
	classSelf.remoteEvent = tempRemoteEvent


	assert(data["basePart"], "Include Base Part Object Reference")
	if not (data["basePart"]:IsA("BasePart")) then
		error("Base part must include your running base part!")
	end
	classSelf.basePart = data["basePart"]
	Instance.new("BodyVelocity", classSelf.basePart)
	classSelf.basePart.BodyVelocity.MaxForce = Vector3.new(0,0,0)
	classSelf.basePart.BodyVelocity.Velocity = Vector3.new(0,0,0)
	classSelf.basePart.BodyVelocity.P = 1250


	if (data["revBasePart"]) then
		if (data["revBasePart"]:IsA("BasePart")) then
			classSelf.revBasePart = data["revBasePart"]
			if (data["revVehicleSeat"]) then
				if (data["revVehicleSeat"]:IsA("VehicleSeat")) then
					classSelf.canReverse = true
					classSelf.revVehicleSeat = data["revVehicleSeat"]
				end
			end
		end
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


	if (data["bodyVelocityP"]) then
		if not (typeof(data["bodyVelocityP"]) == "number" and math.floor(data["bodyVelocityP"]) == data["bodyVelocityP"]) then
			error("bodyVelocityP must be an integer!")
		end
		if data["throttle"] < 1 then
			error("bodyVelocityP must be greater to or 1!")
		end
		classSelf.bodyVelocityP = data["bodyVelocityP"]
		classSelf.basePart.BodyVelocity.P = data["bodyVelocityP"]
	end


	classSelf.MaxPower = 50000
	if (data["MaxPower"]) then
		if not (typeof(data["MaxPower"]) == "number" and math.floor(data["MaxPower"]) == data["MaxPower"]) then
			error("MaxPower must be an integer!")
		end
		if data["throttle"] < 1 then
			error("MaxPower must be greater to or 1!")
		end
		classSelf.MaxPower = data["MaxPower"]
	end


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
		local tempScriptInit = tempScriptReferenceRequire.init(classSelf, moduleEvent.Event)
		table.insert(classSelf.modules, {required = tempScriptInit, name = tempScriptReferenceRequire.Name})
	end


	classSelf.functions = {}


	classSelf.functions.SeatRegister = classSelf.vehicleSeat.ChildAdded:connect(function(child)
		if not (child.Name == "SeatWeld") then
			return false
		end
		if not (child.Part1.Name == "HumanoidRootPart") then
			return false
		end
		local tempPlayerStore = game.Players:GetPlayerFromCharacter(child.Part1.Parent)
		if not (tempPlayerStore) then
			return false
		end
		local tempPlayerGui = classSelf["GUI"]:Clone()
		tempPlayerGui.Parent = tempPlayerStore.PlayerGui
		classSelf["currentDriver"] = tempPlayerStore
		classSelf.Event:Fire("base", {class = classSelf, action = "DriverIn", player = tempPlayerStore, UI = tempPlayerGui})
	end)


	classSelf.functions.SeatUnRegister = classSelf.vehicleSeat.ChildRemoved:connect(function(child)
		if not (child.Name == "SeatWeld") then
			return false
		end
		classSelf["currentDriver"] = nil
		classSelf.basePart.BodyVelocity.MaxForce = Vector3.new(0,0,0)
		classSelf.basePart.BodyVelocity.Velocity = Vector3.new(0,0,0)
		classSelf.basePart.BodyVelocity.P = 0
		classSelf.throttle = 0
		classSelf.Event:Fire("base", {class = classSelf, action = "DriverOut"})
	end)


	classSelf.functions.clientregister = classSelf.remoteEvent.OnServerEvent:connect(function(player, moduleName, TableR)
		if not (moduleName == "Register") then
			return false
		end
		if not (type(TableR) == "table") then
			return false
		end
		if not (player == classSelf.currentDriver) then
			return false
		end
		classSelf.remoteEvent:FireClient(player, moduleName, classSelf)
		classSelf.Event:Fire("base", {class = classSelf, action = "ClientRegistered", player = player})
	end)


	return classSelf
end


--// Main Function //


function LocalModule:GetDriver()
	return self.currentDriver
end


function LocalModule:EnableModule(moduleReference)
	if not (moduleReference:IsA("ModuleScript")) then
		return false
	end
	local tempScriptReferenceRequire = require(moduleReference)
	if not (tempScriptReferenceRequire.Version[0] == TrainModule.Version[0]) then
		return false
	end
	if not (tempScriptReferenceRequire.Version[1] == TrainModule.Version[1]) then
		return false
	end
	local tempScriptInit = tempScriptReferenceRequire.init(self, self.Event)
	table.insert(self.modules, {required = tempScriptInit, name = tempScriptReferenceRequire.Name})
	return true
end


function LocalModule:DisableModule(moduleReference)
	if not (type(moduleReference) == "string") then
		return false
	end
	for _,scriptReference in pairs(self.modules) do
		if not (scriptReference.name == moduleReference) then
			continue
		end
		scriptReference.required:OnDisable()
		table.remove(self.modules, table.find(self.modules, scriptReference))
		return true
	end
	return false
end


function LocalModule:ForceReverse()
	if self.revBasePart then
		if self.reversed == false then
			self.reversed = true
			local seat = self.vehicleSeat
			if self.revVehicleSeat then
				seat = self.revVehicleSeat
			end
			self:SendPlayerMessage("base", {
				action = "reversed",
				seat = seat
			})
			self.Event:Fire("base", {class = self, action = "Reversed", seat = seat})
			return true
		end
		if self.reversed == true then
			self.reversed = false
			self:SendPlayerMessage("base", {
				action = "reversed",
				seat = self.vehicleSeat
			})
			self.Event:Fire("base", {class = self, action = "Reversed", seat = self.vehicleSeat})
			return true
		end
	end
	return false
end


function LocalModule:SendMessage(moduleName, Table)
	self.Event:Fire(moduleName, Table)
	return true
end


function LocalModule:SendPlayerMessage(moduleName, Table)
	if self.remoteEvent then
		self.remoteEvent:Fire(self.currentDriver, moduleName, self, Table)
	end
	return true
end


return TrainModule