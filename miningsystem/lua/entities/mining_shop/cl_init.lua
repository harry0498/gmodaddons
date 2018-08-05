include("shared.lua")

function ENT:Draw()

    local ply = LocalPlayer()

    self:DrawModel()

    local pos = self:GetPos() + Vector(0, 0, 85)
    local ang = Angle(0, 90 + (angto(self).y), 90)

    cam.Start3D2D(pos, ang, 0.1)
    
        draw.RoundedBox(0, -175, 0, 350, 70, Color(0, 0, 0, 200))
        draw.SimpleText("Ore Dealer", "NodeFont", 0, 40, Color(255, 255, 255), 1, 1)

    cam.End3D2D()

end

local function angto(target)
    local ply = LocalPlayer()

    local vec = (ply:GetPos() - target:GetPos()):GetNormalized()
    local ang = vec:Angle()

    return ang
end

