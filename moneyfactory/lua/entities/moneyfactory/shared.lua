ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Money Factory"
ENT.AdminSpawnable = true
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "PaperAmount")
	self:NetworkVar("Int", 1, "PrintAmount")
	self:NetworkVar("Int", 2, "InkAmount")
	self:NetworkVar("Int", 3, "HealthAmount")
	self:NetworkVar("Float", 0, "PrintDelay")
end
