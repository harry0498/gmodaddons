if SERVER then
    util.AddNetworkString("f4menu")

    local isopen = false

    hook.Remove("ShowSpare2", "f4menu")
    hook.Add(
        "ShowSpare2",
        "f4menu",
        function(ply)
            if isopen == false then
                isopen = true
            else
                isopen = false
            end

            net.Start("f4menu")

            net.WriteBit(isopen)

            net.Send(ply)
        end
    )
elseif CLIENT then
    local f4menu = {}
    local ply = LocalPlayer()

    surface.CreateFont(
        "CategoryFont1",
        {
            font = "Trebuchet",
            extended = false,
            size = 40,
            weight = 650,
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

    net.Receive(
        "f4menu",
        function()
            if f4menu.main == nil then
                f4menu.main = vgui.Create("DFrame")
                f4menu.main:SetSize(1150, 800)
                f4menu.main:Center()
                f4menu.main:ShowCloseButton(false)
                f4menu.main:SetTitle("")
                f4menu.main.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                end

                f4menu.topbar = f4menu.main:Add("DPanel")
                f4menu.topbar:Dock(TOP)
                f4menu.topbar:DockMargin(25, 0, 25, 15)
                f4menu.topbar:SetTall(100)
                f4menu.topbar.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                    draw.SimpleText(GetHostName(), "CategoryFont1", width / 2, height / 2, Color(255, 255, 255, 255), 1, 1)
                end

                f4menu.tabs = f4menu.main:Add("DPanel")
                f4menu.tabs:Dock(TOP)
                f4menu.tabs:DockMargin(25, 0, 25, 15)
                f4menu.tabs:SetTall(68)
                f4menu.tabs.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                end

                f4menu.tabs.jobs = f4menu.tabs:Add("DButton")
                f4menu.tabs.jobs:Dock(LEFT)
                f4menu.tabs.jobs:DockMargin(10, 10, 0, 10)
                f4menu.tabs.jobs:SetText("")
                f4menu.tabs.jobs:SetTall(f4menu.tabs:GetTall() - 20)
                f4menu.tabs.jobs:SetWide(260)
                f4menu.tabs.jobs.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                    draw.SimpleText("Jobs", "CategoryFont1", width / 2, height / 2, Color(255, 255, 255, 255), 1, 1)
                end
                f4menu.tabs.jobs.DoClick = function()
                    f4menu.contents.joblist:Show()
                    f4menu.contents.info:Show()
                    f4menu.contents.shipmentlist:Hide()
                    f4menu.contents.entitieslist:Hide()
                    f4menu.contents.ammolist:Hide()
                end

                f4menu.tabs.shipments = f4menu.tabs:Add("DButton")
                f4menu.tabs.shipments:Dock(LEFT)
                f4menu.tabs.shipments:DockMargin(10, 10, 0, 10)
                f4menu.tabs.shipments:SetText("")
                f4menu.tabs.shipments:SetTall(f4menu.tabs:GetTall() - 20)
                f4menu.tabs.shipments:SetWide(260)
                f4menu.tabs.shipments.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                    draw.SimpleText("Shipments", "CategoryFont1", width / 2, height / 2, Color(255, 255, 255, 255), 1, 1)
                end
                f4menu.tabs.shipments.DoClick = function()
                    f4menu.contents.joblist:Hide()
                    f4menu.contents.info:Hide()
                    f4menu.contents.shipmentlist:Show()
                    f4menu.contents.entitieslist:Hide()
                    f4menu.contents.ammolist:Hide()
                end

                f4menu.tabs.entities = f4menu.tabs:Add("DButton")
                f4menu.tabs.entities:Dock(LEFT)
                f4menu.tabs.entities:DockMargin(10, 10, 0, 10)
                f4menu.tabs.entities:SetText("")
                f4menu.tabs.entities:SetTall(f4menu.tabs:GetTall() - 20)
                f4menu.tabs.entities:SetWide(260)
                f4menu.tabs.entities.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                    draw.SimpleText("Entities", "CategoryFont1", width / 2, height / 2, Color(255, 255, 255, 255), 1, 1)
                end
                f4menu.tabs.entities.DoClick = function()
                    f4menu.contents.joblist:Hide()
                    f4menu.contents.info:Hide()
                    f4menu.contents.shipmentlist:Hide()
                    f4menu.contents.entitieslist:Show()
                    f4menu.contents.ammolist:Hide()
                end

                f4menu.tabs.ammo = f4menu.tabs:Add("DButton")
                f4menu.tabs.ammo:Dock(LEFT)
                f4menu.tabs.ammo:DockMargin(10, 10, 0, 10)
                f4menu.tabs.ammo:SetText("")
                f4menu.tabs.ammo:SetTall(f4menu.tabs:GetTall() - 20)
                f4menu.tabs.ammo:SetWide(260)
                f4menu.tabs.ammo.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                    draw.SimpleText("Ammo", "CategoryFont1", width / 2, height / 2, Color(255, 255, 255, 255), 1, 1)
                end
                f4menu.tabs.ammo.DoClick = function()
                    f4menu.contents.joblist:Hide()
                    f4menu.contents.info:Hide()
                    f4menu.contents.shipmentlist:Hide()
                    f4menu.contents.entitieslist:Hide()
                    f4menu.contents.ammolist:Show()
                end

                f4menu.contents = f4menu.main:Add("DScrollPanel")
                f4menu.contents:Dock(FILL)
                f4menu.contents:DockMargin(25, 0, 25, 15)
                f4menu.contents.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                end

                f4menu.contents.scroll = f4menu.contents:GetVBar()
                f4menu.contents.scroll.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 0))
                end
                f4menu.contents.scroll.btnUp.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 0))
                end
                f4menu.contents.scroll.btnDown.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 0))
                end
                f4menu.contents.scroll.btnGrip.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                end

                f4menu.contents.info = f4menu.main:Add("DPanel")
                f4menu.contents.info:Dock(RIGHT)
                f4menu.contents.info:DockMargin(0, 0, 25, 15)
                f4menu.contents.info:SetWide(350)
                f4menu.contents.info.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                end

                f4menu.contents.info.description = f4menu.contents.info:Add("RichText")
                f4menu.contents.info.description:Dock(TOP)
                f4menu.contents.info.description:DockMargin(15, 15, 15, 0)
                f4menu.contents.info.description:SetWide(340)
                f4menu.contents.info.description:SetTall(340)
                f4menu.contents.info.description:SetVerticalScrollbarEnabled(true)
                f4menu.contents.info.description:SetText("")
                f4menu.contents.info.description.Paint = function()
                    f4menu.contents.info.description:SetFontInternal("HudHintTextLarge")
                    f4menu.contents.info.description:SetBGColor(0, 0, 0, 200)
                    f4menu.contents.info.description:SetFGColor(255, 255, 255, 255)
                    f4menu.contents.info.description.Paint = nil
                end
                f4menu.contents.info.description.scroll = f4menu.contents.info.description:GetChildren()[1]
                f4menu.contents.info.description.scroll.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 0))
                end
                f4menu.contents.info.description.scroll.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 0))
                end

                f4menu.contents.joblist = f4menu.contents:Add("DIconLayout")
                f4menu.contents.joblist:Dock(TOP)
                f4menu.contents.joblist:DockMargin(0, 0, 0, 0)
                f4menu.contents.joblist:SetSpaceX(0)
                f4menu.contents.joblist:SetSpaceY(15)

                f4menu.contents.shipmentlist = f4menu.contents:Add("DIconLayout")
                f4menu.contents.shipmentlist:Dock(TOP)
                f4menu.contents.shipmentlist:DockMargin(0, 0, 0, 0)
                f4menu.contents.shipmentlist:SetSpaceX(0)
                f4menu.contents.shipmentlist:SetSpaceY(15)
                f4menu.contents.shipmentlist:Hide()

                f4menu.contents.entitieslist = f4menu.contents:Add("DIconLayout")
                f4menu.contents.entitieslist:Dock(TOP)
                f4menu.contents.entitieslist:DockMargin(0, 0, 0, 0)
                f4menu.contents.entitieslist:SetSpaceX(0)
                f4menu.contents.entitieslist:SetSpaceY(15)
                f4menu.contents.entitieslist:Hide()

                f4menu.contents.ammolist = f4menu.contents:Add("DIconLayout")
                f4menu.contents.ammolist:Dock(TOP)
                f4menu.contents.ammolist:DockMargin(0, 0, 0, 0)
                f4menu.contents.ammolist:SetSpaceX(0)
                f4menu.contents.ammolist:SetSpaceY(15)
                f4menu.contents.ammolist:Hide()

                for k, v in pairs(DarkRP.getCategories().jobs) do
                    f4menu.contents.joblist.category = f4menu.contents.joblist:Add("DPanel")
                    f4menu.contents.joblist.category:Dock(TOP)
                    f4menu.contents.joblist.category:DockMargin(15, 15, 15, 0)
                    f4menu.contents.joblist.category:SetTall(50)
                    f4menu.contents.joblist.category.Paint = function(s, width, height)
                        draw.RoundedBox(0, 0, 0, width, height, v.color)
                        draw.SimpleText(v.name, "CategoryFont1", width / 2, height / 2, Color(255, 255, 255, 255), 1, 1)
                    end

                    for key, val in pairs(RPExtraTeams) do
                        if val.category == v.name then
                            f4menu.contents.joblist.category.contents = f4menu.contents.joblist:Add("DButton")
                            f4menu.contents.joblist.category.contents:Dock(TOP)
                            f4menu.contents.joblist.category.contents:DockMargin(50, 10, 50, 0)
                            f4menu.contents.joblist.category.contents:SetText("")
                            f4menu.contents.joblist.category.contents:SetTall(75)

                            f4menu.contents.joblist.category.contents.Paint = function(s, width, height)
                                draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                                draw.RoundedBox(0, 0, height - 10, width, 10, val.color)
                                draw.SimpleText(val.name, "Trebuchet24", width / 2, height * 0.45, Color(255, 255, 255, 255), 1, 1)
                                draw.SimpleText(team.NumPlayers(key) .. " / " .. val.max, "HudHintTextLarge", width * 0.9, height * 0.45, Color(255, 255, 255, 255), 1, 1)
                            end

                            f4menu.contents.joblist.category.contents.DoClick = function()
                                f4menu.contents.info.description:SetText("Salary: £" .. val.salary .. "\n\n" .. "Weapons:\n" .. string.Replace(string.Replace(string.Replace(string.Replace(table.ToString(val.weapons, "", false), "{", ""), "}", ""), "=", ""), ",", "\n") .. "\n" .. val.description)

                                if f4menu.contents.info.models then
                                    f4menu.contents.info.models:Remove()
                                end

                                f4menu.contents.info.models = f4menu.contents.info:Add("DHorizontalScroller")
                                f4menu.contents.info.models:Dock(TOP)
                                f4menu.contents.info.models:DockMargin(15, 15, 15, 0)
                                f4menu.contents.info.models:SetOverlap(-5)
                                f4menu.contents.info.models:SetTall(75)
                                f4menu.contents.info.models.Paint = function(s, width, height)
                                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                                end

                                function f4menu.contents.info.models.btnLeft:Paint(width, height)
                                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                                end
                                function f4menu.contents.info.models.btnRight:Paint(width, height)
                                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                                end

                                for k, v in pairs(val.model) do
                                    f4menu.contents.info.models.content = f4menu.contents.info.models:Add("SpawnIcon")
                                    f4menu.contents.info.models.content:SetModel(v)
                                    f4menu.contents.info.models.content.DoClick = function()
                                        DarkRP.setPreferredJobModel(key, v)
                                    end

                                    f4menu.contents.info.models:AddPanel(f4menu.contents.info.models.content)
                                end

                                if f4menu.contents.info.change then
                                    f4menu.contents.info.change:Remove()
                                end

                                f4menu.contents.info.change = f4menu.contents.info:Add("DButton")
                                f4menu.contents.info.change:Dock(TOP)
                                f4menu.contents.info.change:DockMargin(15, 15, 15, 0)
                                f4menu.contents.info.change:SetText("")
                                f4menu.contents.info.change:SetTall(75)
                                f4menu.contents.info.change.Paint = function(s, width, height)
                                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                                    draw.SimpleText("Become Job", "CategoryFont1", width / 2, height / 2, Color(255, 255, 255, 255), 1, 1)
                                end
                                f4menu.contents.info.change.DoClick = function()
                                    if val.vote or val.RequiresVote and val.RequiresVote(LocalPlayer(), val.team) then
                                        RunConsoleCommand("darkrp", "vote" .. val.command)
                                    else
                                        RunConsoleCommand("darkrp", val.command)
                                    end
                                    f4menu.main:Hide()
                                    gui.EnableScreenClicker(false)
                                end
                            end

                            f4menu.contents.joblist.category.contents.model = f4menu.contents.joblist.category.contents:Add("DModelPanel")
                            f4menu.contents.joblist.category.contents.model:SetModel(val.model[1])
                            f4menu.contents.joblist.category.contents.model:SetSize(f4menu.contents.joblist.category.contents:GetTall(), f4menu.contents.joblist.category.contents:GetTall())
                            f4menu.contents.joblist.category.contents.model:SetPos(0, 0)
                            f4menu.contents.joblist.category.contents.model:SetFOV(15)
                            f4menu.contents.joblist.category.contents.model:SetAnimated(false)
                            f4menu.contents.joblist.category.contents.model:SetCamPos(Vector(50, 0, 65))
                            f4menu.contents.joblist.category.contents.model:SetLookAt(Vector(0, 0, 65))

                            function f4menu.contents.joblist.category.contents.model:LayoutEntity(ent)
                            end

                            f4menu.contents.joblist.category.contents.model.DoClick = function()
                                f4menu.contents.info.description:SetText("Salary: £" .. val.salary .. "\n\n" .. "Weapons:\n" .. string.Replace(string.Replace(string.Replace(string.Replace(table.ToString(val.weapons, "", false), "{", ""), "}", ""), "=", ""), ",", "\n") .. "\n" .. val.description)

                                if f4menu.contents.info.models then
                                    f4menu.contents.info.models:Remove()
                                end

                                f4menu.contents.info.models = f4menu.contents.info:Add("DHorizontalScroller")
                                f4menu.contents.info.models:Dock(TOP)
                                f4menu.contents.info.models:DockMargin(15, 15, 15, 0)
                                f4menu.contents.info.models:SetOverlap(-5)
                                f4menu.contents.info.models:SetTall(75)
                                f4menu.contents.info.models.Paint = function(s, width, height)
                                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                                end

                                function f4menu.contents.info.models.btnLeft:Paint(width, height)
                                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                                end
                                function f4menu.contents.info.models.btnRight:Paint(width, height)
                                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                                end

                                for k, v in pairs(val.model) do
                                    f4menu.contents.info.models.content = f4menu.contents.info.models:Add("SpawnIcon")
                                    f4menu.contents.info.models.content:SetModel(v)
                                    f4menu.contents.info.models.content.DoClick = function()
                                        DarkRP.setPreferredJobModel(key, v)
                                    end

                                    f4menu.contents.info.models:AddPanel(f4menu.contents.info.models.content)
                                end

                                if f4menu.contents.info.change then
                                    f4menu.contents.info.change:Remove()
                                end

                                f4menu.contents.info.change = f4menu.contents.info:Add("DButton")
                                f4menu.contents.info.change:Dock(TOP)
                                f4menu.contents.info.change:DockMargin(15, 15, 15, 0)
                                f4menu.contents.info.change:SetText("")
                                f4menu.contents.info.change:SetTall(75)
                                f4menu.contents.info.change.Paint = function(s, width, height)
                                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                                    draw.SimpleText("Become Job", "CategoryFont1", width / 2, height / 2, Color(255, 255, 255, 255), 1, 1)
                                end
                                f4menu.contents.info.change.DoClick = function()
                                    if val.vote or val.RequiresVote and val.RequiresVote(LocalPlayer(), val.team) then
                                        RunConsoleCommand("darkrp", "vote" .. val.command)
                                    else
                                        RunConsoleCommand("darkrp", val.command)
                                    end
                                    f4menu.main:Hide()
                                    gui.EnableScreenClicker(false)
                                end
                            end
                        end
                    end
                end

                for k, v in pairs(DarkRP.getCategories().shipments) do
                    f4menu.contents.shipmentlist.category = f4menu.contents.shipmentlist:Add("DPanel")
                    f4menu.contents.shipmentlist.category:Dock(TOP)
                    f4menu.contents.shipmentlist.category:DockMargin(15, 15, 15, 0)
                    f4menu.contents.shipmentlist.category:SetTall(50)
                    f4menu.contents.shipmentlist.category.Paint = function(s, width, height)
                        draw.RoundedBox(0, 0, 0, width, height, v.color)
                        draw.SimpleText(v.name, "CategoryFont1", width / 2, height / 2, Color(255, 255, 255, 255), 1, 1)
                    end

                    for key, val in pairs(CustomShipments) do
                        if val.category == v.name then
                            f4menu.contents.shipmentlist.category.contents = f4menu.contents.shipmentlist:Add("DButton")
                            f4menu.contents.shipmentlist.category.contents:Dock(TOP)
                            f4menu.contents.shipmentlist.category.contents:DockMargin(50, 10, 50, 0)
                            f4menu.contents.shipmentlist.category.contents:SetText("")
                            f4menu.contents.shipmentlist.category.contents:SetTall(75)

                            f4menu.contents.shipmentlist.category.contents.Paint = function(s, width, height)
                                draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                                draw.RoundedBox(0, 0, height - 10, width, 10, v.color)
                                draw.SimpleText(val.name, "Trebuchet24", width / 2, height * 0.45, Color(255, 255, 255, 255), 1, 1)
                                draw.SimpleText("£" .. val.price, "Trebuchet24", width * 0.9, height * 0.45, Color(255, 255, 255, 255), 1, 1)
                            end

                            f4menu.contents.shipmentlist.category.contents.DoClick = function()
                                RunConsoleCommand("say", "/buyshipment " .. val.name)
                                f4menu.main:Hide()
                                gui.EnableScreenClicker(false)
                            end

                            f4menu.contents.shipmentlist.category.contents.model = f4menu.contents.shipmentlist.category.contents:Add("SpawnIcon")
                            f4menu.contents.shipmentlist.category.contents.model:SetModel(val.model)
                            f4menu.contents.shipmentlist.category.contents.model:SetSize(f4menu.contents.shipmentlist.category.contents:GetTall(), f4menu.contents.shipmentlist.category.contents:GetTall())
                            function f4menu.contents.shipmentlist.category.contents.model:IsHovered()
                            end
                            f4menu.contents.shipmentlist.category.contents.model.DoClick = function()
                                RunConsoleCommand("say", "/buyshipment " .. val.name)
                                f4menu.main:Hide()
                                gui.EnableScreenClicker(false)
                            end
                        end
                    end
                end

                for k, v in pairs(DarkRP.getCategories().entities) do
                    f4menu.contents.entitieslist.category = f4menu.contents.entitieslist:Add("DPanel")
                    f4menu.contents.entitieslist.category:Dock(TOP)
                    f4menu.contents.entitieslist.category:DockMargin(15, 15, 15, 0)
                    f4menu.contents.entitieslist.category:SetTall(50)
                    f4menu.contents.entitieslist.category.Paint = function(s, width, height)
                        draw.RoundedBox(0, 0, 0, width, height, v.color)
                        draw.SimpleText(v.name, "CategoryFont1", width / 2, height / 2, Color(255, 255, 255, 255), 1, 1)
                    end

                    for key, val in pairs(DarkRPEntities) do
                        if val.category == v.name then
                            f4menu.contents.entitieslist.category.contents = f4menu.contents.entitieslist:Add("DButton")
                            f4menu.contents.entitieslist.category.contents:Dock(TOP)
                            f4menu.contents.entitieslist.category.contents:DockMargin(50, 10, 50, 0)
                            f4menu.contents.entitieslist.category.contents:SetText("")
                            f4menu.contents.entitieslist.category.contents:SetTall(75)

                            f4menu.contents.entitieslist.category.contents.Paint = function(s, width, height)
                                draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                                draw.RoundedBox(0, 0, height - 10, width, 10, v.color)
                                draw.SimpleText(val.name, "Trebuchet24", width / 2, height * 0.45, Color(255, 255, 255, 255), 1, 1)
                                draw.SimpleText("£" .. val.price, "Trebuchet24", width * 0.9, height * 0.45, Color(255, 255, 255, 255), 1, 1)
                            end

                            f4menu.contents.entitieslist.category.contents.DoClick = function()
                                RunConsoleCommand("say", "/" .. val.cmd)
                                f4menu.main:Hide()
                                gui.EnableScreenClicker(false)
                            end

                            f4menu.contents.entitieslist.category.contents.model = f4menu.contents.entitieslist.category.contents:Add("SpawnIcon")
                            f4menu.contents.entitieslist.category.contents.model:SetModel(val.model)
                            f4menu.contents.entitieslist.category.contents.model:SetSize(f4menu.contents.entitieslist.category.contents:GetTall(), f4menu.contents.entitieslist.category.contents:GetTall())
                            function f4menu.contents.entitieslist.category.contents.model:IsHovered()
                            end
                            f4menu.contents.entitieslist.category.contents.model.DoClick = function()
                                RunConsoleCommand("say", "/" .. val.cmd)
                                f4menu.main:Hide()
                                gui.EnableScreenClicker(false)
                            end
                        end
                    end
                end

                f4menu.contents.ammolist.category = f4menu.contents.ammolist:Add("DPanel")
                f4menu.contents.ammolist.category:Dock(TOP)
                f4menu.contents.ammolist.category:DockMargin(15, 15, 15, 0)
                f4menu.contents.ammolist.category:SetTall(50)
                f4menu.contents.ammolist.category.Paint = function(s, width, height)
                    draw.RoundedBox(0, 0, 0, width, height, Color(0, 107, 0))
                    draw.SimpleText("Ammo", "CategoryFont1", width / 2, height / 2, Color(255, 255, 255, 255), 1, 1)
                end

                for key, val in pairs(GAMEMODE.AmmoTypes) do
                    f4menu.contents.ammolist.category.contents = f4menu.contents.ammolist:Add("DButton")
                    f4menu.contents.ammolist.category.contents:Dock(TOP)
                    f4menu.contents.ammolist.category.contents:DockMargin(50, 10, 50, 0)
                    f4menu.contents.ammolist.category.contents:SetText("")
                    f4menu.contents.ammolist.category.contents:SetTall(75)

                    f4menu.contents.ammolist.category.contents.Paint = function(s, width, height)
                        draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
                        draw.RoundedBox(0, 0, height - 10, width, 10, Color(0, 107, 0))
                        draw.SimpleText(val.name, "Trebuchet24", width / 2, height * 0.45, Color(255, 255, 255, 255), 1, 1)
                        draw.SimpleText("£" .. val.price, "Trebuchet24", width * 0.9, height * 0.45, Color(255, 255, 255, 255), 1, 1)
                    end

                    f4menu.contents.ammolist.category.contents.DoClick = function()
                        RunConsoleCommand("say", "/buyammo " .. key)
                        f4menu.main:Hide()
                        gui.EnableScreenClicker(false)
                    end

                    f4menu.contents.ammolist.category.contents.model = f4menu.contents.ammolist.category.contents:Add("SpawnIcon")
                    f4menu.contents.ammolist.category.contents.model:SetModel(val.model)
                    f4menu.contents.ammolist.category.contents.model:SetSize(f4menu.contents.ammolist.category.contents:GetTall(), f4menu.contents.ammolist.category.contents:GetTall())
                    function f4menu.contents.ammolist.category.contents.model:IsHovered()
                    end
                    f4menu.contents.ammolist.category.contents.model.DoClick = function()
                        RunConsoleCommand("say", "/buyammo " .. key)
                        f4menu.main:Hide()
                        gui.EnableScreenClicker(false)
                    end
                end
            end

            if net.ReadBit() == 0 then
                f4menu.main:Hide()
                gui.EnableScreenClicker(false)
            else
                f4menu.main:Show()
                gui.EnableScreenClicker(true)
            end
        end
    )
end
