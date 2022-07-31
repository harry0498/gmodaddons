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
    local scrW, scrH = ScrW(), ScrH()
    menu:SetSize(scrW * 0.75, scrH * 0.9)
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

    
    local plyPanel = vgui.Create("DListView", menu)
    plyPanel:Dock(FILL)
    plyPanel:DockMargin(25, 55, 25, 25)
    plyPanel:AddColumn("Player", 1):SetWidth(500)
    plyPanel:AddColumn("Job", 2):SetWidth(500)
    plyPanel:AddColumn("Kills", 3)
    plyPanel:AddColumn("Deaths", 4)
    plyPanel:AddColumn("Ping", 5)
    plyPanel:SetHeaderHeight(40)
    plyPanel:SetDataHeight(40)

    plyPanel.Paint = function(s, width, height)
    end

    local plyPanelBar = plyPanel.VBar
    plyPanelBar:SetHideButtons(true)
    plyPanelBar.Paint = function(s, width, height)
        draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 0))
    end
    plyPanelBar.btnGrip.Paint = function(s, width, height)
        draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 255))
    end
    
    for k, v in pairs(player.GetAll()) do
        if string.len(v:Nick()) > 20 then
            name = string.sub(v:Nick(), 1, 20) .. "..."
        else
            name = v:Nick()
        end

        local job = team.GetName(v:Team()) or ""
        local kills = math.Clamp(v:Frags() or 0, 0, 99)
        local deaths = math.Clamp(v:Deaths() or 0, 0, 99)
        local ping = math.Clamp(v:Ping() or 0, 1, 999)

        plyinfo.main = plyPanel:AddLine(name, job, kills, deaths, ping)
        plyinfo.main.Colour = team.GetColor(v:Team())
    end

    local colWidth = {}
    for k, v in pairs(plyPanel.Columns) do
        local text = v.Header:GetText()
        v.Header:SetText("")
        
        v.Header.Paint = function(s, width, height)
            draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 255))
            draw.SimpleText(text, "Trebuchet24", width / 2, height / 2, Color(255, 255, 255, 255), 1, 1)
            colWidth[text] = width
        end
    end
    
    for k, v in pairs(plyPanel.Lines) do
        v.Paint = function(s, width, height)
            width = 0

            table.foreach(colWidth, function(_, w)
                width = width + w
            end)

            draw.RoundedBox(0, 0, 0, width - 1, height, v.Colour)
        end

        
        for _k, _v in pairs(v.Columns) do
            local text = _v:GetText()
            _v:SetText("")
            
            _v.Paint = function(s, width, height)
                draw.SimpleText(text, "Trebuchet24", width / 2, height / 2, Color(255, 255, 255, 255), 1, 1)
            end
        end
    end

    gui.EnableScreenClicker(true)

    function scoreboard:hide()
        menu:Remove()
        gui.EnableScreenClicker(false)
    end
end


hook.Remove("ScoreboardShow", "ShowMyScoreboard")
hook.Remove("ScoreboardHide", "HideMyScoreboard")

hook.Add(
    "ScoreboardShow",
    "ShowMyScoreboard",
    function()
        scoreboard:show()
        
        return true
    end
)

hook.Add(
    "ScoreboardHide",
    "HideMyScoreboard",
    function()
        scoreboard:hide()
    end
)
