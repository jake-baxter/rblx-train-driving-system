--[[
	// FileName: LocalScript.lua
	// Written by: Jake Baxter
	// Version: v0.0.0-alpha.3
	// Description: NWSpacek Local Rod System Modified For RBLX-train-driving-system

	// Contributors:
        NWSpacek (Not officially)
--]]


local loco = script:WaitForChild("loco").Value
local Gears = loco
task.wait(1)
if not loco then
	return false
end
local TableOfValues = game:GetService("HttpService"):JSONDecode(script:GetAttribute("Data"))
if not TableOfValues then
	return false
end
--MADE BY NWSPACEK

-- Edit these variables! The script will take care of the rest.
-- Please have the AHandle part's Front face the front of the locomotive.
-- Please have all parts oriented the same way as AHandle.
-- Please use the same part names.

-- This script is meant for locomotives with internal pistons: no crosshead or connecting rod is animated with this script.

--NOTE: when naming the wheels, the convention is as follows:
--[[
	"wheel" -- the crank
	"1" or "2" -- the side the crank goes on. 1 is left, 2 is right
	"-7.2" -- the distance fore or aft that the crank is located. Positive is towards the rear of the loco.
--]]

-- Also: the wheels must face the same orientation as AHandle ///when the crank pin is in the upwards orientation./// <-- very important

local LODRenderThreshold = TableOfValues.LODRenderThreshold -- the distance at which the animation disappears

local DimensionScaleFactor = TableOfValues.DimensionScaleFactor --scale all dimensions by this factor (useful when resizing models)

--[[ Configuring the motion ]]--
local PartsAreReversed = TableOfValues.PartsAreReversed -- If the parts are set up where Front is at the rear of the loco
local DriverDiameter = TableOfValues.DriverDiameter -- the diameter of the drivers (maps to [2*WheelRadius] of legacy scripts)
local FrontDiameter = TableOfValues.FrontDiameter -- the diameter of the leading wheels
local BackDiameter = TableOfValues.BackDiameter -- the diameter of the trailing wheels
local RodRadius = TableOfValues.RodRadius -- the distance the rods are from the center of the wheel
local CylinderVerticalOffset = TableOfValues.CylinderVerticalOffset -- The vertical distance between the axle and the crosshead pin. Positive is up
local CylinderAngle = TableOfValues.CylinderAngle -- the angle of inclination of the cylinders, in radians. Positive rotates up
local ConnectingLength = TableOfValues.ConnectingLength -- the length of the connecting rod (maps to [ConRodPoint1-ConRodPoint2] of legacy scripts)

-- [[ Configuring the parts ]]--

-- Coupling Rod
local CopRodXOffset = TableOfValues.CopRodXOffset -- The distance from the centerline of the locomotive to the Coupling Rod part. Always positive
local CopRodYOffset = TableOfValues.CopRodYOffset -- The vertical offset of the Coupling Rod part from the coupling rod. Positive is up
local CopRodZOffset = TableOfValues.CopRodZOffset -- The horizontal offset of the Coupling Rod part from the coupling rod. Positive is forward (maps to [-RodOffset] of legacy scripts)

-- Connecting rod
local ConRodXOffset = TableOfValues.ConRodXOffset -- The distance from the centerline of the locomotive to the Connecting Rod part. Always positive
local ConRodYOffset = TableOfValues.ConRodYOffset -- The vertical distance from the center of the connecting rod to the Connecting Rod part. Positive is up
local ConRodZOffset = TableOfValues.ConRodZOffset -- The horizontal distance from the crank pin to the Connecting Rod part. Always positve (maps to [ConRodPoint1] of legacy scripts)

-- Crosshead
local CrossheadXOffset = TableOfValues.CrossheadXOffset -- The distance from the centerline of the locomotive to the Crosshead part. Always positive
local CrossheadYOffset = TableOfValues.CrossheadYOffset -- The vertical distance from the crosshead pin to the Crosshead part. Positive is up
local CrossheadZOffset = TableOfValues.CrossheadZOffset -- The Horizontal offset of from the crosshead pin to the Crosshead part. Positive is forward (maps to [CrossheadPoint1] of legacy scripts)

-- Driver wheels
local DriverXOffset = TableOfValues.DriverXOffset -- the distance from the centerline of the locomotive to the Wheel parts. Always positive

-- Leading wheels
local FrontXOffset = TableOfValues.FrontXOffset -- the distance from the centerline of the locomotive to the Front wheel parts. Always positive
local FrontYOffset = FrontDiameter*0.5-DriverDiameter*0.5 -- The vertical distance between the driver axle and the leading wheels' axles. Negative is down
if TableOfValues.FrontYOffset then
	FrontYOffset = TableOfValues.FrontYOffset
