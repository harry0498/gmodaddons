if SERVER then
    return
end

local cornerRadius = 0
local x = 0
local y = 0
local color = Color(0, 0, 0, 200)
local xpsmooth = 0
local alpha = 1

hook.Remove("HUDPaint", "paintlevel")
hook.Add(
    "HUDPaint",
    "paintlevel",
    function()
        local ply = LocalPlayer()
        local level = ply:GetNWInt("Level")
        local xpmax = math.Round(((level + 1) - 1 + 300 * 2 ^ (((level + 1) - 1) / 7)) / 4)
        local xp = ply:GetNWInt("XP")

        net.Receive(
            "updatexp",
            function()
                updatexp = net.ReadBool()
            end
        )

        if (updatexp == false) and (alpha <= 1) then
            alpha = Lerp(5 * FrameTime(), alpha, 0)
        elseif (updatexp == true) and (alpha >= 0) then
            alpha = Lerp(5 * FrameTime(), alpha, 1)
        end

        --Background--
        draw.RoundedBox(cornerRadius, 25, (ScrH() - 40 - 240), 350, 40, Color(0, 0, 0, 200 * alpha))

        --XP bar--
        xpsmooth = Lerp(5 * FrameTime(), xpsmooth, (xp / xpmax))

        draw.RoundedBox(cornerRadius, 25 + 10, (ScrH() - 40 - 240), 330, 30, Color(0, 0, 0, 200 * alpha))
        draw.RoundedBox(cornerRadius, 25 + 10, (ScrH() - 40 - 240), xpsmooth * 330, 30, Color(117, 255, 51, 255 * alpha))

        --XP text--
        draw.SimpleText("XP: " .. xp .. "/" .. xpmax .. " (" .. (math.Round(xp / xpmax * 100, 1)) .. "%)", "Trebuchet24", 25 + (340 / 2), (ScrH() - 40 - 240 + 15), Color(255, 255, 255, 255 * alpha), 1, 1)

        --Level bar--
        draw.RoundedBox(cornerRadius, 25, (ScrH() - 40 - 240 - 40), 350, 40, Color(0, 0, 0, 200 * alpha))

        --Level text--
        draw.SimpleText("Level: " .. level, "Trebuchet24", 25 + (340 / 2), (ScrH() - 40 - 260), Color(255, 255, 255, 255 * alpha), 1, 1)
    end
)
