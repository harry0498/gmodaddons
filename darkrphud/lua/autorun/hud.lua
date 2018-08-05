if not CLIENT then
    return
end

local hide = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true
}

surface.CreateFont(
    "AmmoFont1",
    {
        font = "Trebuchet",
        extended = false,
        size = 40,
        weight = 300,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false
    }
)

surface.CreateFont(
    "AmmoFont3",
    {
        font = "Trebuchet",
        extended = false,
        size = 60,
        weight = 300,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false
    }
)

surface.CreateFont(
    "AmmoFont2",
    {
        font = "Trebuchet",
        extended = false,
        size = 250,
        weight = 300,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false
    }
)

local function DisplayNotify(msg)
    local txt = msg:ReadString()
    GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
    surface.PlaySound("buttons/lightswitch2.wav")

    -- Log to client console
    MsgC(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), txt, "\n")
end
usermessage.Hook("_Notify", DisplayNotify)

hook.Add(
    "HUDShouldDraw",
    "HideHUD",
    function(name)
        if (hide[name]) then
            return false
        end
    end
)

hook.Add(
    "HUDPaint",
    "DarkRPHUD",
    function()
        local ply = LocalPlayer()
        local padding = 25
        local health = ply:Health()
        local maxhealth = ply:GetMaxHealth()
        local armour = ply:Armor()
        local maxarmour = 100
        local margin = 40
        local icons = {
            "icon16/user.png",
            "icon16/user_suit.png",
            "icon16/money.png",
            "icon16/money_add.png",
            "icon16/heart.png",
            "icon16/shield.png",
            "icon16/vcard.png",
            "icon16/exclamation.png"
        }

        --Background--
        draw.RoundedBox(0, padding, ScrH() - padding - 200, 350, 200, Color(0, 0, 0, 200))

        --Name Text--
        draw.SimpleText("Name: " .. ply:Nick(), "Trebuchet24", padding + margin, (ScrH() - padding - 180), Color(255, 255, 255), 0, 1)

        --Job Name--
        draw.SimpleText("Job: " .. ply:getDarkRPVar("job"), "Trebuchet24", padding + margin, (ScrH() - padding - 150), Color(255, 255, 255), 0, 1)

        --Money info--
        draw.SimpleText("Money: £" .. string.Comma(ply:getDarkRPVar("money")), "Trebuchet24", padding + margin, (ScrH() - padding - 120), Color(255, 255, 255), 0, 1)
        draw.SimpleText("Salary: £" .. string.Comma(ply:getDarkRPVar("salary")), "Trebuchet24", padding + margin, (ScrH() - padding - 90), Color(255, 255, 255), 0, 1)

        --Health Bar--
        draw.RoundedBox(0, padding + margin, (ScrH() - padding - 70), 291, 26, Color(0, 0, 0, 200))
        draw.RoundedBox(0, padding + margin + 3, (ScrH() - padding - 70 + 3), math.Clamp(((health / maxhealth) * 285), 0, 285), 20, Color(255, 0, 0))

        --Armour Bar--
        draw.RoundedBox(0, padding + margin, (ScrH() - padding - 40), 291, 26, Color(0, 0, 0, 200))
        draw.RoundedBox(0, padding + margin + 3, (ScrH() - padding - 40 + 3), math.Clamp(((armour / maxarmour) * 285), 0, 285), 20, Color(0, 128, 255))

        --Health Text--
        draw.SimpleText("Health: " .. math.Clamp(health, 0, maxhealth) .. "/" .. maxhealth .. " (" .. math.Round(((math.Clamp(health, 0, maxhealth) / maxhealth) * 100), 1) .. "%)", "HudHintTextLarge", padding + margin + 3 + (285 / 2), (ScrH() - padding - 70 + 2 + 10), Color(255, 255, 255), 1, 1)

        --Armour Efficency--
        draw.SimpleText("Armour: " .. math.Round(((armour / maxarmour) * 100), 1) .. "%", "HudHintTextLarge", padding + margin + 3 + (285 / 2), (ScrH() - padding - 40 + 2 + 10), Color(255, 255, 255), 1, 1)

        --Icons--

        --Name--
        surface.SetMaterial(Material(icons[1]))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(padding + margin - 28, (ScrH() - padding - 180 - 10), 18, 18)

        --Job--
        surface.SetMaterial(Material(icons[2]))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(padding + margin - 28, (ScrH() - padding - 150 - 9), 18, 18)

        --Money--
        surface.SetMaterial(Material(icons[3]))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(padding + margin - 28, (ScrH() - padding - 120 - 8), 18, 18)

        --Salary--
        surface.SetMaterial(Material(icons[4]))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(padding + margin - 28, (ScrH() - padding - 90 - 7), 18, 18)

        --Health--
        surface.SetMaterial(Material(icons[5]))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(padding + margin - 28, (ScrH() - padding - 60 - 6), 18, 18)

        --Armour--
        surface.SetMaterial(Material(icons[6]))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(padding + margin - 28, (ScrH() - padding - 30 - 5), 18, 18)

        --License--
        if ply:getDarkRPVar("HasGunlicense") then
            surface.SetMaterial(Material(icons[7]))
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(padding + margin + 270, (ScrH() - padding - 90 - 7), 18, 18)
        else
            surface.SetMaterial(Material(icons[7]))
            surface.SetDrawColor(0, 0, 0, 255)
            surface.DrawTexturedRect(padding + margin + 270, (ScrH() - padding - 90 - 7), 18, 18)
        end

        --Wanted--
        if ply:isWanted() then
            surface.SetMaterial(Material(icons[8]))
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(padding + margin + 235, (ScrH() - padding - 90 - 6), 18, 18)
        else
            surface.SetMaterial(Material(icons[8]))
            surface.SetDrawColor(0, 0, 0, 255)
            surface.DrawTexturedRect(padding + margin + 235, (ScrH() - padding - 90 - 6), 18, 18)
        end

        --Ammo--
        --Main--

        if ply:GetActiveWeapon():IsValid() then
            if not ply:GetActiveWeapon():Clip1() == -1 then
                draw.RoundedBox(0, ScrW() - 350 - padding, ScrH() - padding - 200, 350, 200, Color(0, 0, 0, 200))
                draw.SimpleText(ply:GetActiveWeapon():GetPrintName(), "AmmoFont1", ScrW() - 350 - padding + 175, ScrH() - padding - 185 + 25, Color(255, 255, 255), 1, 1)
                draw.SimpleText(ply:GetActiveWeapon():Clip1(), "AmmoFont2", ScrW() - 350 - padding + 125, ScrH() - padding - 95 + 25, Color(255, 255, 255), 1, 1)
                draw.SimpleText(math.Clamp(ply:GetAmmoCount((ply:GetActiveWeapon():GetPrimaryAmmoType())), 0, 999), "AmmoFont3", ScrW() - 350 - padding + 245, ScrH() - padding - 85 + 25, Color(255, 255, 255, 85), 1, 1)
            end
        end

        --math.Clamp(input, min, max)
        --draw.SimpleText(text, font="DermaDefault", x=0, y=0, color=Color(255,255,255,255), xAlign=TEXT_ALIGN_LEFT, yAlign=TEXT_ALIGN_TOP)
    end
)