end
-- the default formula for FrontYOffset and BackYOffset will place the wheels on the rails based on the diameters of the wheels (as defined in the script above)

-- trailing wheels
local BackXOffset = TableOfValues.BackXOffset -- the distance from the centerline of the locomotive to the Back wheel parts. Always positive
local BackYOffset = BackDiameter*0.5-DriverDiameter*0.5 -- The vertical distance between the driver axle and the trailing wheels' axles. Negative is down
if TableOfValues.BackYOffset then
	BackYOffset = TableOfValues.BackYOffset
end



assert((LODRenderThreshold and DimensionScaleFactor and (PartsAreReversed == true or PartsAreReversed == false) and DriverDiameter and FrontDiameter and BackDiameter and RodRadius and CylinderVerticalOffset and CylinderAngle and ConnectingLength and CopRodXOffset and CopRodYOffset and CopRodZOffset and ConRodXOffset and ConRodYOffset and ConRodZOffset and CrossheadXOffset and CrossheadYOffset and CrossheadZOffset and DriverXOffset and FrontXOffset and FrontYOffset and BackXOffset and BackYOffset), "Values not set correctly")

--[[ Scaling all the properties to the Dimension Scale Factor]]--
RodRadius = RodRadius*DimensionScaleFactor
DriverDiameter, FrontDiameter, BackDiameter = DriverDiameter*DimensionScaleFactor, FrontDiameter*DimensionScaleFactor, BackDiameter*DimensionScaleFactor
CylinderVerticalOffset, ConnectingLength = CylinderVerticalOffset*DimensionScaleFactor, ConnectingLength*DimensionScaleFactor
CopRodXOffset, CopRodYOffset, CopRodZOffset = CopRodXOffset*DimensionScaleFactor,CopRodYOffset*DimensionScaleFactor,CopRodZOffset*DimensionScaleFactor
ConRodXOffset, ConRodYOffset, ConRodZOffset = ConRodXOffset*DimensionScaleFactor,ConRodYOffset*DimensionScaleFactor,ConRodZOffset*DimensionScaleFactor
CrossheadXOffset, CrossheadYOffset, CrossheadZOffset = CrossheadXOffset*DimensionScaleFactor,CrossheadYOffset*DimensionScaleFactor,CrossheadZOffset*DimensionScaleFactor
DriverXOffset, FrontXOffset, BackXOffset = DriverXOffset*DimensionScaleFactor, FrontXOffset*DimensionScaleFactor, BackXOffset*DimensionScaleFactor
FrontYOffset, BackYOffset = FrontYOffset*DimensionScaleFactor, BackYOffset*DimensionScaleFactor


local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Camera = workspace.CurrentCamera

local PlayerCurrentlyDriving = false

local cf = CFrame.new
local nc = cf()
local V2OS = nc.vectorToObjectSpace
local P2OS = nc.pointToObjectSpace
local v3 = Vector3.new
local dot = v3().Dot
local v2 = Vector2.new
local cos = math.cos
local sin = math.sin
local asin = math.asin
local pi = math.pi



if not Gears then
	script:Destroy()
	return
end

--[[ Collecting parts to animate ]]--

local LocalGearModel = Gears:Clone()
LocalGearModel.Parent = workspace.CurrentCamera
for _,j in ipairs (LocalGearModel:GetChildren()) do
	if j.Name == "AHandle" then
		j:Destroy()
	elseif j:IsA("BasePart") then
		j.Anchored = true
	end
end
for _,j in ipairs (Gears:GetChildren()) do
	if j:IsA("BasePart") then
		j.Transparency = 1
	end
end

local Anchor = Gears:FindFirstChild("AHandle")
local CrossheadLeft = LocalGearModel:FindFirstChild("Crosshead Left")
local CrossheadRight = LocalGearModel:FindFirstChild("Crosshead Right")
local CouplingRodLeft = LocalGearModel:FindFirstChild("Coupling Rod Left")
local CouplingRodRight = LocalGearModel:FindFirstChild("Coupling Rod Right")
local ConnectingRodLeft = LocalGearModel:FindFirstChild("Connecting Rod Left")
local ConnectingRodRight = LocalGearModel:FindFirstChild("Connecting Rod Right")

local DriverWheels = {}
local FrontWheels = {}
local BackWheels = {}

for _,part in ipairs (LocalGearModel:GetChildren()) do
	if part.Name:find("Wheel") then
		table.insert(DriverWheels,{
		Part = part,
		Side = tonumber(part.Name:sub(6,6)) or 1,
		Offset = (tonumber(part.Name:sub(7)) or 0)*DimensionScaleFactor,
	})
	elseif part.Name:find("Front") then
		table.insert(FrontWheels,{
		Part = part,
		Side = tonumber(part.Name:sub(6,6)) or 1,
		Offset = (tonumber(part.Name:sub(7)) or 0)*DimensionScaleFactor,
	})
	elseif part.Name:find("Back") then
		table.insert(BackWheels,{
		Part = part,
		Side = tonumber(part.Name:sub(5,5)) or 1,
		Offset = (tonumber(part.Name:sub(6)) or 0)*DimensionScaleFactor,
	})
	end
