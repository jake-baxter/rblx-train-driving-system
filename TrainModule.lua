--[[
	// **READ-ONLY**
	// FileName: TrainModule.lua
	// Written by: Jake Baxter
	// Version v0.0.0-alpha.4
	// Description: An API for train control in roblox.

	// Contributors:
		
	

	// Required by:
		Train Scripts

	// Note: for documentation see *inserting devforum link here*
--]]

local TrainModule = {}
TrainModule.Version = {0, 0, 0} --//Update per version
TrainModule.__index = TrainModule
local LocalModule = {}
LocalModule.__index = LocalModule


--// Main Function //

function TrainModule.new(trainModel, data)
	local classSelf = {}
	setmetatable(classSelf, LocalModule)
	classSelf.Properties = {}
	classSelf.Properties.trainModel = trainModel
	classSelf.Properties.rawData = data
	classSelf.Properties.currentDriver = nil
	classSelf.Properties.reversed = false
	classSelf.Properties.canReverse = false
	classSelf.Properties.remoteEvent = nil
	classSelf.Properties.remoteFunction = nil
	classSelf.Properties.Anchored = true
	classSelf.Properties.UIEnabled = true
	local moduleEvent = Instance.new("BindableEvent")
	classSelf.Properties.Event = moduleEvent
	classSelf.Properties.baseStud = 1
	if not data["baseStud"] then
		classSelf.Properties.baseStud = data["baseStud"]
	end


	assert(data["vehicleSeat"], "Include Vehicle Seat Object Reference")
	if not (data["vehicleSeat"]:IsA("VehicleSeat") or data["vehicleSeat"]:IsA("Seat")) then
		error("VehicleSeat must be a vehicle seat (Duh)!")
	end
	classSelf.Properties.vehicleSeat = data["vehicleSeat"]
	local tempRemoteEvent = Instance.new("RemoteEvent")
	tempRemoteEvent.Parent = data["vehicleSeat"]
	tempRemoteEvent.Name = "PlayerRemoteEvent"
	classSelf.Properties.remoteEvent = tempRemoteEvent


	assert(data["basePart"], "Include Base Part Object Reference")
	if not (data["basePart"]:IsA("BasePart") or type(data["basePart"]) == "table") then
		error("Base part must include your running base part!")
	end
	if data["basePart"]:IsA("BasePart") then
		classSelf.Properties.baseParts = {data["basePart"]}
	end
	if type(data["basePart"]) == "table" then
		classSelf.Properties.baseParts = data["basePart"]
	end
	classSelf:IterateBodyVelocity(function(mover)
		if not data["MoverType"] then
			Instance.new("BodyVelocity", mover)
			mover.MaxForce = Vector3.new(0,0,0)
			mover.Velocity = Vector3.new(0,0,0)
			mover.P = 1250
			classSelf["MoverType"] = "BodyVelocity"
		end
		if data["MoverType"] == "BodyVelocity" then
			Instance.new("BodyVelocity", mover)
			mover.MaxForce = Vector3.new(0,0,0)
			mover.Velocity = Vector3.new(0,0,0)
			mover.P = 1250
			classSelf["MoverType"] = "BodyVelocity"
		end
		if data["MoverType"] == "BaseVelocity" then
			classSelf["MoverType"] = "BaseVelocity"
		end
		if data["MoverType"] == "LinearVelocity" then
			classSelf["MoverType"] = "LinearVelocity"
		end
	end)

	


	if (data["revVehicleSeat"]) then
		if (data["revVehicleSeat"]:IsA("VehicleSeat")) then
			classSelf.Properties.canReverse = true
			classSelf.Properties.revVehicleSeat = data["revVehicleSeat"]
		end
	end


	assert(data["throttle"], "Include Throttle Value")
	if not (typeof(data["throttle"]) == "number" and math.floor(data["throttle"]) == data["throttle"]) then
		error("Throttle must be an integer!")
	end
	if data["throttle"] < 1 then
		error("Throttle must be greater to or 1!")
	end
	classSelf.Properties.throttle = data["throttle"]


	assert(data["brake"], "Include Brake Value")
	if not (typeof(data["brake"]) == "number" and math.floor(data["brake"]) == data["brake"]) then
		error("Brake must be an integer!")
	end
	if data["brake"] < 1 then
		error("Brake must be greater to or 1!")
	end
	classSelf.Properties.brake = data["brake"]


	assert(data["throttlePower"], "Include Throttle Power Value")
	if not (typeof(data["throttlePower"]) == "number") then
		error("Throttle Power  must be a number!")
	end
	if data["throttlePower"] < 0 then
		error("Throttle Power must be greater than 0!")
	end
	classSelf.Properties.throttlePower = data["throttlePower"]


	assert(data["brakePower"], "Include Throttle Power Value")
	if not (typeof(data["brakePower"]) == "number") then
		error("Brake Power  must be a number!")
	end
	if data["brakePower"] < 0 then
		error("Brake Power must be greater than 0!")
	end
	classSelf.Properties.brakePower = data["brakePower"]


	assert(data["throttleFullTime"], "Include Throttle Up Time Value")
	if not (typeof(data["throttleFullTime"]) == "number") then
		error("Throttle Up Time  must be a number!")
	end
	if data["throttleFullTime"] < 0 then
		error("Throttle Up Time must be greater than 0!")
	end
	classSelf.Properties.throttleFullTime = data["throttleFullTime"]


	assert(data["throttleIdleTime"], "Include Throttle Down Time Value")
	if not (type(data["throttleIdleTime"]) == "number") then
		error("Throttle Down Time  must be a number!")
	end
	if data["throttleIdleTime"] < 0 then
		error("Throttle Down Time must be greater than 0!")
	end
	classSelf.Properties.throttleIdleTime = data["throttleIdleTime"]



	assert(data["brakeFullTime"], "Include Brake Up Time Value")
	if not (typeof(data["brakeFullTime"]) == "number") then
		error("Brake Up Time  must be a number!")
	end
	if data["brakeFullTime"] < 0 then
		error("Brake Up Time must be greater than 0!")
	end
	classSelf.Properties.brakeFullTime = data["brakeFullTime"]


	assert(data["brakeIdleTime"], "Brake Throttle Down Time Value")
	if not (typeof(data["brakeIdleTime"]) == "number") then
		error("Brake Down Time  must be a number!")
	end
	if data["brakeIdleTime"] < 0 then
		error("Brake Down Time must be greater than 0!")
	end
	classSelf.Properties.brakeIdleTime = data["brakeIdleTime"]


	assert(data["maxSpeed"], "maxSpeed Value")
	if not (typeof(data["maxSpeed"]) == "number") then
		error("maxSpeed  must be a number!")
	end
	if data["maxSpeed"] < 0 then
		error("maxSpeed must be greater than 0!")
	end
	classSelf.Properties.maxSpeed = data["maxSpeed"]


	if (data["bodyVelocityP"]) then
		if not (typeof(data["bodyVelocityP"]) == "number" and math.floor(data["bodyVelocityP"]) == data["bodyVelocityP"]) then
			error("bodyVelocityP must be an integer!")
		end
		if data["throttle"] < 1 then
			error("bodyVelocityP must be greater to or 1!")
		end
		classSelf.Properties.bodyVelocityP = data["bodyVelocityP"]
		classSelf:IterateBodyVelocity(function(mover)
			mover.P = data["bodyVelocityP"]
		end)
	end


	classSelf.Properties.MaxPower = 100000
	if (data["MaxPower"]) then
		if not (typeof(data["MaxPower"]) == "number" and math.floor(data["MaxPower"]) == data["MaxPower"]) then
			error("MaxPower must be an integer!")
		end
		if data["throttle"] < 1 then
			error("MaxPower must be greater to or 1!")
		end
		classSelf.Properties.MaxPower = data["MaxPower"]
	end


	assert(data["GUI"], "There must be a GUI set!")
	if not (typeof(data["GUI"]) == "Instance") then
		error("GUI needs to be a ScreenGUI instance!")
	end
	if not (data["GUI"]:IsA("ScreenGui")) then
		error("GUI needs to be a ScreenGUI instance!")
	end
	classSelf.Properties["GUI"] = data["GUI"]


	classSelf.modules = {}
	if (data["customModules"]) then
		if not(type(data["customModules"]) == "table") then
			error("customModules must be a table!")
		end
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
	end


	classSelf.functions = {}


	classSelf.functions.SeatRegister = classSelf.Properties.vehicleSeat.ChildAdded:connect(function(child)
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
		local tempPlayerGui
		if classSelf.Properties.UIEnabled then
			tempPlayerGui = classSelf.Properties["GUI"]:Clone()
			tempPlayerGui.Parent = tempPlayerStore.PlayerGui
		end
		classSelf["currentDriver"] = tempPlayerStore
		classSelf:UnanchorTrain()
		classSelf.Properties.Event:Fire("base", {class = classSelf, action = "DriverIn", player = tempPlayerStore, UI = tempPlayerGui})
	end)


	classSelf.functions.SeatUnRegister = classSelf.Properties.vehicleSeat.ChildRemoved:connect(function(child)
		if not (child.Name == "SeatWeld") then
			return false
		end
		classSelf["currentDriver"] = nil
		classSelf:IterateBodyVelocity(function(mover)
			mover.MaxForce = Vector3.new(0,0,0)
			mover.Velocity = Vector3.new(0,0,0)
		end)
		classSelf.Properties.throttle = 0
		classSelf:AnchorTrain()
		classSelf.Properties.Event:Fire("base", {class = classSelf, action = "DriverOut"})
	end)


	classSelf.functions.clientregister = classSelf.Properties.remoteEvent.OnServerEvent:connect(function(player, moduleName, TableR)
		if not (moduleName == "Register") then
			return false
		end
		if not (type(TableR) == "table") then
			return false
		end
		if not (player == classSelf.currentDriver) then
			return false
		end
		classSelf.Properties.remoteEvent:FireClient(player, moduleName, classSelf)
		classSelf.Properties.Event:Fire("base", {class = classSelf, action = "ClientRegistered", player = player})
	end)


	for _,basePartsUnanchor in pairs(trainModel:GetDescendants()) do
		if basePartsUnanchor:IsA("BasePart") then
			basePartsUnanchor.Anchored = true
		end
	end


	return classSelf
