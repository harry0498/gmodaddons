if not CLIENT then
    return
end

local hide = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true
}

surface.CreateFont("MaterialIcons", {
	font = "Material Icons",
	size =26,
	weight = 300,
	antialias = true,
	outline = false,
	extended = true,
})

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
        draw.RoundedBox(0, padding, ScrH() - padding - 140, 350, 140, Color(0, 0, 0, 200))

        --Job Name--
        draw.SimpleText(ply:getDarkRPVar("job"), "Trebuchet24", padding + margin, (ScrH() - padding - 120), Color(255, 255, 255), 0, 1)

        --Money info--
        local walletWidth, walletHeight = draw.SimpleText(GAMEMODE.Config.currency .. string.Comma(ply:getDarkRPVar("money")), "Trebuchet24", padding + margin, (ScrH() - padding - 90), Color(255, 255, 255), 0, 1)
        local salaryPerMin = (ply:getDarkRPVar("salary") / GAMEMODE.Config.paydelay) * 60
        draw.SimpleText(GAMEMODE.Config.currency .. string.Comma(salaryPerMin) .. "/min", "Trebuchet24", padding + margin + walletWidth + 30, (ScrH() - padding - 90), Color(255, 255, 255), 0, 1)

        --Health Bar--
        draw.RoundedBox(0, padding + margin, (ScrH() - padding - 70), 291, 26, Color(0, 0, 0, 200))
        draw.RoundedBox(0, padding + margin + 3, (ScrH() - padding - 70 + 3), math.Clamp(((health / maxhealth) * 285), 0, 285), 20, Color(231, 76, 60))

        --Armour Bar--
        draw.RoundedBox(0, padding + margin, (ScrH() - padding - 40), 291, 26, Color(0, 0, 0, 200))
        draw.RoundedBox(0, padding + margin + 3, (ScrH() - padding - 40 + 3), math.Clamp(((armour / maxarmour) * 285), 0, 285), 20, Color(52, 152, 219))

        --Health Text--
        draw.SimpleText(math.Round(((math.Clamp(health, 0, maxhealth) / maxhealth) * 100), 1) .. "%", "Trebuchet24", padding + margin + 3 + (285 / 2), (ScrH() - padding - 70 + 2 + 10), Color(255, 255, 255), 1, 1)

        --Armour Efficency--
        draw.SimpleText(math.Round(((armour / maxarmour) * 100), 1) .. "%", "Trebuchet24", padding + margin + 3 + (285 / 2), (ScrH() - padding - 40 + 2 + 10), Color(255, 255, 255), 1, 1)

        --Icons--

        --Job--
        draw.SimpleText(utf8.char(0xe8f9), "MaterialIcons", padding + margin - 20, (ScrH() - padding - 120), team.GetColor(ply:Team()), 1, 1)

        --Money--
        draw.SimpleText(utf8.char(0xe850), "MaterialIcons", padding + margin - 20, (ScrH() - padding - 90), Color(243, 156, 18), 1, 1)

        --Salary--
        draw.SimpleText(utf8.char(0xe227), "MaterialIcons", padding + margin + walletWidth + 20, (ScrH() - padding - 90), Color(46, 204, 113), 1, 1)
        
        --Health--
        draw.SimpleText(utf8.char(0xe87d), "MaterialIcons", padding + margin - 20, (ScrH() - padding - 60), Color(231, 76, 60), 1, 1)
        
        --Armour--
        draw.SimpleText(utf8.char(0xe32a), "MaterialIcons", padding + margin - 20, (ScrH() - padding - 30), Color(52, 152, 219), 1, 1)
        
        --License--
        if ply:getDarkRPVar("HasGunlicense") then
            draw.SimpleText(utf8.char(0xe051), "MaterialIcons", padding + margin + 280, (ScrH() - padding - 120), Color(255, 255, 255), 1, 1)
        end
        
        --Wanted--
        if ply:isWanted() then
            draw.SimpleText(utf8.char(0xe417), "MaterialIcons", padding + margin + 245, (ScrH() - padding - 120), Color(192, 57, 43), 1, 1)
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