end
--[[ Animating the parts ]]--

local PreviousPosition = Anchor.Position
local DriverAngle = 0
local FrontAngle = 0
local BackAngle = 0

local LastRenderedAnchorPosition = Vector3.new(100000,0,0)
local LastWheelsInRange = true

local function update(t)
	
	local AnchorCFrame = Anchor:GetRenderCFrame()
	local Velocity = P2OS(AnchorCFrame,PreviousPosition).Z
	PreviousPosition = AnchorCFrame.p
	
	-- calculate the new angle of all the wheels	
	DriverAngle = DriverAngle-Velocity/DriverDiameter*2
	if DriverAngle > pi*2 then
		DriverAngle = DriverAngle - pi*2
	elseif DriverAngle < -pi*2 then
		DriverAngle = DriverAngle+pi*2
	end
	
	FrontAngle = FrontAngle-Velocity/FrontDiameter*2
	if FrontAngle > pi*2 then
		FrontAngle = FrontAngle - pi*2
	elseif FrontAngle < -pi*2 then
		FrontAngle = FrontAngle+pi*2
	end
	
	BackAngle = BackAngle-Velocity/FrontDiameter*2
	if BackAngle > pi*2 then
		BackAngle = BackAngle - pi*2
	elseif BackAngle < -pi*2 then
		BackAngle = BackAngle+pi*2
	end
	-- get the angles of the crank pins
	local Angles = {DriverAngle, DriverAngle+pi/2}
	
	-- now determine if we should animate in the first place
	local LocoDidMove = (LastRenderedAnchorPosition-PreviousPosition).magnitude > 0.05*t
	local DifferenceVector = PreviousPosition-Camera.CoordinateFrame.p
	local WheelsInRange = DifferenceVector.magnitude < 50 or dot(Camera.CoordinateFrame.lookVector,DifferenceVector.unit) > 0.1 and DifferenceVector.magnitude < LODRenderThreshold
	
	if LastWheelsInRange ~= WheelsInRange then
		local NewTransparency = WheelsInRange and 0 or 1
		for _,j in ipairs (LocalGearModel:GetChildren()) do
			j.Transparency = NewTransparency
		end
		for _,j in ipairs (Gears:GetChildren()) do
			j.Transparency = 1-NewTransparency
		end
	end
	
	if LocoDidMove or (WheelsInRange and not LastWheelsInRange) then
		-- lets animate some wheels!
		-- Step 1. Calculate the position of the crank pin
		local P1 = v2(cos(Angles[1])*RodRadius,sin(Angles[1])*RodRadius)
		local P2 = v2(cos(Angles[2])*RodRadius,sin(Angles[2])*RodRadius)
		-- Step 2. Place the Connecting Rod parts
		if CouplingRodLeft then
			if PartsAreReversed then
				CouplingRodLeft.CFrame = AnchorCFrame*cf(-CopRodXOffset,P1.X+CopRodYOffset,P1.Y-CopRodZOffset)*CFrame.Angles(0,pi,0)
			else
				CouplingRodLeft.CFrame = AnchorCFrame*cf(-CopRodXOffset,P1.X+CopRodYOffset,P1.Y-CopRodZOffset)
			end
		end
		if CouplingRodRight then
			if PartsAreReversed then
				CouplingRodRight.CFrame = AnchorCFrame*cf(CopRodXOffset,P2.X+CopRodYOffset,P2.Y-CopRodZOffset)*CFrame.Angles(0,pi,0)
			else
				CouplingRodRight.CFrame = AnchorCFrame*cf(CopRodXOffset,P2.X+CopRodYOffset,P2.Y-CopRodZOffset)
			end
		end
		-- Step 3. Determine the offset angle and compensate accordingly
		local AdjustedAnchorCFrame = AnchorCFrame
		if CylinderAngle ~= 0 then
			P1 = v2(cos(Angles[1]-CylinderAngle)*RodRadius,sin(Angles[1]-CylinderAngle)*RodRadius)
			P2 = v2(cos(Angles[2]-CylinderAngle)*RodRadius,sin(Angles[2]-CylinderAngle)*RodRadius)
			AdjustedAnchorCFrame = AnchorCFrame*CFrame.Angles(CylinderAngle,0,0)
		end
		-- Step 4. Determine the positions of the connecting rods and crossheads
		local AngleElevation1 = -asin((CylinderVerticalOffset-P1.X)/ConnectingLength)
		local AngleElevation2 = -asin((CylinderVerticalOffset-P2.X)/ConnectingLength)
		-- Step 5. Place the Connecting Rod parts and Crosshead parts
		if ConnectingRodLeft then
			if PartsAreReversed then
				ConnectingRodLeft.CFrame = AdjustedAnchorCFrame*cf(-ConRodXOffset,P1.X-sin(AngleElevation1)*ConRodZOffset+cos(AngleElevation1)*ConRodYOffset,P1.Y-cos(AngleElevation1)*ConRodZOffset+sin(AngleElevation1)*ConRodYOffset)*CFrame.Angles(-AngleElevation1,pi,0)
			else
				ConnectingRodLeft.CFrame = AdjustedAnchorCFrame*cf(-ConRodXOffset,P1.X-sin(AngleElevation1)*ConRodZOffset+cos(AngleElevation1)*ConRodYOffset,P1.Y-cos(AngleElevation1)*ConRodZOffset+sin(AngleElevation1)*ConRodYOffset)*CFrame.Angles(-AngleElevation1,0,0)
			end
		end
		if ConnectingRodRight then
			if PartsAreReversed then
				ConnectingRodRight.CFrame = AdjustedAnchorCFrame*cf(ConRodXOffset,P2.X-sin(AngleElevation2)*ConRodZOffset+cos(AngleElevation2)*ConRodYOffset,P2.Y-cos(AngleElevation2)*ConRodZOffset+sin(AngleElevation2)*ConRodYOffset)*CFrame.Angles(-AngleElevation2,pi,0)
			else
				ConnectingRodRight.CFrame = AdjustedAnchorCFrame*cf(ConRodXOffset,P2.X-sin(AngleElevation2)*ConRodZOffset+cos(AngleElevation2)*ConRodYOffset,P2.Y-cos(AngleElevation2)*ConRodZOffset+sin(AngleElevation2)*ConRodYOffset)*CFrame.Angles(-AngleElevation2,0,0)
			end
		end
		if CrossheadLeft then
			local CrossheadPosition1 = ConnectingLength*cos(AngleElevation1)-P1.Y
			if PartsAreReversed then
				CrossheadLeft.CFrame = AdjustedAnchorCFrame*cf(-CrossheadXOffset,CylinderVerticalOffset+CrossheadYOffset,-CrossheadPosition1-CrossheadZOffset)*CFrame.Angles(0,pi,0)
			else
				CrossheadLeft.CFrame = AdjustedAnchorCFrame*cf(-CrossheadXOffset,CylinderVerticalOffset+CrossheadYOffset,-CrossheadPosition1-CrossheadZOffset)
			end
		end
		if CrossheadRight then
			local CrossheadPosition2 = ConnectingLength*cos(AngleElevation2)-P2.Y
			if PartsAreReversed then
				CrossheadRight.CFrame = AdjustedAnchorCFrame*cf(CrossheadXOffset,CylinderVerticalOffset+CrossheadYOffset,-CrossheadPosition2-CrossheadZOffset)*CFrame.Angles(0,pi,0)
			else
				CrossheadRight.CFrame = AdjustedAnchorCFrame*cf(CrossheadXOffset,CylinderVerticalOffset+CrossheadYOffset,-CrossheadPosition2-CrossheadZOffset)
			end
		end
		-- Step 6. Place all the wheel parts
		for _,Wheel in ipairs (DriverWheels) do
			Wheel.Part.CFrame = AnchorCFrame*CFrame.new((Wheel.Side-1.5)*2*DriverXOffset,0,Wheel.Offset)*CFrame.Angles(Angles[Wheel.Side],0,0)
		end
		for _,Wheel in ipairs (FrontWheels) do
			Wheel.Part.CFrame = AnchorCFrame*CFrame.new((Wheel.Side-1.5)*2*FrontXOffset,FrontYOffset,Wheel.Offset)*CFrame.Angles(FrontAngle,0,0)
		end
		
		for _,Wheel in ipairs (BackWheels) do
			Wheel.Part.CFrame = AnchorCFrame*CFrame.new((Wheel.Side-1.5)*2*BackXOffset,BackYOffset,Wheel.Offset)*CFrame.Angles(BackAngle,0,0)
		end
		-- And that's all there is to it!
	end
	LastWheelsInRange = WheelsInRange
	LastRenderedAnchorPosition = PreviousPosition
end


local Heartbeat = game:GetService("RunService").RenderStepped
UpdateConnection = Heartbeat:connect(update)

--[[ Clean up the script if the locomotive is removed ]]--

local AncestorChange

AncestorChange = Anchor.AncestryChanged:connect(function(AncestorThatChanged,NewAncestry)
	if not NewAncestry then
		UpdateConnection:disconnect()
		AncestorChange:disconnect()
		LocalGearModel:Destroy()
		script:Destroy()
	end
end)