end


--// Main Function //


function LocalModule:GetDriver()
	return self.Properties.currentDriver
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
	local tempScriptInit = tempScriptReferenceRequire.init(self, self.Properties.Event)
	table.insert(self.modules, {required = tempScriptInit, name = tempScriptReferenceRequire.Name})
	return true
end


function LocalModule:DisableModule(moduleName)
	if not (type(moduleName) == "string") then
		return false
	end
	for _,scriptReference in pairs(self.modules) do
		if not (scriptReference.name == moduleName) then
			continue
		end
		scriptReference.required:OnDisable()
		table.remove(self.modules, table.find(self.modules, scriptReference))
		return true
	end
	return false
end

function LocalModule:GetModule(moduleName)
	for _,scriptReference in pairs(self.modules) do
		if (scriptReference.name == moduleName) then
			return scriptReference.required
		end
		return nil
	end
end

function LocalModule:ForceReverse()
	if self.Properties.canReverse then
		if self.Properties.reversed == false then
			self.Properties.reversed = true
			local seat = self.Properties.vehicleSeat
			if self.Properties.revVehicleSeat then
				seat = self.Properties.revVehicleSeat
			end
			self:SendPlayerMessage("base", {
				action = "reversed",
				seat = seat
			})
			self.Properties.Event:Fire("base", {class = self, action = "Reversed", seat = seat})
			return true
		end
		if self.Properties.reversed == true then
			self.Properties.reversed = false
			self:SendPlayerMessage("base", {
				action = "reversed",
				seat = self.vehicleSeat
			})
			self.Properties.Event:Fire("base", {class = self, action = "Reversed", seat = self.vehicleSeat})
			return true
		end
	end
	return false
