scoreboard = scoreboard or {}

plyinfo = {}
iconbar = {}

if not CLIENT then
    return
end

surface.CreateFont(
    "ScoreboardTitle",
    {
        font = "Trebuchet",
        extended = false,
        size = 50,
        weight = 580,
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

function scoreboard:show()
    local menu = vgui.Create("DFrame")
    menu:SetSize(1000, 800)
    menu:Center()
    menu:SetTitle("")
    menu:ShowCloseButton(false)
    menu.Paint = function(s, width, height)
        draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
    end

    local servername = vgui.Create("DLabel", menu)
    servername:SetText(GetHostName())
    servername:SetFont("ScoreboardTitle")
    servername:SetTextColor(Color(255, 255, 255))
    servername:SizeToContents()
    servername:SetContentAlignment(5)
    servername:SetPos((menu:GetWide() / 2) - (servername:GetWide() / 2), 20)

    iconbar.main = vgui.Create("DPanel", menu)
    iconbar.main:Dock(TOP)
    iconbar.main:DockMargin(25, 50, 25, 0)
    iconbar.main:SetTall(35)
    iconbar.main.Paint = function(s, width, height)
        draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
    end

    iconbar.name = iconbar.main:Add("DPanel")
    iconbar.name:SetSize(18, 18)
    iconbar.name:SetPos((10 + 50) - (iconbar.name:GetWide() / 2), (iconbar.main:GetTall() / 2) - (iconbar.name:GetTall() / 2))
    iconbar.name.Paint = function(s, width, height)
        surface.SetMaterial(Material("icon16/user.png"))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(0, 0, width, height)
    end

    iconbar.job = iconbar.main:Add("DPanel")
    iconbar.job:SetSize(18, 18)
    iconbar.job:SetPos((10 + 378) - (iconbar.job:GetWide() / 2), (iconbar.main:GetTall() / 2) - (iconbar.job:GetTall() / 2))
    iconbar.job.Paint = function(s, width, height)
        surface.SetMaterial(Material("icon16/user_suit.png"))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(0, 0, width, height)
    end

    iconbar.money = iconbar.main:Add("DPanel")
    iconbar.money:SetSize(18, 18)
    iconbar.money:SetPos((10 + 575) - (iconbar.money:GetWide() / 2), (iconbar.main:GetTall() / 2) - (iconbar.money:GetTall() / 2))
    iconbar.money.Paint = function(s, width, height)
        surface.SetMaterial(Material("icon16/money.png"))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(0, 0, width, height)
    end

    iconbar.kills = iconbar.main:Add("DPanel")
    iconbar.kills:SetSize(18, 18)
    iconbar.kills:SetPos((10 + 770) - (iconbar.kills:GetWide() / 2), (iconbar.main:GetTall() / 2) - (iconbar.kills:GetTall() / 2))
    iconbar.kills.Paint = function(s, width, height)
        surface.SetMaterial(Material("icon16/bomb.png"))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(0, 0, width, height)
    end

    iconbar.deaths = iconbar.main:Add("DPanel")
    iconbar.deaths:SetSize(18, 18)
    iconbar.deaths:SetPos((10 + 830) - (iconbar.deaths:GetWide() / 2), (iconbar.main:GetTall() / 2) - (iconbar.deaths:GetTall() / 2))
    iconbar.deaths.Paint = function(s, width, height)
        surface.SetMaterial(Material("icon16/exclamation.png"))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(0, 0, width, height)
    end

    iconbar.ping = iconbar.main:Add("DPanel")
    iconbar.ping:SetSize(18, 18)
    iconbar.ping:SetPos((10 + 890) - (iconbar.ping:GetWide() / 2), (iconbar.main:GetTall() / 2) - (iconbar.ping:GetTall() / 2))
    iconbar.ping.Paint = function(s, width, height)
        surface.SetMaterial(Material("icon16/connect.png"))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(0, 0, width, height)
    end

    local playerpanel = vgui.Create("DScrollPanel", menu)
    playerpanel:Dock(FILL)
    playerpanel:DockMargin(25, 5, 25, 25)
    playerpanel.Paint = function(s, width, height)
        draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
    end

    local playerpanelbar = playerpanel:GetVBar()
    playerpanelbar.Paint = function(s, width, height)
        draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 0))
    end
    playerpanelbar.btnUp.Paint = function(s, width, height)
        draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 0))
    end
    playerpanelbar.btnDown.Paint = function(s, width, height)
        draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 0))
    end
    playerpanelbar.btnGrip.Paint = function(s, width, height)
        draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
    end

    for k, v in pairs(player.GetAll()) do
        plyinfo.main = playerpanel:Add("DPanel")
        plyinfo.main:Dock(TOP)
        plyinfo.main:DockMargin(10, 10, 10, 0)
        plyinfo.main:SetSize(0, 50)

        plyinfo.main.Paint = function(s, width, height)
            draw.RoundedBox(0, 0, 0, width, height, team.GetColor(v:Team()))
        end

        plyinfo.name = plyinfo.main:Add("DLabel")

        if string.len(v:Nick()) > 20 then
            name = string.sub(v:Nick(), 1, 20) .. "..."
        else
            name = v:Nick()
        end

        plyinfo.name:SetText(name)
        plyinfo.name:SetFont("Trebuchet24")
        plyinfo.name:SetTextColor(Color(255, 255, 255))
        plyinfo.name:SizeToContents()
        plyinfo.name:SetContentAlignment(4)
        plyinfo.name:SetPos(10, -1 + playerpanel:GetTall() / 2)

        plyinfo.ping = plyinfo.main:Add("DLabel")
        plyinfo.ping:SetText(math.Clamp(v:Ping(), 1, 999))
        plyinfo.ping:SetFont("Trebuchet24")
        plyinfo.ping:SetTextColor(Color(255, 255, 255))
        plyinfo.ping:SizeToContents()
        plyinfo.ping:SetContentAlignment(5)
        plyinfo.ping:SetPos((10 + 880) - (plyinfo.ping:GetWide() / 2), -1 + playerpanel:GetTall() / 2)

        plyinfo.deaths = plyinfo.main:Add("DLabel")
        plyinfo.deaths:SetText(math.Clamp(v:Deaths(), 0, 99))
        plyinfo.deaths:SetFont("Trebuchet24")
        plyinfo.deaths:SetTextColor(Color(255, 255, 255))
        plyinfo.deaths:SizeToContents()
        plyinfo.deaths:SetPos((10 + 820) - (plyinfo.deaths:GetWide() / 2), -1 + playerpanel:GetTall() / 2)

        plyinfo.kills = plyinfo.main:Add("DLabel")
        plyinfo.kills:SetText(math.Clamp(v:Frags(), 0, 99))
        plyinfo.kills:SetFont("Trebuchet24")
        plyinfo.kills:SetTextColor(Color(255, 255, 255))
        plyinfo.kills:SizeToContents()
        plyinfo.kills:SetContentAlignment(5)
        plyinfo.kills:SetPos((10 + 760) - (plyinfo.kills:GetWide() / 2), -1 + playerpanel:GetTall() / 2)

        plyinfo.job = plyinfo.main:Add("DLabel")
        plyinfo.job:SetText(team.GetName(v:Team()))
        plyinfo.job:SetFont("Trebuchet24")
        plyinfo.job:SetTextColor(Color(255, 255, 255))
        plyinfo.job:SizeToContents()
        plyinfo.job:SetContentAlignment(5)
        plyinfo.job:SetPos((10 + 370) - (plyinfo.job:GetWide() / 2), -1 + playerpanel:GetTall() / 2)

        plyinfo.money = plyinfo.main:Add("DLabel")
        plyinfo.money:SetText("£" .. string.Comma(math.Clamp(v:getDarkRPVar("money"), 0, 999999999999)))
        plyinfo.money:SetFont("Trebuchet24")
        plyinfo.money:SetTextColor(Color(255, 255, 255))
        plyinfo.money:SizeToContents()
        plyinfo.money:SetContentAlignment(5)
        plyinfo.money:SetPos((10 + 570) - (plyinfo.money:GetWide() / 2), -1 + playerpanel:GetTall() / 2)
    end

    gui.EnableScreenClicker(true)

    function scoreboard:hide()
        menu:Remove()
        gui.EnableScreenClicker(false)
    end
end

hook.Remove("ScoreboardShow", "showscoreboard")
hook.Add(
    "ScoreboardShow",
    "showscoreboard",
    function()
        scoreboard:show()

        return false
    end
)

hook.Remove("ScoreboardHide", "hidescoreboard")
hook.Add(
    "ScoreboardHide",
    "hidescoreboard",
    function()
        scoreboard:hide()
    end
)
