AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:SendComponentsToClient()
	self:SetNWString("Components", util.TableToJSON(self.Components, true))
end

function ENT:Initialize()
	self:SetModel("models/props/cs_office/computer_caseb.mdl")
	self:SetMaterial("models/debug/debugwhite")
	self:SetColor(Color(72, 72, 72))

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end

	self:SetPos(self:GetPos() - Vector(0, 0 , self:GetCollisionBounds().z))

	-- Required components to boot, set to true to disable a component
	self.Components = {
		["cpu"] = true,
		["gpu"] = true,
		["hdd"] = true,
		["motherboard"] = true,
		["opticaldrive"] = true,
		["psu"] = true,
		["ram"] = true,
	}

	-- Send componments table to clients
	self:SendComponentsToClient()

	-- Initialize some net variables
	self:SetPowerState(false)
	self:SetCPULoad(2)
	self:SetCPUTemp(20.0)
	self:SetMonitor(nil)

	-- Create fan sound
	self.fan = CreateSound(self, "ambient/tones/fan2_loop.wav")
end

function ENT:Touch(ent)
	-- Check if valid component touched PC
	if not (self.Components[ent:GetClass()] == nil) then
		-- Check if PC has component
		if self.Components[ent:GetClass()] == false then
			-- Add component
			self.Components[ent:GetClass()] = true
			-- Update client components
			self:SendComponentsToClient()
			ent:Remove()
		end
	end
end

function ENT:HasAllComponents()
	local i = false
	for k, v in pairs(self.Components) do
		if v == false then
			i = false
			break
		else
			i = true
		end
	end
	return i
end

function ENT:Use(act, cal)
	-- Check if PC has all required components
	if self:HasAllComponents() then
		if not timer.Exists("TogglePower") then
			timer.Create("TogglePower", 1, 1, function()
				-- Toggle power state of PC
				self:SetPowerState(!self:GetPowerState())
				-- Play/Stop fan sound according to PC power state
				if self:GetPowerState() then
					self.fan:Play()
					self.fan:ChangeVolume(0.1)
				else
					self.fan:FadeOut(2)
				end
			end)
		end
	end
end

function ENT:OnRemove()
	-- Stop sounds and remove timers
	self.fan:Stop()
	timer.Destroy("TogglePower")
	timer.Destroy("SysMonitor")
end

local cload = 2
local rcload = 0
local ctemp = 20
local fanspeed = 0

function ENT:FindClosestMonitor()
	local mon = nil
	local find = ents.FindInSphere(self:GetPos(), 50)
	if find then
		for k,v in pairs(find) do
			if v:GetClass() == "monitor" then
				if not mon then mon = v end
				if v:GetPos():Distance(self:GetPos()) < mon:GetPos():Distance(self:GetPos()) then
					mon = v
				end
			end
		end
	end
	return mon
end

function ENT:Think()
	-- Randomly change fanspeed/cpuload/cputemp and smooth changes
	if self.fan:IsPlaying() then
		self.fan:ChangePitch(60 + (195 * fanspeed))
		fanspeed = math.Clamp(Lerp(FrameTime() * 1.5, fanspeed, ctemp/92), 0, 100)
		cload = Lerp(FrameTime() * 2, cload, rcload)
		ctemp = Lerp(FrameTime() * 4, ctemp, (92 * (cload / 100)) + math.Rand(0, 1))
		if not timer.Exists("SysMonitor") then
			timer.Create("SysMonitor", 1, 1, function()
				rcload = math.random(-400, 400) * math.Rand(-3, 3)
				self:SetCPULoad(math.Clamp(cload, 2, 100))
				self:SetCPUTemp(math.Clamp(ctemp, 19, 92))
			end)
		end
	else
		-- Reset variables to off state
		cload = 2
		ctemp = 20
		fanspeed = 0
		self.fan:ChangePitch(60)
		self:SetCPULoad(2)
		self:SetCPUTemp(20.0)
	end

	-- Check if PC has monitor
	if not IsValid(self:GetMonitor()) then
		-- Set monitor to closest
		self:SetMonitor(self:FindClosestMonitor())
		-- Check if monitor still exists
		if IsValid(self:GetMonitor()) then
			-- Let monitor know its connected to this PC
			self:GetMonitor():SetComputer(self)
		end
	else
		-- Check if monitor still exists or is in range
		if IsValid(self:GetMonitor()) and self:GetMonitor():GetPos():Distance(self:GetPos()) > 50 then
			-- Remove monitor if out of range
			self:GetMonitor():SetComputer(nil)
			self:SetMonitor(nil)
		end
	end
end