AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local cookers = {
	"models/props_c17/furniturestove001a.mdl",
}

local mugs = {
	"models/props_junk/garbage_coffeemug001a.mdl",
	"models/props/cs_office/coffee_mug.mdl",
	"models/props/cs_office/coffee_mug2.mdl",
	"models/props/cs_office/coffee_mug3.mdl",
}

local ActiveMugs = {}

function ENT:Initialize()
	self:SetModel("models/props_interiors/pot01a.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(.5)
	end

	self:SetPos(self:GetPos() - Vector(0, 0 , self:GetCollisionBounds().z))

	self:SetTemp(20)
	self:SetIsBoiling(false)
	self:SetHasHobPoints(false)
	self:SetCooker(nil)
	self:SetActiveHob(nil)
	self:SetIsPouring(false)
end

function IsCooker(ent)
	local iscooker = false
	
	for _,v in pairs(cookers) do
		if ent:GetModel() == v then
			iscooker = true
			break
		end
	end

	return iscooker
end

function ENT:FindCooker()
	local nearestCooker = ents.FindInSphere(self:GetPos(), 10)
	if nearestCooker then
		for _,v in pairs(nearestCooker) do
			if IsValid(v) then
				if IsCooker(v) then
					self:SetCooker(v)
					v:SetVar("HasKettle", true)
					break
				end
			end
		end
	end
end

function IsMug(ent)
	local ismug = false
	
	for _,v in pairs(mugs) do
		if ent:GetModel() == v then
			ismug = true
			break
		end
	end

	return ismug
end

function ENT:FindMugs()
	local nearestMugs = ents.FindInSphere(self:GetPos(), 50)
	if nearestMugs then
		for _,v in pairs(nearestMugs) do
			if IsValid(v) then
				if IsMug(v) then
					if table.HasValue(ActiveMugs, v) then break end
					table.insert(ActiveMugs, v)
				end
			end
		end
	end
	for _,v in pairs(ActiveMugs) do
		if not IsValid(v) then
			table.RemoveByValue(ActiveMugs, v)
		end
	end
end

function ENT:SetupHobs()
	if self:GetCooker():GetModel() == cookers[1] then
		if not self:GetHasHobPoints() and not self:GetCooker():GetVar("NumHobs") then
			for i = 1, 4 do
				local cook = self:GetCooker()
				cook:SetVar("hob" .. i, ents.Create("prop_physics"))
				cook:GetVar("hob" .. i):SetModel("models/hunter/plates/plate025x025.mdl")
				-- models/hunter/plates/plate05x05.mdl -- Use to find pos -- GetUp * 18.5
				cook:GetVar("hob" .. i):SetMaterial("models/debug/debugwhite")
				cook:GetVar("hob" .. i):SetColor(Color(0, 0, 0, 0))
				cook:GetVar("hob" .. i):SetAngles(cook:GetAngles())
				cook:GetVar("hob" .. i):SetRenderMode(RENDERMODE_TRANSCOLOR)

				if i == 1 then
					cook:GetVar("hob" .. i):SetPos(cook:GetPos() +
						cook:GetUp() * 19.5 +
						cook:GetRight() * 11.5 +
						cook:GetForward() * 2.76)
				elseif i == 2 then
					cook:GetVar("hob" .. i):SetPos(cook:GetPos() +
						cook:GetUp() * 19.5 +
						cook:GetRight() * -11.2 +
						cook:GetForward() * 2.76)
				elseif i == 3 then
					cook:GetVar("hob" .. i):SetPos(cook:GetPos() +
						cook:GetUp() * 19.5 +
						cook:GetRight() * 11.5 +
						cook:GetForward() * -9.7)
				elseif i == 4 then
					cook:GetVar("hob" .. i):SetPos(cook:GetPos() +
						cook:GetUp() * 19.5 +
						cook:GetRight() * -11.2 +
						cook:GetForward() * -9.7)
				end

				cook:GetVar("hob" .. i):PhysicsInit(SOLID_VPHYSICS)
				cook:GetVar("hob" .. i):SetMoveType(MOVETYPE_VPHYSICS)
				cook:GetVar("hob" .. i):SetSolid(SOLID_VPHYSICS)

				local phys = cook:GetVar("hob" .. i):GetPhysicsObject()

				if IsValid(phys) then
					phys:Wake()
					phys:SetMass(500)
					phys:EnableGravity(false)
				end
				
				constraint.Weld(cook:GetVar("hob" .. i), cook, 0, 0, 0, true, true)
				for ii = 1, i do
					constraint.NoCollide(cook:GetVar("hob" .. i), cook:GetVar("hob" .. ii), 0, 0)
				end
			end
			self:GetCooker():SetVar("NumHobs", 4)
			self:SetHasHobPoints(true)
		end
	end
end

function ENT:TouchHob(ent)
	local hob = nil
	if self:GetCooker():GetVar("NumHobs") then 
		for i = 1, self:GetCooker():GetVar("NumHobs") do
			if ent == self:GetCooker():GetVar("hob" .. i) then
				hob = self:GetCooker():GetVar("hob" .. i)
				break
			end
		end
	end
	self:SetActiveHob(hob)
	return hob
end

function ENT:Think()
	if not IsValid(self:GetCooker()) then
		self:SetCooker(nil)
		self:SetHasHobPoints(false)
		self:FindCooker()
	else
		self:SetupHobs()
	end

	local tr = util.QuickTrace(self:GetPos(), self:GetUp()*-5.5, self)
	if IsValid(tr.Entity) and IsValid(self:TouchHob(tr.Entity)) then
		self:SetTemp(math.Clamp(self:GetTemp() + .01, 20, 100))
		self:SetIsBoiling(true)
	else
		self:SetTemp(math.Clamp(self:GetTemp() - .005, 20, 100))
		self:SetIsBoiling(false)
		self:SetActiveHob(nil)
	end

	if self:GetHasHobPoints() then
		if IsValid(self:GetCooker()) then 
			if self:GetPos():Distance(self:GetCooker():GetPos()) > 40 then
				for i = 1, self:GetCooker():GetVar("NumHobs") do
					self:GetCooker():GetVar("hob" .. i):Remove()
					self:GetCooker():SetVar("hob" .. i, nil)
				end
				self:GetCooker():SetVar("NumHobs", nil)
				self:GetCooker():SetVar("HasKettle", nil)
				print(self:GetCooker().Owner)
				self:SetCooker(nil)
				self:SetHasHobPoints(false)
			end
		end
	end

	self:FindMugs()

	for _, mug in pairs(ActiveMugs) do
		if mug:GetPos():Distance(self:GetPos()) > 20 then break end
		local spoutPos = self:GetPos() + self:GetRight()*6 + self:GetUp()*1.7
		if (mug:GetPos() - spoutPos).x < 3 and 
		(mug:GetPos() - spoutPos).y < 3 and
		(mug:GetPos() - spoutPos).z < 15 and 
		self:GetAngles().r < 90 and self:GetAngles().r > 30 and
		self:GetTemp() > 0 then
			self:SetIsPouring(true)
			mug:SetVar("Tea", 100)
		else
			self:SetIsPouring(false)
		end
	end

	self:NextThink(CurTime() + 0.01)
	return true
end

function ENT:OnRemove()
	if IsValid(self:GetCooker()) then 
		if self:GetCooker():GetVar("NumHobs") then
			for i = 1, self:GetCooker():GetVar("NumHobs") do
				constraint.RemoveAll(self:GetCooker():GetVar("hob" .. i))
				self:GetCooker():GetVar("hob" .. i):Remove()
				self:GetCooker():SetVar("hob" .. i, nil)
			end
			self:GetCooker():SetVar("NumHobs", nil)
			self:GetCooker():SetVar("HasKettle", nil)
		end
	end
end
