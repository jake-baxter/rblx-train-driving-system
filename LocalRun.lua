--[[
	// **READ-ONLY**
	// FileName: LocalRun.lua
	// Written by: Jake Baxter
	// Version 1.0
	// Description: Local Script for Train Control (UI)

	// Contributors:
		
	

	// Required by:
		Local Players

	// Note: LOCAL SCRIPTS ONLY.
--]]


--//Variables
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VehicleSeat = game.Players.LocalPlayer.Character.Humanoid.SeatPart
local RemoteClientEvent = VehicleSeat["PlayerRemoteEvent"] --//At the top to cause an error if not.
local Velocity = 0
local RawSelf = {}
local finishedInit = false

--//Init function

local tempFunction = function() end
local tempFunction = RemoteClientEvent.OnClientEvent:connect(function(modName, classSelf)
    if not (modName == "Register") then
        return
    end

    RawSelf = classSelf
    finishedInit = true
    tempFunction:Disconnect()
end)
RemoteClientEvent:FireServer("Register", {})

repeat task.wait(1) until finishedInit --// We don't want to continue.

local basePart = RawSelf["basePart"]
local revBasePart = RawSelf["revBasePart"]
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
local maxSpeed = RawSelf["MaxPower"]


local targettedThrottle = 0
local targettedBrake = 0
local currentThrottle = 0
local currentBrake = 0

local debounce = {}
debounce.up = false
debounce.down = false


--//TO EDIT IF NECESARRY
local setVelocity = function()
    if isReversed == false then
        --//This uses hhwheats simple driving calculations. Change if you wish.
        local vectorpower = generalPower*basePart.CFrame.lookVector
        basePart["BodyVelocity"].MaxForce = Vector3.new(vectorpower.X>0 and vectorpower.X or -vectorpower.X,
            vectorpower.Y>0 and vectorpower.Y or -vectorpower.Y,
            vectorpower.Z>0 and vectorpower.Z or -vectorpower.Z
        )
        basePart["BodyVelocity"].Velocity = Velocity*basePart.CFrame.lookVector
    end
end

local function UpdateStatistics(delta)
	if currentThrottle > (targettedThrottle / throttle) then
		currentThrottle = math.clamp(currentThrottle - ((delta) / throttleIdleTime), 0, 1) -- down
		if currentThrottle < (targettedThrottle / throttle) then
			currentThrottle = (targettedThrottle / throttle)
		end
	end
	if currentThrottle < (targettedThrottle / throttle) then
		currentThrottle = math.clamp(currentThrottle + ((delta) / throttleFullTime), 0, 1) -- up
		if currentThrottle > (targettedThrottle / throttle) then
			currentThrottle = (targettedThrottle / throttle)
		end
	end
	if currentBrake > (targettedBrake/ brake) then
		currentBrake = math.clamp(currentBrake - ((delta) /brakeIdleTime), 0, 1) --down
		if currentBrake < (targettedBrake / brake) then
			currentBrake = (targettedBrake / brake)
		end
	end
	if currentBrake < (targettedBrake/ brake) then
		currentBrake = math.clamp(currentBrake + ((delta) /brakeFullTime), 0, 1)--up
		if currentBrake > (targettedBrake / brake) then
			currentBrake = (targettedBrake / brake)
		end
	end
end


local function PerformVelocityChanges(delta)
	Velocity = math.clamp((Velocity + (delta*currentThrottle*throttlePower) - (delta*currentBrake*brakePower)), 0, maxSpeed)
end


RunService.Heartbeat:connect(function(delta)
    UpdateStatistics(delta)
    PerformVelocityChanges(delta)
    setVelocity()
end)

UserInputService.InputBegan:connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        if debounce.up then
            return
        end
        math.clamp(targettedThrottle + (1/throttle), 0, 1)
    end
    if input.KeyCode == Enum.KeyCode.S then
        if debounce.up then
            return
        end
        math.clamp(targettedThrottle - (1/throttle), 0, 1)
    end
    if input.KeyCode == Enum.KeyCode.A then
        if debounce.down then
            return
        end
        math.clamp(targettedBrake + (1/brake), 0, 1)
    end
    if input.KeyCode == Enum.KeyCode.D then
        if debounce.down then
            return
        end
        math.clamp(targettedBrake - (1/brake), 0, 1)
    end
end)