end


function LocalModule:SendMessage(moduleName, Table)
	self.Properties.Event:Fire(moduleName, Table)
	return true
end


function LocalModule:SendPlayerMessage(moduleName, Table)
	if self.Properties.remoteEvent and self.Properties.currentDriver then
		self.Properties.remoteEvent:Fire(self.Properties.currentDriver, moduleName, self, Table)
		return true
	end
	return false
end


function LocalModule:GetClientEventConnection()
	return self.Properties.remoteEvent.OnServerEvent
end


function LocalModule:GetServerEventConnection()
	return self.Properties.Event.Event
end


function LocalModule:UnanchorTrain()
	for _,basePartsUnanchor in pairs(self.Properties.trainModel:GetDescendants()) do
		if basePartsUnanchor:IsA("BasePart") then
			basePartsUnanchor.Properties.Anchored = false
		end
	end

	for _,basePartsUnanchor in pairs(self.Properties.trainModel:GetDescendants()) do
		if basePartsUnanchor:IsA("BasePart") then
			if basePartsUnanchor:CanSetNetworkOwnership() then
				basePartsUnanchor:SetNetworkOwner(self.Properties.currentDriver)
			end
		end
	end

	self.Properties.Anchored = false
	return true
end


function LocalModule:AnchorTrain()
	for _,basePartsUnanchor in pairs(self.Properties.trainModel:GetDescendants()) do
		if basePartsUnanchor:IsA("BasePart") then
			basePartsUnanchor.Properties.Anchored = true
		end
	end
	self.Properties.Anchored = true
	return true
end


function LocalModule:IsAnchored()
	return self.Properties.Anchored
end


function LocalModule:DisableDefaultUI()
	self.Properties.UIEnabled = false
	return true
end


function LocalModule:EnableDefaultUI()
	self.Properties.UIEnabled = true
	return true
end

function LocalModule:IterateBodyVelocity(BodyVelFunc)
	if not self then
		return false
	end
	if not self.Properties.baseParts then
		return false
	end
	if not BodyVelFunc then
		return false
	end
	for _,basePart in pairs(self.Properties.baseParts) do
		if basePart:FindFirstChild("BodyVelocity") then
			BodyVelFunc(basePart:FindFirstChild("BodyVelocity"))
		end
	end
end

function LocalModule:GetProperty(property)
	return self.Properties[property]
end


return TrainModule