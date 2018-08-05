include("shared.lua")

surface.CreateFont("NodeFont",{
        font = "Trebuchet",
        size = 75,
        weight = 600,
        antialias = true
})

surface.CreateFont("NodeFont2",{
        font = "Trebuchet",
        size = 40,
        weight = 600,
        antialias = true
})

function ENT:Initialize()

    self.time = 0

end


function ENT:Draw()

    local ply = LocalPlayer()

    self:DrawModel()

    if ply:GetPos():Distance(self:GetPos()) < 250 then

        local pos = self:GetPos() + Vector(0, 0, self:OBBMaxs().z + 30)
        local ang = Angle(0, 90 + (angto(self).y), 90)

        cam.Start3D2D(pos, ang, 0.1)

            draw.RoundedBox(0, -200, 0, 400, 200, Color(0, 0, 0, 200))
            draw.SimpleText("Ore Node", "NodeFont", 0, 40, Color(255, 255, 255, 255), 1, 1)

            draw.RoundedBox(0, -190, 75, 380, 115, Color(0, 0, 0, 200))
            draw.SimpleText("Ore: ", "NodeFont2", -180, 100, Color(255, 255, 255, 255), 0, 1)
            draw.SimpleText(self:GetOre() .. "/" .. self:GetMaxOre(), "NodeFont2", 180, 100, Color(255, 255, 255, 255), 2, 1)

            draw.SimpleText("Ore Type: ", "NodeFont2", -180, 130, Color(255, 255, 255, 255), 0, 1)
            draw.SimpleText(self:GetOreType(), "NodeFont2", 180, 130, Color(255, 255, 255, 255), 2, 1)

            if !self:GetIsMining() then
                
                draw.RoundedBox(0, -180, 150, 360, 30, Color(0, 0, 0, 255))

                self.time = 0

            else

                self.time = Lerp(5 * FrameTime(), self.time, self:GetMineTimeRemaining())
                
                draw.RoundedBox(0, -180, 150, 360, 30, Color(0, 0, 0, 255))
                draw.RoundedBox(0, -180, 150, (self.time / self:GetMineTime()) * 360, 30, Color(46, 134, 193, 255))

                draw.SimpleText(self:GetMineTime() - math.Round(self.time, 1) .. "s", "NodeFont2", 0, 168, Color(255, 255, 255, 255), 1, 1)

            end

        cam.End3D2D()

    end

end

local function angto(target)
    local ply = LocalPlayer()

    local vec = (ply:GetPos() - target:GetPos()):GetNormalized()
    local ang = vec:Angle()

    return ang
end