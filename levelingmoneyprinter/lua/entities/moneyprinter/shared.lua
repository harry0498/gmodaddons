ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Leveling Money Printer"
ENT.AdminSpawnable = false
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "PrintDelay")
	self:NetworkVar("Int", 1, "MoneyAmount")
	self:NetworkVar("Int", 2, "XPAmount")
	self:NetworkVar("Int", 3, "XPNeeded")
	self:NetworkVar("Int", 4, "XPLevel")
	self:NetworkVar("Int", 5, "HealthAmount")
	self:NetworkVar("Entity", 6, "owning_ent")
	self:NetworkVar("Int", 7, "BatteryAmount")
end
