AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/eli.mdl")
    self:SetHullType(HULL_HUMAN)

    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    bit.bor(CAP_ANIMATEDFACE , CAP_TURN_HEAD)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()

    self:SetMaxYawSpeed(90)

    sound.Add({
			name = "sellsound",
			channel = CHAN_STATIC,
			volume = 1.0,
			level = 80,
			pitch = 100,
			sound = "vo/npc/male01/yeah02.wav"
	})

end

function ENT:OnTakeDamage()

    return false

end

function ENT:Think()

    self:DropToFloor()

    for _, ply in pairs(player.GetAll()) do
        
        if (ply:EyePos():Distance(self:EyePos()) <= 60) then

            self:SetEyeTarget(ply:EyePos())
            self:SetTarget(ply)
            break

        end

    end

end

function ENT:AcceptInput(name, act, call)

    if name == "Use" and call:IsValid() and call:GetNWInt("Ore") > 0 then
        
        local soldamount = call:GetNWInt("Ore")

        call:SendLua([[ chat.AddText(Color(46, 134, 193), "[Mining] ", Color(255, 255, 255), "You sold: ", Color(46, 134, 193), tostring(LocalPlayer():GetNWInt("Ore")), Color(255, 255, 255), " ore for ", Color(63, 191, 63), "£", tostring(LocalPlayer():GetNWInt("Ore") * 125)) ]])

        call:SendLua([[ chat.AddText(Color(46, 134, 193), "[Mining] ", Color(255, 255, 255), "You gained: ", Color(46, 134, 193), tostring(LocalPlayer():GetNWInt("Ore") * 10), Color(255, 255, 255), " xp") ]])

        call:SetNWInt("Ore", 0)

        call:addMoney(soldamount * 125)

        AddXP(call, soldamount * 10)

        self:EmitSound("sellsound")

    end

end



