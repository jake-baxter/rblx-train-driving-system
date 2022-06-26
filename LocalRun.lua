--[[
	// **READ-ONLY**
	// FileName: LocalRun.lua
	// Written by: Jake Baxter
	// Version v0.0.0-alpha.6
	// Description: Local Script for Train Control (UI)

	// Contributors:
		bobsterjsdev (debug mode)
	

	// Required by:
		Local Players

	// Note: LOCAL SCRIPTS ONLY.
--]]


--//Variables
local VehicleSeat = game.Players.LocalPlayer.Character.Humanoid.SeatPart
local RemoteClientEvent = VehicleSeat["PlayerRemoteEvent"] --//At the top to cause an error if not.
local Velocity = 0
local RawSelf = {}
local finishedInit = false

--//Init function
VehicleSeat.AncestryChanged:connect(function()
    script.Parent:Destroy()
end)

VehicleSeat.ChildRemoved:connect(function(child)
    if not (child.Name == "SeatWeld") then
        return false
    end
    script.Parent:Destroy()
end)

local tempFunction = function() end
tempFunction = RemoteClientEvent.OnClientEvent:connect(function(modName, classSelf)
    if not (modName == "Register") then
        return
    end

    RawSelf = classSelf
    finishedInit = true
    tempFunction:Disconnect()
end)
RemoteClientEvent:FireServer("Register", {})

repeat task.wait(1) until finishedInit --// We don't want to continue.


local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local baseParts = RawSelf["baseParts"]
local throttle = RawSelf["throttle"]
local brake = RawSelf["brake"]
local throttlePower = RawSelf["throttlePower"]
local brakePower = RawSelf["brakePower"]
local throttleFullTime = RawSelf["throttleFullTime"]
local throttleIdleTime = RawSelf["throttleIdleTime"]
local brakeFullTime = RawSelf["brakeFullTime"]
local brakeIdleTime = RawSelf["brakeIdleTime"]
local isReversed = RawSelf["reversed"]
local generalPower = RawSelf["MaxPower"]
local maxSpeed = RawSelf["maxSpeed"]
local baseStud = RawSelf["baseStud"]
local developerMode = RawSelf["rawData"]["debugMode"]


local targettedThrottle = 0
local targettedBrake = 0
local currentThrottle = 0
local currentBrake = 0

local debounce = {}
debounce.up = false
debounce.down = false
debounce.keyboardsliderup = false
debounce.keyboardsliderdown = false
debounce.touchsliderup = false
debounce.touchsliderdown = false


local IterateBaseParts = function(func)
	for _,v in pairs(baseParts) do
		func(v)
	end
end

--//TO EDIT IF NECESARRY
local setVelocity = function(selectedVel)
    if isReversed == false then
        --//This uses hhwheats simple driving calculations. Change if you wish.
        local vectorpower = generalPower*selectedVel.CFrame.lookVector
        selectedVel["BodyVelocity"].MaxForce = Vector3.new(vectorpower.X>0 and vectorpower.X or -vectorpower.X,
            vectorpower.Y>0 and vectorpower.Y or -vectorpower.Y,
            vectorpower.Z>0 and vectorpower.Z or -vectorpower.Z
        )
        selectedVel["BodyVelocity"].Velocity = (Velocity)*selectedVel.CFrame.lookVector
    end
end

local function UpdateStatistics(delta)
	if currentThrottle > (targettedThrottle / throttle) then
		currentThrottle = math.clamp(currentThrottle - ((delta) / (throttleIdleTime)), (targettedThrottle/throttle), 1)
	end
	if currentThrottle < (targettedThrottle / throttle) then
		currentThrottle = math.clamp(currentThrottle + ((delta) / (throttleFullTime)), 0, (targettedThrottle/throttle))
	end
	if currentBrake > (targettedBrake / brake) then
		currentBrake = math.clamp(currentBrake - ((delta) / (brakeIdleTime)), (targettedBrake/brake), 1)
	end
	if currentBrake < (targettedBrake / brake) then
		currentBrake = math.clamp(currentBrake + ((delta) / (brakeFullTime)), 0, (targettedBrake/brake))
	end
end


local function PerformVelocityChanges(delta)
	Velocity = math.clamp((Velocity + (delta*currentThrottle*(throttlePower * baseStud)) - (delta*currentBrake*(brakePower*baseStud))), 0, maxSpeed*baseStud)
	IterateBaseParts(function(SelectedBasePart)
		if SelectedBasePart.Anchored == true then
        	Velocity = 0
    	end
	end)
    
end


RunService.Heartbeat:connect(function(delta)
    UpdateStatistics(delta)
    PerformVelocityChanges(delta)
	IterateBaseParts(function(selectedvelocity)
		setVelocity(selectedvelocity)
	end)
end)

UserInputService.InputBegan:connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        if debounce.up then
            return
        end
        targettedThrottle = math.clamp(targettedThrottle + 1, 0, throttle)
		RemoteClientEvent:FireServer("base", {action = "MovementUpdate", throttle = targettedThrottle, brake = targettedBrake})
    end
    if input.KeyCode == Enum.KeyCode.S then
        if debounce.up then
            return
        end
        targettedThrottle = math.clamp(targettedThrottle - 1, 0, throttle)
		RemoteClientEvent:FireServer("base", {action = "MovementUpdate", throttle = targettedThrottle, brake = targettedBrake})
    end
    if input.KeyCode == Enum.KeyCode.A then
        if debounce.down then
            return
        end
        targettedBrake = math.clamp(targettedBrake + 1, 0, brake)
		RemoteClientEvent:FireServer("base", {action = "MovementUpdate", throttle = targettedThrottle, brake = targettedBrake})
    end
    if input.KeyCode == Enum.KeyCode.D then
        if debounce.down then
            return
        end
        targettedBrake = math.clamp(targettedBrake - 1, 0, brake)
		RemoteClientEvent:FireServer("base", {action = "MovementUpdate", throttle = targettedThrottle, brake = targettedBrake})
    end
end)

if (developerMode) then
	local devModeFrame = Instance.new("Frame", script.Parent)
	devModeFrame.AnchorPoint = Vector2.new(0,1)
	devModeFrame.Position = UDim2.new(0,0,1,0)
	devModeFrame.Size = UDim2.new(0.2,0,0,100)
	local devModeThrottle = Instance.new("TextLabel", devModeFrame)
	devModeThrottle.Size = UDim2.new(1,0,0,33)
	local devModeBrake = Instance.new("TextLabel", devModeFrame)
	devModeBrake.Size = UDim2.new(1,0,0,33)
	devModeBrake.Position = UDim2.new(0,0,0,33)
	local devModeSpeed = Instance.new("TextLabel", devModeFrame)
	devModeSpeed.Size = UDim2.new(1,0,0,33)
	devModeSpeed.Position = UDim2.new(0,0,0,66)
	coroutine.wrap(function()
		while true do
			devModeThrottle.Text = "Throttle: "..tostring(currentThrottle).." - "..tostring(targettedThrottle)
			devModeBrake.Text = "Brake: "..tostring(currentBrake).." - "..tostring(targettedBrake)
			devModeSpeed.Text = "Speed: "..tostring(Velocity)
			wait(.1)
		end
	end) ()
end
