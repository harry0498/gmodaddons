if SERVER then
    return
end

local alpha = {}
local fade = {}

function islooking(target)
    local ply = LocalPlayer()

    if ply == target then
        return false
    end

    local angle = math.pi / 4
    local aimvector = ply:GetAimVector()

    local targetv = (target:GetPos() + Vector(0, 0, 50)) - ply:GetShootPos()

    local dot = aimvector:Dot(targetv) / targetv:Length()

    return (dot > angle)
end

function angto(target)
    local ply = LocalPlayer()

    local vec = (ply:GetPos() - target:GetPos()):GetNormalized()
    local ang = vec:Angle()

    return ang
end

function drawplayerinfo(v, k)
    local pos = v:GetPos() + Vector(0, 0, 80)
    local ang = v:GetAngles()
    local lookat = angto(v).y

    ang:RotateAroundAxis(v:GetForward(), -90)
    ang:RotateAroundAxis(v:GetRight(), -180)
    ang:RotateAroundAxis(v:GetUp(), lookat - 90)

    local width = 300
    local height = 195

    cam.Start3D2D(pos, ang, 0.1)

    cam.IgnoreZ(false)

    --Background--
    draw.RoundedBox(0, -(width / 2), -height, width, height, Color(0, 0, 0, 200 * alpha[k]))
    draw.RoundedBox(0, -(width / 2) + 10, -height + 10, 280, 175, Color(0, 0, 0, 200 * alpha[k]))

    --Level--
    draw.SimpleText("Level: " .. v:GetNWInt("Level"), "Trebuchet24", 0, -height + 30, Color(255, 255, 255, 255 * alpha[k]), 1, 1)

    --Name--
    draw.SimpleText(v:Nick(), "Trebuchet24", 0, -height + 60, Color(255, 255, 255, 255 * alpha[k]), 1, 1)

    --Job--
    draw.SimpleText(v:getDarkRPVar("job"), "Trebuchet24", 0, -height + 90, Color(255, 255, 255, 255 * alpha[k]), 1, 1)

    --Health bar--
    draw.RoundedBox(0, -(width / 2) + 20, -height + 110, 260, 30, Color(0, 0, 0, 255 * alpha[k]))
    draw.RoundedBox(0, -(width / 2) + 25, -height + 115, math.Clamp((v:Health() / v:GetMaxHealth()), 0, 1) * 250, 20, Color(255, 0, 0, 255 * alpha[k]))

    --Health text--
    surface.SetFont("Trebuchet24")
    local wide, tall = surface.GetTextSize(((v:Health() / v:GetMaxHealth()) * 100) .. "%")

    draw.SimpleText("Health: " .. ((v:Health() / v:GetMaxHealth()) * 100) .. "%", "Trebuchet24", 0, -height + 113 + (tall / 2), Color(255, 255, 255, 255 * alpha[k]), 1, 1)

    --Armour bar--
    draw.RoundedBox(0, -(width / 2) + 20, -height + 145, 260, 30, Color(0, 0, 0, 255 * alpha[k]))
    draw.RoundedBox(0, -(width / 2) + 25, -height + 150, math.Clamp((v:Armor() / 100), 0, 1) * 250, 20, Color(0, 128, 255, 255 * alpha[k]))

    --Armour text--
    surface.SetFont("Trebuchet24")
    local wide, tall = surface.GetTextSize(((v:Armor() / 100) * 100) .. "%")

    draw.SimpleText("Armour: " .. ((v:Armor() / 100) * 100) .. "%", "Trebuchet24", 0, -height + 148 + (tall / 2), Color(255, 255, 255, 255 * alpha[k]), 1, 1)

    cam.End3D2D()
end

hook.Remove("PostDrawOpaqueRenderables", "playernames")
hook.Add(
    "PostDrawOpaqueRenderables",
    "playernames",
    function()
        local ply = LocalPlayer()

        for k, v in pairs(player.GetAll()) do
            if (v:IsValid() and v:IsPlayer()) then
                if (ply:GetPos():Distance(v:GetPos()) < 300) and islooking(v) then
                    if not fade[k] then
                        fade[k] = false
                    end
                    if not alpha[k] then
                        alpha[k] = 0
                    end

                    fade[k] = true

                    if (fade[k] == true) and (alpha[k] >= 0) then
                        alpha[k] = Lerp(5 * FrameTime(), alpha[k], 1)
                    end

                    drawplayerinfo(v, k)
                elseif ((ply:GetPos():Distance(v:GetPos()) > 300) or not (islooking(v))) then
                    if not fade[k] then
                        fade[k] = false
                    end
                    if not alpha[k] then
                        alpha[k] = 0
                    end

                    fade[k] = false

                    if (fade[k] == false) and (alpha[k] <= 1) then
                        alpha[k] = Lerp(5 * FrameTime(), alpha[k], 0)
                    end

                    drawplayerinfo(v, k)
                end
            end
        end
    end
)

hook.Remove("HUDDrawTargetID", "removetargetid")
hook.Add(
    "HUDDrawTargetID",
    "removetargetid",
    function()
        return false
    end
)
